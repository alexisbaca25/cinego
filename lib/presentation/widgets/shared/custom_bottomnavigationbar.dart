  import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

  class CustomBottomnavigationbar extends StatelessWidget {
    final int currentIndex;

  const CustomBottomnavigationbar({
    super.key, 
    required this.currentIndex
  });

  //Lógica para navegar
  void onItemTapped(BuildContext context, int index) {
    switch(index) {
      case 0:
        context.go('/'); 
        break;
      case 1:
        context.go('/'); 
        break;
      case 2:
        context.go('/favorites'); 
        break;
    }
  }
    @override
    Widget build(BuildContext context) {
      return BottomNavigationBar(

        onTap: (value) => onItemTapped(context, value),

        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label_outline),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favoritos',
          ),
        ],);
    }
  }