import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/provider/movies/genres_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final genresAsync = ref.watch(genresProvider);
    final colors = Theme.of(context).colorScheme;

    if (genresAsync.isLoading) {
      return const FullScreenLoader();
    }

    if (genresAsync.hasError) {
      return Center(child: Text('Error al cargar categorías', style: TextStyle(color: colors.error)));
    }

    final genres = genresAsync.value!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar Géneros'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final genre = genres[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 50),
                    child: _GenreCard(genre: genre)
                  );
                },
                childCount: genres.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                // CAMBIO 1: Ajustamos el ratio (Ancho / Alto). 
                // Un valor menor hace la tarjeta más alta. Antes 1.4 -> Ahora 1.30
                childAspectRatio: 1.30, 
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
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
    
    final colors = Theme.of(context).colorScheme;
    final iconData = _getGenreIcon(genre.id);
    final gradient = _getGenreGradient(genre.id, colors);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: gradient.colors.last.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4)
          )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.push('/categories/${genre.id}/${genre.name}'),
          child: Stack(
            children: [
              // Icono gigante de fondo
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  iconData, 
                  size: 100, 
                  color: Colors.white.withOpacity(0.15)
                ),
              ),
              
              // Contenido Principal
              Padding(
                // CAMBIO 2: Reducimos el padding de 20 a 12 para evitar overflow
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Icon(iconData, color: Colors.white, size: 24),
                    ),
                    const Spacer(),
                    
                    // CAMBIO 3: FittedBox asegura que el texto no rompa si es muy largo
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        genre.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 5),
                    Text(
                      'Explorar',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getGenreIcon(int id) {
    switch (id) {
      case 28: return Icons.flash_on_rounded;       
      case 12: return Icons.explore_rounded;        
      case 16: return Icons.animation_rounded;      
      case 35: return Icons.emoji_emotions_rounded; 
      case 80: return Icons.local_police_rounded;   
      case 99: return Icons.videocam_rounded;       
      case 18: return Icons.theater_comedy_rounded; 
      case 10751: return Icons.family_restroom_rounded; 
      case 14: return Icons.auto_fix_high_rounded;  
      case 36: return Icons.history_edu_rounded;    
      case 27: return Icons.bug_report_rounded;     
      case 10402: return Icons.music_note_rounded;  
      case 9648: return Icons.search_rounded;       
      case 10749: return Icons.favorite_rounded;    
      case 878: return Icons.smart_toy_rounded;     
      case 10770: return Icons.tv_rounded;          
      case 53: return Icons.psychology_rounded;     
      case 10752: return Icons.military_tech_rounded; 
      case 37: return Icons.whatshot_rounded;       
      default: return Icons.movie_filter_rounded;
    }
  }

  LinearGradient _getGenreGradient(int id, ColorScheme appColors) {
    final baseColor = appColors.primary;
    switch (id) {
      case 28: 
        return const LinearGradient(colors: [Color(0xFFE53935), Color(0xFFFF9800)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 878: 
        return const LinearGradient(colors: [Color(0xFF00B0FF), Color(0xFF2962FF)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 27: 
        return const LinearGradient(colors: [Color(0xFF4A148C), Color(0xFF311B92)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 10749: 
        return const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF4081)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 35: 
        return const LinearGradient(colors: [Color(0xFFFBC02D), Color(0xFFFFA000)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      default:
        return LinearGradient(
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight,
          colors: [
            baseColor.withOpacity(0.8),
            baseColor.withBlue(200),
          ]
        );
    }
  }
}