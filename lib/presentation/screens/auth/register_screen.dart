import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../provider/auth/auth_provider.dart';
import '../../widgets/auth/custom_text_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.2, 0.9],
            colors: [
              colors.primary.withOpacity(0.9),
              Colors.black,
            ],
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
    final colors = Theme.of(context).colorScheme;

    const headerHeight = 160.0;
    final containerHeight = size.height - headerHeight;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox( height: 60 ),
          const Icon( Icons.person_add_alt_1_rounded, color: Colors.white, size: 80 ),
          const SizedBox( height: 20 ),

          Container(
            height: containerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surface, 
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [
                 BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0,-5))
              ]
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
    
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    ref.listen(authProvider, (previous, next) {
      if ( next.errorMessage.isEmpty ) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(next.errorMessage), backgroundColor: Colors.red)
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox( height: 40 ),
          Text(
            'Crear cuenta', 
            style: textStyles.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface
            ) 
          ),
          const SizedBox( height: 40 ),

          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.name,
            onChanged: (value) => nameController.text = value,
          ),
          const SizedBox( height: 20 ),

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
                ref.read(authProvider.notifier).registerUser(
                  emailController.text, 
                  passwordController.text,
                  nameController.text
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              child: const Text('REGISTRARSE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          
          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¿Ya tienes cuenta?', style: TextStyle(color: colors.onSurface.withOpacity(0.6))),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text('Ingresa aquí', style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold))
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}