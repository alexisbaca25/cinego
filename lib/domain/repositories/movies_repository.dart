import 'package:cinemapedia/domain/entities/actors.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<List<Actor>> getActorsByMovie(String movieId);

  Future<List<Movie>> searchMovies(String query);

  Future<List<Video>> getYoutubeVideosById(int movieId);

  Future<List<Genre>> getGenres();
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1});
}