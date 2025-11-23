import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/infrastructure/datasources/firestore_datasorce_impl.dart';
import 'package:cinemapedia/infrastructure/repositories/storage_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/provider/auth/auth_provider.dart';
import 'package:cinemapedia/infrastructure/repositories/storage_repository_impl.dart';
import 'package:flutter_riverpod/legacy.dart';

// Provider del Repositorio
final storageRepositoryProvider = Provider((ref) {
  return StorageRepositoryImpl(FirestoreDatasourceImpl());
});

//Provider para el Icono de Corazón
final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final storageRepository = ref.watch(storageRepositoryProvider);
  final user = ref.watch(authProvider).user;
  
  if (user == null) return false; 

  return storageRepository.isMovieFavorite(movieId, user.id);
});

// Lista de Favoritos 
final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final storageRepository = ref.watch(storageRepositoryProvider);
  return StorageMoviesNotifier(storageRepository: storageRepository);
});


class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  
  int page = 0;
  final StorageRepository storageRepository;

  StorageMoviesNotifier({ required this.storageRepository }): super({});

  Future<List<Movie>> loadNextPage(String userId) async {
    
    // Cargamos pelis de Firebase 
    final movies = await storageRepository.loadMovies(userId, offset: page * 10, limit: 20); 
    page++;

    // Convertimos la lista a un mapa para guardarlo en el estado
    final tempMap = <int, Movie>{};
    for (final movie in movies) {
      tempMap[movie.id] = movie;
    }

    // Actualizamos el estado agregando las nuevas pelis a las que ya teníamos
    state = { ...state, ...tempMap };
    
    return movies;
  }
}