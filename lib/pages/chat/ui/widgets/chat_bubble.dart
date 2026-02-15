import 'package:data_app/core/models/chat_message.dart';
import 'package:data_app/core/widgets/chat_query_result_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final int index;
  final Future<void> Function()? onReportTap;
  final Future<void> Function()? onGenerateReportTap;
  final Future<void> Function()? onVisualizeTap;

  const ChatBubble({
    super.key,
    required this.message,
    required this.index,
    this.onReportTap,
    this.onGenerateReportTap,
    this.onVisualizeTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatSender.user;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final backgroundColor = isUser ? Colors.white : Colors.black;
    final textColor = isUser ? Colors.black : Colors.white;
    final borderColor = Colors.white.withOpacity(0.2);
    final crossAlign = isUser
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    Widget content;
    if (message.queryResult != null && !isUser) {
      content = ChatQueryResultView(
        result: message.queryResult!,
        isUser: isUser,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    } else {
      content = Text(
        message.text,
        style: TextStyle(color: textColor, fontSize: 14, height: 1.4),
      );
    }

    return Align(
      alignment: alignment,
      child:
          Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: crossAlign,
                  children: [
                    Text(
                      isUser ? 'You' : 'System',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 520),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: crossAlign,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          content,
                          if (!isUser && message.queryResult != null) ...[
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ActionIcon(
                                  icon: Iconsax.document_text_1,
                                  tooltip: 'Generate report',
                                  color: textColor,
                                  onTap: () async {
                                    if (onGenerateReportTap != null) {
                                      await onGenerateReportTap!();
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                _ActionIcon(
                                  icon: Iconsax.chart_2,
                                  tooltip: 'Visualize',
                                  color: textColor,
                                  onTap: () async {
                                    if (onVisualizeTap != null) {
                                      await onVisualizeTap!();
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                _ActionIcon(
                                  icon: Icons.picture_as_pdf_outlined,
                                  tooltip: 'Export PDF',
                                  color: textColor,
                                  onTap: () async {
                                    if (onReportTap != null) {
                                      await onReportTap!();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate(key: ValueKey(message.id))
              .fadeIn(duration: 300.ms, curve: Curves.easeOut)
              .slideY(
                begin: isUser ? 0.2 : -0.2,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutCubic,
              )
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                duration: 300.ms,
                curve: Curves.easeOut,
              ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: color.withOpacity(0.7)),
        ),
      ),
    );
  }
}
