import 'package:flutter/material.dart';
import 'package:booktify/viewmodel/favorites_viewmodel.dart';
import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';

class BookItem extends StatelessWidget {
  final BookModel book;

  const BookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final viewModel = FavoritesViewModel(context);
    final isFavorite = viewModel.favorites.contains(book);

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
        style: const TextStyle(fontSize: 14.0, color: AppColors.myDarkGrey),
      ),
      trailing: IconButton(
        icon: Icon(
          isFavorite ? Icons.bookmark : Icons.bookmark_border,
          color: isFavorite ? AppColors.myGreen : AppColors.myDarkGrey,
        ),
        onPressed: () {
          if (isFavorite) {
            viewModel.removeFavorite(book);
          } else {
            viewModel.addFavorite(book);
          }
        },
      ),
    );
  }
}
