import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

// Domain Entities
import 'package:cinemapedia/domain/entities/movies.dart';

// Providers
import 'package:cinemapedia/presentation/provider/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/provider/movies/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/provider/movies/videos_provider.dart'; // <--- IMPORTANTE
import 'package:cinemapedia/presentation/provider/auth/auth_provider.dart';
import 'package:cinemapedia/presentation/provider/storage/favorite_movies_provider.dart';// Asegúrate de que este path sea correcto según tu estructura, si no, usa el de storageRepositoryProvider

// Widgets
import 'package:cinemapedia/presentation/widgets/videos/videos_from_movie.dart'; // <--- IMPORTANTE

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    
    // 1. Cargar Película
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    
    // 2. Cargar Actores
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);

    // 3. Cargar Videos (Trailer) --- NUEVO
    ref.read(videosByMovieProvider.notifier).loadVideos(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator( strokeWidth: 2)));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetail(movie: movie),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieDetail extends StatelessWidget {
  final Movie movie;

  const _MovieDetail({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(width: 10),
              
              // Descripción
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyle.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(movie.overview),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Géneros
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ))
            ],
          ),
        ),

        // Actores
        _ActorsByMovie(movieId: movie.id.toString()), 

        // Videos (Trailer) --- NUEVO
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: VideosFromMovie(movieId: movie.id.toString()),
        ),

        const SizedBox(height: 50),
      ],
    );
  }
}


// --- WIDGET LISTA DE ACTORES ---
class _ActorsByMovie extends ConsumerWidget {
  
  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {

    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto Actor
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                    ),
                  ),
                ),

                // Nombre
                const SizedBox(height: 5),
                Text(actor.name, maxLines: 2),
                Text(
                  actor.character ?? '', 
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomSliverAppBar extends ConsumerWidget { 
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            final user = ref.read(authProvider).user;
            if (user == null) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inicia sesión para guardar')));
               return;
            }

            // Nota: Aquí asumo que usas 'storageRepositoryProvider'. 
            // Si en tu código se llama diferente (ej: localStorageProvider), ajusta esta línea.
            await ref.read(storageRepositoryProvider).toggleFavorite(movie, user.id);
            
            ref.invalidate(isFavoriteProvider(movie.id));
          }, 
          icon: isFavoriteFuture.when(
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
            data: (isFavorite) => ((isFavorite as bool?) ?? false)
              ? const Icon(Icons.favorite_rounded, color: Colors.red) 
              : const Icon(Icons.favorite_border),
            error: (_,__) => const Icon(Icons.error), 
          )
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox();
                },
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.7, 1.0],
                    colors: [Colors.transparent, Colors.black87]
                  )
                )
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0, 0.3],
                    colors: [Colors.black87, Colors.transparent]
                  )
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}