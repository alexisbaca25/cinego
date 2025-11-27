import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../provider/auth/auth_provider.dart';
import '../../widgets/auth/custom_text_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.2, 0.9],
            colors: [
              colors.primary.withOpacity(0.9), // Color intenso arriba
              Colors.black, // Negro abajo
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
    final colors = Theme.of(context).colorScheme;
    
    // Header más compacto para pantallas pequeñas
    const headerHeight = 220.0; 
    final containerHeight = size.height - headerHeight;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox( height: 60 ),
          
          // Icono y Título
          const Icon( Icons.movie_filter_rounded, color: Colors.white, size: 80 ),
          const SizedBox( height: 10 ),
          const Text(
            'CineGo',
            style: TextStyle(
              fontSize: 30, 
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              letterSpacing: 2
            ),
          ),
          
          const SizedBox( height: 60 ),

          // Contenedor del Formulario
          Container(
            height: containerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surface, // Se adapta al tema (Oscuro o Claro)
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [
                 BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0,-5))
              ]
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
    
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    ref.listen(authProvider, (previous, next) {
      if ( next.errorMessage.isEmpty ) return;
      showSnackbar( context, next.errorMessage );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox( height: 40 ),
          
          // Título del formulario con color adaptativo
          Text(
            'Bienvenido', 
            style: textStyles.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface // Asegura contraste (Blanco en dark mode)
            ) 
          ),
          
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
                backgroundColor: colors.primary,
                // --- CAMBIO AQUÍ: Color del texto NEGRO ---
                foregroundColor: Colors.black, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              child: const Text('INGRESAR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          const Spacer(), 

          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿No tienes cuenta?', 
                  style: TextStyle(color: colors.onSurface.withOpacity(0.6)) // Texto secundario tenue
                ),
                TextButton(
                  onPressed: () => context.push('/register'),
                  child: Text('Crea una aquí', style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold))
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}