import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../infrastructure/datasources/auth_datasource_impl.dart';
import '../../../../infrastructure/repositories/auth_repository_impl.dart';
import '../../../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  
  return AuthRepositoryImpl( AuthDatasourceImpl() );
  
});
