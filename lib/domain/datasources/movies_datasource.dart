import 'package:cinemapedia/domain/entities/actors.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/entities/video.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<List<Actor>> getActorsByMovie(String movieId);

  Future<List<Movie>> searchMovies(String query);

  Future<List<Video>> getYoutubeVideosById(int movieId);
}