
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/presentation/provider/movies/genres_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final genresAsync = ref.watch(genresProvider);

    if (genresAsync.isLoading) {
      return const FullScreenLoader();
    }

    if (genresAsync.hasError) {
      return Center(child: Text('Error al cargar categorías'));
    }

    final genres = genresAsync.value!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: genres.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columnas
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.6, // Tarjetas rectangulares
          ),
          itemBuilder: (context, index) {
            return _GenreCard(genre: genres[index]);
          },
        ),
      ),
    );
  }
}

class _GenreCard extends StatelessWidget {
  final Genre genre;

  const _GenreCard({required this.genre});

  @override
  Widget build(BuildContext context) {
    // Generamos un color base aleatorio o basado en el ID para que sea consistente
    final colors = [
      Colors.blueAccent, Colors.purpleAccent, Colors.redAccent, Colors.orangeAccent,
      Colors.greenAccent, Colors.pinkAccent, Colors.tealAccent, Colors.deepOrangeAccent
    ];
    final color = colors[genre.id % colors.length];

    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de películas por género
        context.push('/categories/${genre.id}/${genre.name}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.7),
              color,
            ]
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4)
            )
          ]
        ),
        child: Center(
          child: Text(
            genre.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              shadows: [
                Shadow(color: Colors.black26, offset: Offset(1,1), blurRadius: 2)
              ]
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}