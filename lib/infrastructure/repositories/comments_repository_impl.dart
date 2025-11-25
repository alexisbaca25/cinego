import 'package:cinemapedia/domain/entities/comments.dart';
import 'package:cinemapedia/infrastructure/datasources/comments_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/comments_repository.dart';
class CommentsRepositoryImpl extends CommentsRepository {
  
  final CommentsDatasource datasource;

  CommentsRepositoryImpl(this.datasource);

  @override
  Future<void> addComment(String movieId, String userId, String userName, String text) {
    return datasource.addComment(movieId, userId, userName, text);
  }

  @override
  Future<List<Comment>> getCommentsByMovie(String movieId) {
    return datasource.getCommentsByMovie(movieId);
  }
}