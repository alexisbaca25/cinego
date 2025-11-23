import 'package:cinemapedia/domain/entities/movies.dart';

abstract class StorageRepository {
  Future<void> toggleFavorite(Movie movie, String userId);
  Future<bool> isMovieFavorite(int movieId, String userId);
  Future<List<Movie>> loadMovies(String userId, {int limit = 10, int offset = 0});
}