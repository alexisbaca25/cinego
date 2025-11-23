import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/auth/auth_provider.dart'; 

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary),
              const SizedBox(width: 5),
              Text('Cinemapedia', style: titleStyle),
              
              const Spacer(), 
              IconButton(
                onPressed: () {
                 
                }, 
                icon: const Icon(Icons.search)
              ),

              IconButton(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                }, 
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent)
              ),
            ],
          ),
        ),
      ),
    );
  }
}