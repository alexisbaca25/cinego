import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/infrastructure/datasources/storage_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/storage_repositories.dart';

class StorageRepositoryImpl extends StorageRepository {
  final StorageDatasource datasource;
  StorageRepositoryImpl(this.datasource);

  @override
  Future<void> toggleFavorite(Movie movie, String userId) {
    return datasource.toggleFavorite(movie, userId);
  }

  @override
  Future<bool> isMovieFavorite(int movieId, String userId) {
    return datasource.isMovieFavorite(movieId, userId);
  }

  @override
  Future<List<Movie>> loadMovies(String userId, {int limit = 10, int offset = 0}) {
    return datasource.loadMovies(userId, limit: limit, offset: offset);
  }
}