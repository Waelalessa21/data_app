import 'package:data_app/core/models/chat_conversation_model.dart';
import 'package:data_app/core/routing/routes.dart';
import 'package:data_app/core/services/chat_history_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

class ChatHistoryItem extends StatelessWidget {
  final ChatConversationModel conversation;
  final int index;

  const ChatHistoryItem({
    super.key,
    required this.conversation,
    required this.index,
  });

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: conversation.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text('Rename Chat', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter new name',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                await ChatHistoryService.instance.updateConversationTitle(
                  conversation.id,
                  newTitle,
                );
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text('Delete Chat', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this conversation?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              await ChatHistoryService.instance.deleteConversation(
                conversation.id,
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red.shade300)),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDismiss(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFF424141)),
        ),
        title: Text('Delete Chat', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this conversation?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red.shade300)),
          ),
        ],
      ),
    );
  }

  void _onDismissed(BuildContext context) {
    ChatHistoryService.instance.deleteConversation(conversation.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chat deleted'),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks != 1 ? 's' : ''} ago';
    } else {
      final months = (diff.inDays / 30).floor();
      return '$months month${months != 1 ? 's' : ''} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDismiss(context),
      onDismissed: (_) => _onDismissed(context),
      background: Container(
        color: Colors.red.shade900,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      child:
          InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.chat,
                    arguments: {'conversationId': conversation.id},
                  );
                },
                onLongPress: () => _showRenameDialog(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.message,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversation.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${conversation.messages.length} messages · ${_formatDate(conversation.updatedAt)}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Iconsax.trash,
                          size: 18,
                          color: Colors.red.shade300.withValues(alpha: 0.7),
                        ),
                        onPressed: () => _showDeleteConfirmation(context),
                        padding: EdgeInsets.all(8),
                        constraints: BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ),
              )
              .animate(key: ValueKey(conversation.id))
              .fadeIn(duration: 300.ms, delay: (index * 50).ms)
              .slideX(
                begin: 0.2,
                end: 0,
                duration: 400.ms,
                delay: (index * 50).ms,
              ),
    );
  }
}
