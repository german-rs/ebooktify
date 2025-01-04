import 'package:booktify/bloc/favorites/favorites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';

import '../bloc/favorites/favorites_event.dart';

class BookItem extends StatelessWidget {
  final BookModel book;

  const BookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesBloc, bool>(
      (bloc) => bloc.state.favorites.contains(book),
    );

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          book.imageUrl,
          width: 50.0,
          height: 75.0,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        book.name,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        book.author,
        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
      trailing: IconButton(
        icon: Icon(
          isFavorite ? Icons.bookmark : Icons.bookmark_border,
          color: isFavorite ? AppColors.myGreen : Colors.grey,
        ),
        onPressed: () {
          final bloc = context.read<FavoritesBloc>();
          if (isFavorite) {
            bloc.add(RemoveFavoriteEvent(book));
          } else {
            bloc.add(AddFavoriteEvent(book));
          }
        },
      ),
    );
  }
}
