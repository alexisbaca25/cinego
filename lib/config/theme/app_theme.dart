import 'package:flutter/material.dart';

class AppTheme {
  
  final int selectedColor;
  final bool isDarkmode;

  AppTheme({
    this.selectedColor = 0,
    this.isDarkmode = true, // Por defecto en modo oscuro (cine)
  }) : assert( selectedColor >= 0, 'Selected color must be greater then 0' ),
       assert( selectedColor < colorList.length, 'Selected color must be less or equal than ${ colorList.length - 1 }');

  // Aquí definimos tus paletas de colores
  static const List<Color> colorList = [
    Color(0xFF2862F5), // 0. Azul Tech (Tu original mejorado)
    Color(0xFFE50914), // 1. Rojo Netflix
    Color(0xFFFFD700), // 2. Oro Oscars
    Color(0xFF00E5FF), // 3. Cian Cyberpunk
  ];

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: isDarkmode ? Brightness.dark : Brightness.light,
    colorSchemeSeed: colorList[selectedColor],
    
    // Ajustes finos para el AppBar
    appBarTheme: const AppBarTheme(
      centerTitle: false,
    ),

    // Ajustes para Inputs (Login/Registro)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDarkmode ? const Color(0xFF1E293B) : Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: colorList[selectedColor], width: 2)
      ),
    ),

    // Ajuste global para el fondo en modo oscuro (para que no sea grisáceo feo)
    scaffoldBackgroundColor: isDarkmode ? const Color(0xFF0F172A) : Colors.white,
  );

  // Método para copiar el tema y cambiar propiedades fácilmente
  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkmode
  }) => AppTheme(
    selectedColor: selectedColor ?? this.selectedColor,
    isDarkmode: isDarkmode ?? this.isDarkmode,
  );

}