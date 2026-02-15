import 'dart:convert';

import 'package:data_app/core/auth/auth_service.dart';
import 'package:data_app/core/database/database_service.dart';
import 'package:data_app/core/models/chat_conversation_model.dart';
import 'package:data_app/core/models/chat_message.dart';
import 'package:data_app/core/models/chat_query_result.dart';
import 'package:data_app/core/routing/routes.dart';
import 'package:data_app/core/services/chat_api_service.dart';
import 'package:data_app/core/services/chat_history_service.dart';
import 'package:data_app/core/services/chat_report_pdf_service.dart'
    show ChatReportPdfService, PdfExportStatus;
import 'package:data_app/core/services/data_mode_service.dart';
import 'package:data_app/core/services/firestore_connections_service.dart';
import 'package:data_app/core/widgets/chat_app_scaffold.dart';
import 'package:data_app/core/widgets/chat_main_panel.dart';
import 'package:data_app/core/widgets/connect_data_popup.dart';
import 'package:data_app/pages/chat/ui/widgets/chat_history_list.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String initialPrompt;
  final String? conversationId;

  const ChatScreen({super.key, this.initialPrompt = '', this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentConversationId;
  String _chatTitle = 'Chat Report';
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isProcessing = false;
  bool _isFirstMessage = true;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation() async {
    try {
      if (widget.conversationId != null) {
        final conversation = await ChatHistoryService.instance.getConversation(
          widget.conversationId!,
        );
        if (conversation != null && mounted) {
          setState(() {
            _currentConversationId = conversation.id;
            _chatTitle = conversation.title;
            _messages.addAll(
              conversation.messages.map(
                (m) => ChatMessage(
                  id: m.id,
                  sender: m.sender == 'user'
                      ? ChatSender.user
                      : ChatSender.system,
                  text: m.text,
                  queryResult: m.queryResult != null
                      ? ChatQueryResult.fromJson(m.queryResult!)
                      : null,
                ),
              ),
            );
            _isLoading = false;
            _isFirstMessage = false;
          });
          _scrollToBottom();
          return;
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (widget.initialPrompt.isNotEmpty) {
        await _checkDatabaseConnectionAndSend(widget.initialPrompt);
      }
    } catch (e) {
      debugPrint('Error loading conversation: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _exportReport() async {
    final title =
        _messages
            .cast<ChatMessage?>()
            .firstWhere(
              (m) => m != null && m.sender == ChatSender.user,
              orElse: () => null,
            )
            ?.text ??
        _chatTitle;
    if (_chatTitle == 'Chat Report' && _messages.isNotEmpty) {
      setState(() {
        _chatTitle = title.length > 50 ? '${title.substring(0, 47)}...' : title;
      });
    }
    final result = await ChatReportPdfService.instance
        .exportAndShareWithFallback(
          chatTitle: _chatTitle,
          messages: List.from(_messages),
        );
    if (!mounted) return;
    if (result.status == PdfExportStatus.reduced && result.message != null) {
      await _addSystemMessage(result.message!, autoSave: true);
    } else if (result.status == PdfExportStatus.failure &&
        result.message != null) {
      await _addSystemMessage(result.message!, autoSave: true);
    }
  }

  void _addUserMessage(String text, {bool autoSave = true}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      if (_chatTitle == 'Chat Report') {
        _chatTitle = trimmed.length > 50
            ? '${trimmed.substring(0, 47)}...'
            : trimmed;
      }
      _messages.add(
        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          sender: ChatSender.user,
          text: trimmed,
        ),
      );
    });
    _scrollToBottom();
    if (autoSave) _saveConversation();
  }

  Future<void> _addSystemMessage(
    String text, {
    bool autoSave = true,
    ChatQueryResult? queryResult,
    bool clearProcessing = false,
  }) async {
    if (!mounted) return;
    setState(() {
      if (clearProcessing) {
        _isProcessing = false;
        if (_isFirstMessage) _isFirstMessage = false;
      }
      _messages.add(
        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          sender: ChatSender.system,
          text: text,
          queryResult: queryResult,
        ),
      );
    });
    _scrollToBottom();
    if (autoSave) _saveConversation();
  }

  Future<void> _saveConversation() async {
    if (_isSaving) return;

    final user = AuthService.instance.currentUser;
    if (user == null || _messages.isEmpty) return;

    _isSaving = true;
    final chatMessages = _messages
        .map(
          (m) => ChatMessageModel(
            id: m.id,
            sender: m.sender == ChatSender.user ? 'user' : 'system',
            text: m.text,
            timestamp: DateTime.now(),
            queryResult: m.queryResult?.toFirestoreMap(),
          ),
        )
        .toList();

    try {
      final conversationId = await ChatHistoryService.instance.saveConversation(
        user.uid,
        chatMessages,
        conversationId: _currentConversationId,
      );
      if (mounted && _currentConversationId == null) {
        setState(() => _currentConversationId = conversationId);
      }
    } catch (e) {
      debugPrint('Error saving conversation: $e');
    } finally {
      _isSaving = false;
    }
  }

  Future<bool> _checkDatabaseConnection() async {
    if (DataModeService.instance.isTestDataMode) return true;

    final user = AuthService.instance.currentUser;
    if (user == null) return false;

    final connections = await DatabaseService.instance.getDbConnectionsForUser(
      user.email ?? '',
    );

    if (connections.isEmpty) {
      if (!mounted) return false;
      final result = await ConnectDataPopup.show(context);
      if (result == null) return false;

      await DatabaseService.instance.saveDbConnection(
        userEmail: user.email ?? '',
        connectionInfo: result,
      );

      if (user.uid.isNotEmpty) {
        await FirestoreConnectionsService.instance.saveConnection(
          userId: user.uid,
          userEmail: user.email ?? '',
          connectionInfo: result,
        );
      }
    }
    return true;
  }

  static const int _contextMessageCount = 4;

  List<Map<String, String>> _buildContext({bool excludeLast = false}) {
    final list = _messages;
    final end = excludeLast && list.length > 1 ? list.length - 1 : list.length;
    final forContext = list.take(end).toList();
    final start = forContext.length > _contextMessageCount
        ? forContext.length - _contextMessageCount
        : 0;
    final trimmed = forContext.sublist(start);
    return trimmed.map((m) {
      final role = m.sender == ChatSender.user ? 'user' : 'assistant';
      final content = m.queryResult != null
          ? 'Results: ${m.queryResult!.rows.length} rows'
          : m.text;
      return {'role': role, 'content': content};
    }).toList();
  }

  Future<void> _sendToApi(
    String userPrompt, {
    bool visualize = false,
    String plotType = 'bar',
    bool generateReport = false,
  }) async {
    final payload = ChatApiService.instance.buildRequestPayload(
      userPrompt: userPrompt,
      isFirstMessage: _isFirstMessage,
      conversationHistory: _buildContext(excludeLast: true),
      visualize: visualize,
      plotType: plotType,
      generateReport: generateReport,
    );
    debugPrint('Chat API request: ${jsonEncode(payload)}');

    setState(() => _isProcessing = true);
    _scrollToBottom();

    try {
      final response = await ChatApiService.instance.sendRequest(payload);
      if (mounted) {
        if (response is ChatQueryResult) {
          await _addSystemMessage(
            '',
            autoSave: true,
            queryResult: response,
            clearProcessing: true,
          );
        } else {
          await _addSystemMessage(
            response.toString(),
            autoSave: true,
            clearProcessing: true,
          );
        }
      }
    } on ChatApiException catch (e) {
      debugPrint('Chat API error: $e');
      if (mounted) {
        await _addSystemMessage('Error: $e', autoSave: true, clearProcessing: true);
      }
    }
  }

  Future<void> _checkDatabaseConnectionAndSend(String message) async {
    final hasConnection = await _checkDatabaseConnection();
    if (!hasConnection) return;
    _addUserMessage(message, autoSave: false);
    await _sendToApi(message);
  }

  Future<void> _handleVisualize(
    String userPrompt, {
    String plotType = 'bar',
  }) async {
    await _sendToApi(userPrompt, visualize: true, plotType: plotType);
  }

  Future<void> _handleGenerateReport(String userPrompt) async {
    await _sendToApi(userPrompt, generateReport: true);
  }

  Future<void> _handleSubmit() async {
    final value = _controller.text.trim();
    if (value.isEmpty) return;

    final hasConnection = await _checkDatabaseConnection();
    _controller.clear();
    _addUserMessage(value, autoSave: false);
    if (!hasConnection) {
      if (mounted) {
        final user = AuthService.instance.currentUser;
        await _addSystemMessage(
          user == null
              ? 'Please sign in to chat with your data.'
              : 'Please connect a database to continue.',
          autoSave: true,
        );
      }
      return;
    }
    await _sendToApi(value);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChatAppScaffold(
      homeRoute: Routes.home,
      mainChild: ChatMainPanel(
        messages: _messages,
        chatTitle: _chatTitle,
        scrollController: _scrollController,
        inputController: _controller,
        isLoading: _isLoading,
        isProcessing: _isProcessing,
        isFirstMessage: _isFirstMessage,
        onSendPressed: _handleSubmit,
        onReportTap: _exportReport,
        onVisualizeTap: _handleVisualize,
        onGenerateReportTap: _handleGenerateReport,
      ),
      historyChild: const ChatHistoryList(),
      showDrawerButton: true,
    );
  }
}
