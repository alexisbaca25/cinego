import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../provider/auth/auth_provider.dart';
import '../../widgets/auth/custom_text_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar transparente para que se vea el fondo y el botón de atrás
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        // Mismo fondo degradado que el login
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
        ),
        child: const _RegisterView(),
      ),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Altura del header en registro es un poco menor
    const headerHeight = 180.0;
    final containerHeight = size.height - headerHeight;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox( height: 80 ),
          // Header de registro
          const Icon( Icons.person_add_alt_1_outlined, color: Colors.white, size: 80 ),
          const SizedBox( height: 20 ),

          // Contenedor blanco del formulario
          Container(
            height: containerHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              // Bordes redondeados simétricos, igual que el login
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: const _RegisterForm(),
          )
        ],
      ),
    );
  }
}

class _RegisterForm extends ConsumerStatefulWidget {
  const _RegisterForm();
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<_RegisterForm> {
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    // Escuchar errores del provider
    ref.listen(authProvider, (previous, next) {
      if ( next.errorMessage.isEmpty ) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(next.errorMessage), backgroundColor: Colors.red)
      );
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox( height: 40 ),
          Text('Crear cuenta', style: textStyles.headlineMedium?.copyWith(fontWeight: FontWeight.bold) ),
          const SizedBox( height: 40 ),

          // Campo: Nombre Completo
          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.name,
            onChanged: (value) => nameController.text = value,
          ),
          const SizedBox( height: 20 ),

          // Campo: Correo
          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => emailController.text = value,
          ),
          const SizedBox( height: 20 ),

          // Campo: Contraseña
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: (value) => passwordController.text = value,
          ),
          
          const SizedBox( height: 40 ),

          // Botón de Registrar
          SizedBox(
            width: double.infinity,
            height: 55,
            child: FilledButton(
              onPressed: () {
                // Llamada al provider para registrar
                ref.read(authProvider.notifier).registerUser(
                  emailController.text, 
                  passwordController.text,
                  nameController.text
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B), // Mismo color oscuro
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              child: const Text('REGISTRARSE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          
          const Spacer(),

          // Link para volver al Login
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿Ya tienes cuenta?', style: TextStyle(color: Colors.black54)),
                TextButton(
                  onPressed: () => context.pop(), // Vuelve atrás
                  child: const Text('Ingresa aquí', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold))
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}