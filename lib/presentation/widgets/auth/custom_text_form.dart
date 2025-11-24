import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged, 
    this.validator, 
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: BorderSide.none, // Quitamos borde duro, usamos el fill color
      borderRadius: BorderRadius.circular(15)
    );

    return Container(
      // Sombra suave para dar profundidad
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0,5)
          )
        ]
      ),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        // El color del texto se adapta (Blanco en dark, Negro en light)
        style: TextStyle( fontSize: 18, color: colors.onSurface ), 
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never, // Etiqueta oculta al escribir para diseño limpio
          isDense: true,
          labelText: label,
          hintText: hint,
          errorText: errorMessage,
          
          // Estilos definidos en el inputDecorationTheme del AppTheme, 
          // pero aquí aseguramos que se vean bien:
          fillColor: colors.surfaceContainerHighest.withOpacity(0.5), // Fondo grisáceo translúcido
          filled: true,
          
          labelStyle: TextStyle(color: colors.onSurfaceVariant),
          hintStyle: TextStyle(color: colors.onSurfaceVariant.withOpacity(0.5)),
          
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith( borderSide: BorderSide( color: colors.primary )),
          errorBorder: border.copyWith( borderSide: BorderSide( color: colors.error )),
          focusedErrorBorder: border.copyWith( borderSide: BorderSide( color: colors.error )),
        ),
      ),
    );
  }
}