import 'package:data_app/core/auth/auth_service.dart';
import 'package:data_app/core/models/chat_conversation_model.dart';
import 'package:data_app/core/services/chat_history_service.dart';
import 'package:flutter/material.dart';

import 'chat_history_empty_state.dart';
import 'chat_history_error_state.dart';
import 'chat_history_header.dart';
import 'chat_history_item.dart';

class ChatHistoryList extends StatelessWidget {
  const ChatHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = AuthService.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(
        child: Text(
          'Please sign in to view chat history',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      );
    }

    return StreamBuilder<List<ChatConversationModel>>(
      stream: ChatHistoryService.instance.getUserConversations(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white54,
            ),
          );
        }

        if (snapshot.hasError) {
          return ChatHistoryErrorState(error: snapshot.error.toString());
        }

        final conversations = snapshot.data ?? [];

        if (conversations.isEmpty) {
          return const ChatHistoryEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatHistoryHeader(conversationCount: conversations.length),
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
            Expanded(
              child: ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  return ChatHistoryItem(
                    conversation: conversations[index],
                    index: index,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
