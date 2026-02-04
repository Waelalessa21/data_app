import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreConnectionsService {
  FirestoreConnectionsService._();
  static final FirestoreConnectionsService instance =
      FirestoreConnectionsService._();

  static const String _usersCollection = 'users';
  static const String _connectionsSubcollection = 'connections';

  Future<void> saveConnection({
    required String userId,
    required String userEmail,
    required Map<String, dynamic> connectionInfo,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection(_usersCollection).doc(userId);
    await userRef.set({'email': userEmail}, SetOptions(merge: true));
    await userRef.collection(_connectionsSubcollection).add({
      'connection_info': connectionInfo,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getConnectionsForUser(
    String userId,
  ) async {
    final snap = await FirebaseFirestore.instance
        .collection(_usersCollection)
        .doc(userId)
        .collection(_connectionsSubcollection)
        .orderBy('created_at', descending: true)
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'connection_info': data['connection_info'] ?? <String, dynamic>{},
        'created_at':
            (data['created_at'] as Timestamp?)?.millisecondsSinceEpoch,
      };
    }).toList();
  }
}
