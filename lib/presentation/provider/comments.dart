import 'package:cinemapedia/infrastructure/datasources/fire_store_comments.dart';
import 'package:cinemapedia/infrastructure/repositories/comments_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/comment.dart';


// Repositorio
final commentsRepositoryProvider = Provider((ref) {
  return CommentsRepositoryImpl(FirestoreCommentsDatasource());
});

//  Provider de lista de comentarios
final commentsByMovieProvider = FutureProvider.family.autoDispose<List<Comment>, String>((ref, movieId) {
  final repository = ref.watch(commentsRepositoryProvider);
  return repository.getCommentsByMovie(movieId);
});