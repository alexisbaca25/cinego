
// 1. Provider para obtener la lista de géneros (Se carga una sola vez)
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/presentation/provider/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final genresProvider = FutureProvider<List<Genre>>((ref) async {
  final moviesRepository = ref.watch(moviesRepositoryProvider);
  return await moviesRepository.getGenres();
});

// 2. Provider para cargar películas por género (Paginado)
final moviesByGenreProvider = StateNotifierProvider.family<MoviesByGenreNotifier, List<Movie>, int>((ref, genreId) {
  final moviesRepository = ref.read(moviesRepositoryProvider);
  return MoviesByGenreNotifier(
    fetchMoreMovies: ({int page = 1}) => moviesRepository.getMoviesByGenre(genreId, page: page)
  );
});

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesByGenreNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  final MovieCallback fetchMoreMovies;

  MoviesByGenreNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    
    final List<Movie> newMovies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...newMovies];
    
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}