import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomnavigationbar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomnavigationbar({
    super.key, 
    required this.currentIndex
  });

  // Lógica para navegar
  void onItemTapped(BuildContext context, int index) {
    switch(index) {
      case 0:
        context.go('/'); 
        break;
      
      case 1:
        context.go('/categories'); // <--- ¡AQUÍ ESTABA EL CAMBIO NECESARIO!
        break;
      
      case 2:
        context.go('/favorites'); 
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    // Validamos que el index sea válido para evitar errores visuales
    // (Por si acaso estamos en una sub-ruta, mantenemos seleccionado el tab correcto)
    int index = currentIndex;
    if ( index > 2 ) index = 0; 

    return BottomNavigationBar(
      currentIndex: index,
      onTap: (value) => onItemTapped(context, value),
      elevation: 0,
      selectedItemColor: Theme.of(context).colorScheme.primary, // Color activo
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Categorías',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos',
        ),
      ],
    );
  }
}