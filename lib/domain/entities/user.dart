class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final String? photoUrl;
  final bool isEmailVerified;

  UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.photoUrl,
    this.isEmailVerified = false,
  });
}