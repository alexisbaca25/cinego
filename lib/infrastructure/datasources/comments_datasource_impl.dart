import 'package:cinemapedia/infrastructure/datasources/comments_datasorce.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/comment.dart';

class CommentsDatasourceImpl extends CommentsDatasource {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addComment(String movieId, String userId, String userName, String text) async {
    // Agregamos un nuevo documento a la colección comments
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

    // Transformamos la respuesta de Firebase
    final comments = query.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['timestamp'] as Timestamp?; 

      return Comment(
        id: doc.id,
        movieId: data['movieId'],
        userId: data['userId'],
        userName: data['userName'] ?? 'Anónimo',
        text: data['text'] ?? '',
        timestamp: timestamp?.toDate() ?? DateTime.now(),
      );
    }).toList();

    return comments;
  }
}