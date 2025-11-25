import 'package:cinemapedia/domain/entities/comment.dart';

abstract class CommentsRepository {
  
  Future<List<Comment>> getCommentsByMovie(String movieId);
  
  Future<void> addComment(String movieId, String userId, String userName, String text);

}