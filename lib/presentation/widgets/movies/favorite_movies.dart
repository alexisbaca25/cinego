import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/presentation/provider/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/provider/auth/auth_provider.dart';
import 'package:cinemapedia/domain/entities/movies.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  
  bool isLastPage = false;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();
  
  // Estado local para el ordenamiento
  // 0: Sin orden (Como se agregaron)
  // 1: Por Calificación (Mayor a menor)
  // 2: Por Fecha de estreno (Más nuevas primero)
  int sortOption = 0; 

  @override
  void initState() {
    super.initState();
    loadNextPage();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    final user = ref.read(authProvider).user;
    if (user == null) return;

    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage(user.id);
    
    isLoading = false;
    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    // 1. Obtenemos la lista
    final List<Movie> favorites = ref.watch(favoriteMoviesProvider).values.toList();
    final colors = Theme.of(context).colorScheme;

    // 2. Aplicamos el ordenamiento según la opción seleccionada
    if (sortOption == 1) {
      favorites.sort((a, b) => b.voteAverage.compareTo(a.voteAverage)); // Mayor rating
    } else if (sortOption == 2) {
      favorites.sort((a, b) => b.releaseDate.compareTo(a.releaseDate)); // Más recientes
    }


    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded, size: 80, color: colors.primary.withOpacity(0.5)),
            const SizedBox(height: 20),
            Text(
              'Aún no tienes favoritos', 
              style: TextStyle(fontSize: 22, color: colors.primary, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),
            const Text(
              'Las películas que marques aparecerán aquí',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            FilledButton.tonal(
              onPressed: () => context.go('/'), 
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary.withOpacity(0.1),
                foregroundColor: colors.primary
              ),
              child: const Text('Explorar películas')
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        centerTitle: false,
        actions: [
          // BOTÓN DE ORDENAR FUNCIONAL
          PopupMenuButton<int>(
            icon: const Icon(Icons.sort_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: (value) {
              setState(() {
                sortOption = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Orden de agregado'),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text('Por calificación'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('Por estreno'),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
          controller: scrollController,
          itemCount: favorites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.65, 
          ),
          itemBuilder: (context, index) {
            final movie = favorites[index];
            return _FavoriteCard(movie: movie, index: index);
          },
        ),
      ),
    );
  }
}

// ... La clase _FavoriteCard SE QUEDA IGUAL que en el código anterior ...
class _FavoriteCard extends StatelessWidget {
  
  final Movie movie;
  final int index;

  const _FavoriteCard({required this.movie, required this.index});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: index * 30), 
      child: GestureDetector(
        onTap: () => context.push('/movie/${movie.id}'),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3)
              )
            ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    movie.posterPath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(color: Colors.grey[800]);
                    },
                  ),
                ),

                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.6, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.9),
                        ]
                      )
                    )
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.withOpacity(0.5))
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 10,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 2)
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}