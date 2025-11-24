import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/provider/movies/videos_provider.dart';

final FutureProviderFamily<List<Video>, String> videosFromMovieProvider = FutureProvider.family((ref, String movieId) {
  final videosByMovie = ref.watch( videosByMovieProvider );
  return videosByMovie[movieId] ?? [];
});

class VideosFromMovie extends ConsumerWidget {
  
  final String movieId;

  const VideosFromMovie({ super.key, required this.movieId });

  @override
  Widget build(BuildContext context, WidgetRef ref ) {
    final videosByMovie = ref.watch( videosByMovieProvider );
    final videos = videosByMovie[movieId];

    if ( videos == null ) {
      return const SizedBox(
        height: 200, 
        child: Center(child: CircularProgressIndicator(strokeWidth: 2))
      );
    }

    if ( videos.isEmpty ) {
      return const SizedBox(); 
    }

    // Tomamos solo el primer video
    return _YouTubeVideoPlayer(youtubeId: videos.first.youtubeKey, name: videos.first.name );
  }
}

class _YouTubeVideoPlayer extends StatefulWidget {
  
  final String youtubeId;
  final String name;

  const _YouTubeVideoPlayer({ required this.youtubeId, required this.name });

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Aquí quitamos el texto y el padding extra para que el padre controle el diseño
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Bordes redondeados al video
      child: YoutubePlayer(controller: _controller)
    );
  }
}