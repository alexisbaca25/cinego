import 'package:flutter_riverpod/legacy.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_repository_provider.dart';

//  Estado
enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final UserEntity? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    UserEntity? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage
  );
}

//Notifier 
class AuthNotifier extends StateNotifier<AuthState> {
  
  final AuthRepository authRepository;

  AuthNotifier({ required this.authRepository }) : super( AuthState() ) {
    checkAuthStatus(); 
  }

  // LOGIN
  Future<void> loginUser(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } catch (e) {
      logout( 'Credenciales incorrectas' );
    }
  }

  // REGISTRO 
  Future<void> registerUser(String email, String password, String fullName) async {
    try {
      final user = await authRepository.register(email, password, fullName);
      _setLoggedUser(user);
    } catch (e) {
      logout( 'Error al crear cuenta' );
    }
  }

  // VERIFICAR ESTADO 
  Future<void> checkAuthStatus() async {
    try {
      final user = await authRepository.checkAuthStatus('token_placeholder');
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser( UserEntity user ) {
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([ String? errorMessage ]) async {
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage ?? ''
    );
  }
}

// 3. El Provider Global
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  
  final authRepository = ref.watch( authRepositoryProvider );
  
  return AuthNotifier( authRepository: authRepository );
});