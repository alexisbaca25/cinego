import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/provider/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final videosByMovieProvider = StateNotifierProvider<VideosByMovieNotifier, Map<String, List<Video>>>((ref) {
  final moviesRepository = ref.watch( moviesRepositoryProvider );
  return VideosByMovieNotifier(getRepositoryVideos: moviesRepository.getYoutubeVideosById);
});

typedef GetVideosCallback = Future<List<Video>> Function(int movieId);

class VideosByMovieNotifier extends StateNotifier<Map<String, List<Video>>> {
  
  final GetVideosCallback getRepositoryVideos;
  
  VideosByMovieNotifier({ required this.getRepositoryVideos }): super({});

  Future<void> loadVideos( String movieId ) async {
    if ( state[movieId] != null ) return;

    final List<Video> videos = await getRepositoryVideos( int.parse(movieId) );
    state = { ...state, movieId: videos };
  }
}