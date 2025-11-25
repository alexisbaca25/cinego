import '../../domain/entities/video.dart';

class VideoMapper {
  static Video moviedbVideoToEntity(Map<String, dynamic> json) {
    final publishedAt = DateTime.tryParse(json['published_at']) ?? DateTime.now();

    return Video(
      id: json['id'],
      name: json['name'],
      youtubeKey: json['key'],
      publishedAt: publishedAt,
    );
  }
}