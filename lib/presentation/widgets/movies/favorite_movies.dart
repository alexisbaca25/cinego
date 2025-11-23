import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../provider/auth/auth_provider.dart';
import '../../provider/storage/favorite_movies_provider.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    // Obtenemos el usuario para pedir sus favoritos
    final user = ref.read(authProvider).user;
    if (user == null) return;

    // Llamamos al provider para cargar las pelis
    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage(user.id);
    
    isLoading = false;
    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    // Obtenemos el mapa de favoritos y lo convertimos a lista
    final favorites = ref.watch(favoriteMoviesProvider).values.toList();

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_sharp, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 20),
            const Text('No tienes favoritos aún', style: TextStyle(fontSize: 20, color: Colors.black54)),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () => context.go('/'), 
              child: const Text('Empieza a buscar')
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: GridView.builder(
        itemCount: favorites.length,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 columnas
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7 // Proporción del poster
        ),
        itemBuilder: (context, index) {
          final movie = favorites[index];
          return GestureDetector(
            onTap: () => context.push('/movie/${movie.id}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}