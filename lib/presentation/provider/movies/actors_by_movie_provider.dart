import 'package:cinemapedia/domain/entities/actors.dart';
import 'package:cinemapedia/presentation/provider/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final moviesRepository = ref.watch(moviesRepositoryProvider);
  
  return ActorsByMovieNotifier(getActors: moviesRepository.getActorsByMovie);
});

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors
  }): super({});

  Future<void> loadActors( String movieId ) async {
    if ( state[movieId] != null ) return;

    final List<Actor> actors = await getActors(movieId);
    state = { ...state, movieId: actors };
  }
}