import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user.dart';

class UserMapper {
  
  static UserEntity userToEntity(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? 'No name',
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified
    );
  }

}