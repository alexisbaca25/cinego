import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/provider/movies/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/screens/movies/comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/presentation/provider/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/provider/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/provider/auth/auth_provider.dart';
import 'package:cinemapedia/presentation/widgets/videos/videos_from_movie.dart';

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
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
        
        // --- CABECERA ---
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0,5))
                  ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie.posterPath,
                    width: size.width * 0.3,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              
              SizedBox(
                width: (size.width - 40) * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyle.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(movie.overview, style: textStyle.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // --- GÉNEROS ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Wrap(
            spacing: 5,
            children: [
              ...movie.genreIds.map((gender) => Chip(
                label: Text(gender, style: const TextStyle(fontSize: 12, color: Colors.black)),
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.grey.shade200, 
                side: BorderSide.none,
                visualDensity: VisualDensity.compact,
              ))
            ],
          ),
        ),

        const SizedBox(height: 25),
        const _TitleSection(title: 'Reparto'),
        
        _ActorsByMovie(movieId: movie.id.toString()), 

        const SizedBox(height: 25),
        const _TitleSection(title: 'Trailer Oficial'),

        // --- TRAILERS (Lo que hizo tu equipo) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
             decoration: BoxDecoration(
               color: Colors.black,
               borderRadius: BorderRadius.circular(20),
               boxShadow: const [
                 BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
               ]
             ),
             child: VideosFromMovie(movieId: movie.id.toString())
          ),
        ),

        const SizedBox(height: 25),

        // --- COMENTARIOS (Lo que hiciste tú) ---
        const _TitleSection(title: 'Comentarios'), 
        MovieComments(movieId: movie.id.toString()), 

        const SizedBox(height: 50),
      ],
    );
  }
}
class _TitleSection extends StatelessWidget {
  final String title;
  const _TitleSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        title, 
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
      ),
    );
  }
}

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
                        return const SizedBox(height: 180, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(actor.name, maxLines: 2),
                Text(actor.character ?? '', maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
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