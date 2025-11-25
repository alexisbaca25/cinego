import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  Stream<List<Movie>> get onNewMovies => debouncedMovies.stream;

  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  });

  void clearStreams() {
    debouncedMovies.close();
  }

  void _onQueryChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      
      if (query.isEmpty) {
        debouncedMovies.add([]);
        return;
      }

      final movies = await searchMovies(query);

      // --- MEJORA DE PRECISIÓN ---
      // Reordenamos la lista localmente para dar prioridad a coincidencias exactas
      final cleanQuery = query.toLowerCase().trim();
      
      movies.sort((a, b) {
        final titleA = a.title.toLowerCase();
        final titleB = b.title.toLowerCase();

        // 1. Prioridad Máxima: Coincidencia Exacta
        if (titleA == cleanQuery && titleB != cleanQuery) return -1;
        if (titleB == cleanQuery && titleA != cleanQuery) return 1;

        // 2. Prioridad Alta: Empieza con la búsqueda
        final aStartsWith = titleA.startsWith(cleanQuery);
        final bStartsWith = titleB.startsWith(cleanQuery);

        if (aStartsWith && !bStartsWith) return -1;
        if (bStartsWith && !aStartsWith) return 1;

        // 3. Si no, mantenemos el orden de popularidad de la API
        return 0;
      });
      // ---------------------------

      initialMovies = movies;
      debouncedMovies.add(movies);
    });
  }

  @override
  String get searchFieldLabel => 'Buscar película...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(
          onPressed: () => query = '', 
          icon: const Icon(Icons.clear)
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back_ios_new_rounded)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: onNewMovies,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index], 
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({ required this.movie, required this.onMovieSelected });

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        // Agregamos un fondo sutil al hacer hover/tap implícito
        decoration: BoxDecoration(
          color: Colors.transparent, 
          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1)))
        ),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  height: 100,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                ),
              ),
            ),
    
            const SizedBox( width: 15 ),
            
            // Description
            SizedBox(
              width: size.width * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // Título
                  Text( 
                    movie.title, 
                    style: textStyles.titleMedium?.copyWith(fontWeight: FontWeight.bold) 
                  ),
                  
                  const SizedBox(height: 5),

                  // AÑO + Rating (Esto ayuda mucho a la precisión visual)
                  Row(
                    children: [
                      // Año
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(
                          movie.releaseDate.year.toString(),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.primary),
                        ),
                      ),
                      
                      const SizedBox(width: 10),

                      // Estrellas
                      Icon( Icons.star_rounded, color: Colors.amber.shade800, size: 16 ),
                      const SizedBox( width: 3 ),
                      Text( 
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!.copyWith(color: Colors.amber.shade900, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // Descripción corta
                  Text( 
                    movie.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}