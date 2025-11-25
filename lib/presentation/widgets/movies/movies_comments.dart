import 'package:cinemapedia/presentation/provider/comments/comments_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/auth/auth_provider.dart';

class MovieComments extends ConsumerWidget {
  final String movieId;

  const MovieComments({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final commentsAsync = ref.watch(commentsByMovieProvider(movieId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text('Comentarios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        
        // LISTA DE COMENTARIOS
        commentsAsync.when(
          data: (comments) => ListView.builder(
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Text(comment.userName.isNotEmpty ? comment.userName[0].toUpperCase() : '?'),
                ),
                title: Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(comment.text),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, __) => const Padding(
            padding: EdgeInsets.all(10),
            child: Text('No se pudieron cargar los comentarios'),
          ),
        ),

        _CommentInput(movieId: movieId),
      ],
    );
  }
}

class _CommentInput extends ConsumerStatefulWidget {
  final String movieId;
  const _CommentInput({required this.movieId});

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<_CommentInput> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Escribe tu opinión...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20)
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: () async {
              final text = textController.text;
              if (text.trim().isEmpty) return;

              final user = ref.read(authProvider).user;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debes iniciar sesión para comentar'))
                );
                return;
              }

              // Guardar comentario
              await ref.read(commentsRepositoryProvider).addComment(
                widget.movieId, 
                user.id, 
                user.fullName, 
                text
              );

              textController.clear();
              // Recargar la lista
              ref.invalidate(commentsByMovieProvider(widget.movieId));
            },
          )
        ],
      ),
    );
  }
}