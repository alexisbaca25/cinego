import 'package:cinemapedia/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
import 'config/theme/app_theme.dart';


Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized(); 

  await dotenv.load(fileName: ".env");


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(child: MainApp())
  );
}

class MainApp extends ConsumerWidget { 
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 

    // 3. Observa el provider que acabamos de crear
    final appRouter = ref.watch( appRouterProvider );

    return MaterialApp.router(
      routerConfig: appRouter, 
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}