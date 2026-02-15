import 'package:cloud_firestore/cloud_firestore.dart';

class ChatConversationModel {
  final String id;
  final String userId;
  final String title;
  final List<ChatMessageModel> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatConversationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'messages': messages.map((m) => m.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory ChatConversationModel.fromMap(Map<String, dynamic> map) {
    return ChatConversationModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      messages: (map['messages'] as List<dynamic>)
          .map((m) => ChatMessageModel.fromMap(m as Map<String, dynamic>))
          .toList(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  ChatConversationModel copyWith({
    String? id,
    String? userId,
    String? title,
    List<ChatMessageModel>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatConversationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ChatMessageModel {
  final String id;
  final String sender;
  final String text;
  final DateTime timestamp;
  final Map<String, dynamic>? queryResult;

  ChatMessageModel({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.queryResult,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      if (queryResult != null) 'queryResult': queryResult,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] as String,
      sender: map['sender'] as String,
      text: map['text'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      queryResult: map['queryResult'] as Map<String, dynamic>?,
    );
  }
}
