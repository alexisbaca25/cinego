import 'dart:async';

import 'package:cinemapedia/presentation/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/provider/auth/auth_provider.dart';
import 'package:cinemapedia/presentation/screens/screens.dart'; // Asegúrate de exportar GenreScreen aquí o impórtalo directo
import 'package:cinemapedia/presentation/screens/movies/genre_screen.dart'; // Importamos la pantalla de detalle de género

final appRouterProvider = Provider<GoRouter>((ref) {

  final authNotifier = ref.read(authProvider.notifier);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream( authNotifier.stream ),

    redirect: (context, state) {
      
      final isGoingTo = state.matchedLocation;
      final authStatus = ref.read(authProvider).authStatus;

      if ( isGoingTo == '/splash' && authStatus == AuthStatus.checking ) return null;

      if ( authStatus == AuthStatus.notAuthenticated ) {
        if ( isGoingTo == '/login' || isGoingTo == '/register' ) return null;
        return '/login';
      }

      if ( authStatus == AuthStatus.authenticated ) {
        if ( isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/splash' ){
          return '/';
        }
      }

      return null;
    },

    routes: [
      
      // --- Auth Routes ---
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(), 
      ),

      // --- Tab 1: Home ---
      GoRoute(
        path: '/',
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen(pageIndex: 0),
        routes: [
           GoRoute(
             path: 'movie/:id',
             name: MovieScreen.name,
             builder: (context, state) {
               final movieId = state.pathParameters['id'] ?? 'no-id';
               return MovieScreen(movieId: movieId);
             },
           ),
        ]
      ),

      // --- Tab 2: Categorías (NUEVO) ---
      GoRoute(
        path: '/categories',
        builder: (context, state) => const HomeScreen(pageIndex: 1),
        routes: [
           // Sub-ruta para ver películas de un género específico
           GoRoute(
             path: ':id/:name', // Ej: /categories/28/Action
             builder: (context, state) {
               final genreId = state.pathParameters['id'] ?? '0';
               final genreName = state.pathParameters['name'] ?? 'Categoría';
               return GenreScreen(genreId: genreId, genreName: genreName);
             },
           ),
        ]
      ),

      // --- Tab 3: Favoritos ---
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const HomeScreen(pageIndex: 2),
      ),
      
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}