import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/presentation/provider/movies/genres_provider.dart';

class GenreScreen extends ConsumerStatefulWidget {
  
  final String genreId;
  final String genreName;

  const GenreScreen({
    super.key, 
    required this.genreId, 
    required this.genreName
  });

  @override
  GenreScreenState createState() => GenreScreenState();
}

class GenreScreenState extends ConsumerState<GenreScreen> {
  
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cargar la primera página
    ref.read(moviesByGenreProvider(int.parse(widget.genreId)).notifier).loadNextPage();

    // Infinite Scroll
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent) {
        ref.read(moviesByGenreProvider(int.parse(widget.genreId)).notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final movies = ref.watch(moviesByGenreProvider(int.parse(widget.genreId)));

    if (movies.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genreName),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _MovieItem(movie: movie);
        },
      ),
    );
  }
}

// Reutilizamos un diseño simple tipo tarjeta para la lista
class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            // Poster
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
              child: Image.network(
                movie.posterPath,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(width: 100, height: 150, child: Icon(Icons.error)),
              ),
            ),
            const SizedBox(width: 10),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(
                      movie.overview, 
                      maxLines: 3, 
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 15),
                        Text(' ${movie.voteAverage}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}