import 'package:cinemapedia/domain/entities/video.dart';

class VideoMapper {
  static Video moviedbVideoToEntity(Map<String, dynamic> json) => Video(
    id: json['id'], 
    name: json['name'], 
    youtubeKey: json['key'], 
    publishedAt: DateTime.parse(json['published_at'])
  );
}