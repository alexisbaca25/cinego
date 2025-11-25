import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user.dart';

class UserMapper {
  
  static UserEntity userToEntity(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      fullName: (user.displayName != null && user.displayName!.isNotEmpty)
          ? user.displayName!
          : (user.email != null) 
              ? user.email!.split('@')[0] 
              : 'Anónimo',
      isEmailVerified: user.emailVerified
    );
  }

}