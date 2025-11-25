import 'package:cinemapedia/infrastructure/datasources/comments_datasorce.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/comment.dart';

class FirestoreCommentsDatasource extends CommentsDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addComment(String movieId, String userId, String userName, String text) async {
    await _firestore.collection('comments').add({
      'movieId': movieId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<Comment>> getCommentsByMovie(String movieId) async {
    final query = await _firestore.collection('comments')
        .where('movieId', isEqualTo: movieId)
        .orderBy('timestamp', descending: true) 
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['timestamp'] as Timestamp?; 
      
      return Comment(
        id: doc.id,
        movieId: data['movieId'],
        userId: data['userId'],
        userName: data['userName'] ?? 'Usuario',
        text: data['text'],
        timestamp: timestamp?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }
}