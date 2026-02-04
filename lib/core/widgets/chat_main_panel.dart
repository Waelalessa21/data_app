import 'package:data_app/core/models/chat_message.dart';
import 'package:data_app/core/widgets/chat_empty_state.dart';
import 'package:data_app/core/widgets/chat_messages_list.dart';
import 'package:data_app/pages/chat/ui/widgets/chat_header.dart';
import 'package:data_app/pages/chat/ui/widgets/chat_input.dart';
import 'package:data_app/pages/chat/ui/widgets/chat_mode_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatMainPanel extends StatelessWidget {
  final List<ChatMessage> messages;
  final String chatTitle;
  final ScrollController scrollController;
  final TextEditingController inputController;
  final bool isLoading;
  final bool isProcessing;
  final bool isFirstMessage;
  final VoidCallback onSendPressed;
  final Future<void> Function()? onReportTap;
  final Future<void> Function(String userPrompt, {String plotType})?
  onVisualizeTap;
  final Future<void> Function(String userPrompt)? onGenerateReportTap;

  const ChatMainPanel({
    super.key,
    required this.messages,
    required this.chatTitle,
    required this.scrollController,
    required this.inputController,
    required this.isLoading,
    required this.isProcessing,
    required this.isFirstMessage,
    required this.onSendPressed,
    this.onReportTap,
    this.onVisualizeTap,
    this.onGenerateReportTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ChatHeader(),
          const SizedBox(height: 12),
          const ChatModeIndicator(),
          const SizedBox(height: 16),
          Expanded(
            child:
                Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Expanded(
                            child: ChatMessagesList(
                              messages: messages,
                              chatTitle: chatTitle,
                              scrollController: scrollController,
                              isProcessing: isProcessing,
                              isFirstMessage: isFirstMessage,
                              emptyChild: const ChatEmptyState(),
                              onReportTap: onReportTap,
                              onVisualizeTap: onVisualizeTap,
                              onGenerateReportTap: onGenerateReportTap,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ChatInput(
                            controller: inputController,
                            onSubmitted: (_) => onSendPressed(),
                            onSendPressed: onSendPressed,
                            enabled: !isProcessing,
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 200.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                      delay: 200.ms,
                    ),
          ),
        ],
      ),
    );
  }
}
