import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/datasources/auth_datasource.dart';
import '../../domain/entities/user.dart';
import '../mappers/user_mapper.dart';
class AuthDatasourceImpl extends AuthDatasource {
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      final user = credential.user;
      if ( user == null ) throw Exception('User not found');

      return UserMapper.userToEntity(user);

    } catch (e) {
      throw Exception('Login failed: $e'); 
    }
  }

  @override
  Future<UserEntity> register(String email, String password, String fullName) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      final user = credential.user;
      await user?.updateDisplayName(fullName);
      await user?.reload(); 
      final updatedUser = _firebaseAuth.currentUser;

      if ( updatedUser == null ) throw Exception('User creation failed');
      return UserMapper.userToEntity(updatedUser);

    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }

  @override
  Future<UserEntity> checkAuthStatus(String token) async {
    // Para Firebase, revisamos el usuario actual
    final user = _firebaseAuth.currentUser;
    
    if ( user == null ) throw Exception('No authenticated user');
    
    return UserMapper.userToEntity(user);
  }
}