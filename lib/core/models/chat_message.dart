import 'package:data_app/core/models/chat_query_result.dart';

enum ChatSender { user, system }

class ChatMessage {
  final String id;
  final ChatSender sender;
  final String text;
  final ChatQueryResult? queryResult;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.queryResult,
  });
}
