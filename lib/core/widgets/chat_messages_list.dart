import 'package:data_app/core/models/chat_message.dart'
    show ChatMessage, ChatSender;
import 'package:data_app/core/theming/ai_processing_bubble.dart';
import 'package:data_app/core/theming/ai_simple_processing_bubble.dart';
import 'package:data_app/pages/chat/ui/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessagesList extends StatelessWidget {
  final List<ChatMessage> messages;
  final String chatTitle;
  final ScrollController scrollController;
  final bool isProcessing;
  final bool isFirstMessage;
  final Widget emptyChild;
  final Future<void> Function()? onReportTap;
  final Future<void> Function(String userPrompt, {String plotType})?
  onVisualizeTap;
  final Future<void> Function(String userPrompt)? onGenerateReportTap;

  const ChatMessagesList({
    super.key,
    required this.messages,
    required this.chatTitle,
    required this.scrollController,
    required this.isProcessing,
    required this.isFirstMessage,
    required this.emptyChild,
    this.onReportTap,
    this.onVisualizeTap,
    this.onGenerateReportTap,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty && !isProcessing) {
      return emptyChild;
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length + (isProcessing ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isProcessing) {
          return isFirstMessage
              ? AiProcessingBubble(index: index)
              : AiSimpleProcessingBubble(index: index);
        }
        final message = messages[index];
        final precedingUserPrompt =
            index > 0 &&
                message.sender == ChatSender.system &&
                message.queryResult != null
            ? messages[index - 1].text
            : null;
        return ChatBubble(
          message: message,
          index: index,
          onReportTap: onReportTap,
          onGenerateReportTap:
              onGenerateReportTap != null && precedingUserPrompt != null
              ? () => onGenerateReportTap!(precedingUserPrompt)
              : null,
          onVisualizeTap: onVisualizeTap != null && precedingUserPrompt != null
              ? () => onVisualizeTap!(precedingUserPrompt, plotType: 'bar')
              : null,
        );
      },
    );
  }
}
