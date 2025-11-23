import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../provider/auth/auth_provider.dart';
import '../../widgets/auth/custom_text_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    // Fondo con degradado oscuro
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E293B), 
              Color(0xFF0F172A), 
            ],
          ),
        ),
        child: const _LoginView(),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const headerHeight = 250.0; 
    final containerHeight = size.height - headerHeight;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox( height: 80 ),
          
          const Icon( 
            Icons.movie_filter_outlined, 
            color: Colors.white, 
            size: 100 
          ),
          const SizedBox( height: 20 ),
          const Text(
            'Cinemapedia',
            style: TextStyle(
              fontSize: 30, 
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              letterSpacing: 2
            ),
          ),
          const SizedBox( height: 50 ),

          Container(
            height: containerHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: const _LoginForm(),
          )
        ],
      ),
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showSnackbar( BuildContext context, String message ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red)
    );
  }

  @override
  Widget build(BuildContext context) {

    
    ref.listen(authProvider, (previous, next) {
      if ( next.errorMessage.isEmpty ) return;
      showSnackbar( context, next.errorMessage );
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox( height: 40 ),
          Text('Bienvenido', style: textStyles.headlineMedium?.copyWith(fontWeight: FontWeight.bold) ),
          const SizedBox( height: 40 ),

          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => emailController.text = value,
          ),
          const SizedBox( height: 20 ),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: (value) => passwordController.text = value,
          ),
          
          const SizedBox( height: 40 ),

          // Botón de Ingresar
          SizedBox(
            width: double.infinity,
            height: 55,
            child: FilledButton(
              onPressed: () {
                ref.read(authProvider.notifier).loginUser(
                  emailController.text, 
                  passwordController.text
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B), // Color oscuro a juego
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              child: const Text('INGRESAR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          const Spacer(), // Empuja el contenido hacia arriba

          // Link a Registro
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿No tienes cuenta?', style: TextStyle(color: Colors.black54)),
                TextButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('Crea una aquí', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold))
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}