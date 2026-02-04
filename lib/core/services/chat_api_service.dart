import 'dart:convert';

import 'package:data_app/core/helper/chat_response_formatter.dart';
import 'package:data_app/core/models/active_connection_model.dart';
import 'package:data_app/core/services/data_mode_service.dart';
import 'package:http/http.dart' as http;

class ChatApiService {
  ChatApiService._();
  static final ChatApiService instance = ChatApiService._();

  static const String _baseUrl =
      'https://text-to-sql-production-8ed8.up.railway.app';

  Map<String, dynamic> buildRequestPayload({
    required String userPrompt,
    required bool isFirstMessage,
    required List<Map<String, String>> conversationHistory,
    bool visualize = false,
    String plotType = 'bar',
  }) {
    final isTestMode = DataModeService.instance.isTestDataMode;

    final payload = <String, dynamic>{
      'user_prompt': userPrompt,
      'context': isFirstMessage ? '' : jsonEncode(conversationHistory),
      'connection_details': isTestMode ? null : _getConnectionDetails(),
    };

    if (visualize) {
      payload['visualize'] = true;
      payload['plot_type'] = plotType;
    }

    return payload;
  }

  Map<String, dynamic>? _getConnectionDetails() {
    final conn = ActiveConnectionModel.instance.activeConnection;
    if (conn == null) return null;

    final info = conn['connection_info'];
    if (info is! Map<String, dynamic>) return null;

    return {
      'db_type': info['db_type'],
      'host': info['host'],
      'port': info['port'],
      'database_name': info['database_name'],
      'username': info['username'],
      'password': info['password'],
    };
  }

  Future<dynamic> sendRequest(Map<String, dynamic> payload) async {
    final uri = Uri.parse('$_baseUrl/ask');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw ChatApiException(
        'API error: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }

    print('Chat API response: ${response.body}');
    final decoded = jsonDecode(response.body);
    if (decoded is String) return decoded;
    final data = decoded as Map<String, dynamic>;

    final status = data['status'] as String?;
    if (status != 'success') {
      final raw =
          data['error']?.toString() ??
          data['detail']?.toString() ??
          'Request failed. Please try again.';
      final message = ChatResponseFormatter.stripAnsiCodes(raw);
      throw ChatApiException(message);
    }

    final sql = data['generated_sql'] as String? ?? '';
    final results = data['results'] as List<dynamic>?;
    final imageUrl = data['image_url'] as String?;
    return ChatResponseFormatter.parse(
      sql: sql,
      results: results,
      imageUrl: imageUrl,
    );
  }
}

class ChatApiException implements Exception {
  final String message;
  final int? statusCode;

  ChatApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
