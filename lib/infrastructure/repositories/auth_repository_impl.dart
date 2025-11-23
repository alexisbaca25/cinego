import 'package:cinemapedia/domain/datasources/auth_datasource.dart';
import 'package:cinemapedia/domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

class AuthRepositoryImpl extends AuthRepository {
  
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<UserEntity> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<UserEntity> register(String email, String password, String fullName) {
    return datasource.register(email, password, fullName);
  }

}