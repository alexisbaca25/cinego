import 'package:cinemapedia/domain/entities/comments.dart';

abstract class CommentsDatasource {
  Future<List<Comment>> getCommentsByMovie(String movieId);
  Future<void> addComment(String movieId, String userId, String userName, String text);
}