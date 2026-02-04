import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_app/core/models/chat_conversation_model.dart';

class ChatHistoryService {
  ChatHistoryService._();
  static final ChatHistoryService instance = ChatHistoryService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'chat_conversations';

  String _generateTitle(List<ChatMessageModel> messages) {
    if (messages.isEmpty) return 'New Chat';
    final firstUserMessage = messages.firstWhere(
      (m) => m.sender == 'user',
      orElse: () => messages.first,
    );
    final text = firstUserMessage.text;
    if (text.length <= 50) return text;
    return '${text.substring(0, 47)}...';
  }

  Future<String> saveConversation(
    String userId,
    List<ChatMessageModel> messages, {
    String? conversationId,
    String? customTitle,
  }) async {
    final now = DateTime.now();
    final title = customTitle ?? _generateTitle(messages);

    if (conversationId != null) {
      await _firestore.collection(_collection).doc(conversationId).update({
        'title': title,
        'messages': messages.map((m) => m.toMap()).toList(),
        'updatedAt': Timestamp.fromDate(now),
      });
      return conversationId;
    } else {
      final doc = _firestore.collection(_collection).doc();
      final conversation = ChatConversationModel(
        id: doc.id,
        userId: userId,
        title: title,
        messages: messages,
        createdAt: now,
        updatedAt: now,
      );
      await doc.set(conversation.toMap());
      return doc.id;
    }
  }

  Stream<List<ChatConversationModel>> getUserConversations(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final conversations = snapshot.docs
              .map((doc) => ChatConversationModel.fromMap(doc.data()))
              .toList();
          conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return conversations;
        });
  }

  Future<ChatConversationModel?> getConversation(String conversationId) async {
    final doc = await _firestore
        .collection(_collection)
        .doc(conversationId)
        .get();
    if (!doc.exists) return null;
    return ChatConversationModel.fromMap(doc.data()!);
  }

  Future<void> deleteConversation(String conversationId) async {
    await _firestore.collection(_collection).doc(conversationId).delete();
  }

  Future<void> updateConversationTitle(
    String conversationId,
    String newTitle,
  ) async {
    await _firestore.collection(_collection).doc(conversationId).update({
      'title': newTitle,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}
