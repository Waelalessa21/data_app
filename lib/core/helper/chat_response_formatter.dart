import 'package:data_app/core/models/chat_query_result.dart';

class ChatResponseFormatter {
  ChatResponseFormatter._();

  /// Removes ANSI escape sequences (e.g. [4m, [0m) so they don't break SQL or context.
  static String stripAnsiCodes(String text) {
    if (text.isEmpty) return text;
    // CSI sequences: literal [digits;...m or escape \x1b[...
    return text
        .replaceAll(RegExp(r'\x1b\[[0-9;]*m'), '')
        .replaceAll(RegExp(r'\[\d+(;\d+)*m'), '')
        .trim();
  }

  static ChatQueryResult parse({
    required String sql,
    List<dynamic>? results,
    String? imageUrl,
  }) {
    final headers = <String>[];
    final rows = <List<dynamic>>[];

    if (results != null && results.isNotEmpty) {
      final headersRaw = results[0] as List<dynamic>?;
      final rowsList = results.length > 1 ? results[1] as List<dynamic>? : null;
      if (headersRaw != null) {
        headers.addAll(headersRaw.map((e) => e.toString()));
      }
      if (rowsList != null) {
        for (final r in rowsList) {
          if (r is List) {
            rows.add(r.map((e) => e).toList());
          }
        }
      }
    }

    final cleanSql = stripAnsiCodes(sql.trim());
    return ChatQueryResult(
      sql: cleanSql,
      headers: headers,
      rows: rows,
      imageUrl: imageUrl,
    );
  }
}
