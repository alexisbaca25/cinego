class Comment {
  final String id;
  final String movieId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.movieId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });
}