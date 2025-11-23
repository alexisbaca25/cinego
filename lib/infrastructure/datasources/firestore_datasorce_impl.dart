import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/infrastructure/datasources/storage_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreDatasourceImpl extends StorageDatasource {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Future<void> toggleFavorite(Movie movie, String userId) async {
    final favoritesRef = _firestore.collection('users').doc(userId).collection('favorites');
    final doc = await favoritesRef.doc(movie.id.toString()).get();

    if (doc.exists) {
      await favoritesRef.doc(movie.id.toString()).delete();
    } else {
      await favoritesRef.doc(movie.id.toString()).set({
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'voteAverage': movie.voteAverage,
        'releaseDate': movie.releaseDate.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<bool> isMovieFavorite(int movieId, String userId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(movieId.toString())
        .get();
        
    return doc.exists;
  }

  @override
  Future<List<Movie>> loadMovies(String userId, {int limit = 10, int offset = 0}) async {
    try {
   
      final snapshot = await _firestore.collection('users').doc(userId).collection('favorites')
        .limit(limit)
        .get();

      if (snapshot.docs.isEmpty) return [];

      final List<Movie> movies = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        try {
          final movie = Movie(
            id:          data['id'],
            title:       data['title'],
            posterPath:  data['posterPath'],
            releaseDate: DateTime.parse(data['releaseDate']), 
            voteAverage: (data['voteAverage'] as num).toDouble(), 
            
            // Datos de relleno
            adult:             false,
            backdropPath:      data['posterPath'], 
            genreIds:          [],
            originalLanguage:  '',
            originalTitle:     '',
            overview:          '',
            popularity:        0.0,
            video:             false,
            voteCount:         0
          );

          movies.add(movie);

        } catch (e) {
        }
      }
      return movies;

    } catch (e) {
      return [];
    }
  }
}