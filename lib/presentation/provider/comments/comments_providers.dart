import 'package:cinemapedia/domain/entities/comments.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/datasources/comments_datasource_impl.dart';
import '../../../infrastructure/repositories/comments_repository_impl.dart';

// 1. Provider del Repositorio
final commentsRepositoryProvider = Provider((ref) {
  return CommentsRepositoryImpl(CommentsDatasourceImpl());
});

// 2. Provider para obtener la lista de comentarios
// Usamos .family porque necesitamos el ID de la película
final commentsByMovieProvider = FutureProvider.family.autoDispose<List<Comment>, String>((ref, movieId) {
  
  final repository = ref.watch(commentsRepositoryProvider);
  return repository.getCommentsByMovie(movieId);
});