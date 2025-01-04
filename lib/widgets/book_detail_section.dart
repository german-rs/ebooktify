import 'package:booktify/bloc/favorites/favorites_bloc.dart';
import 'package:booktify/bloc/favorites/favorites_event.dart';
import 'package:booktify/bloc/favorites/favorites_state.dart';
import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'info_container_widget.dart';
import 'detail_cart.dart';

class BookDetailSection extends StatelessWidget {
  final BookModel book;

  const BookDetailSection({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state.favorites.contains(book);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.myWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${book.price}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: AppColors.myGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          book.name,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          book.author,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: AppColors.myDarkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.bookmark : Icons.bookmark_border,
                            color: isFavorite
                                ? AppColors.myGreen
                                : AppColors.myMiddleGrey,
                          ),
                          onPressed: () {
                            if (isFavorite) {
                              BlocProvider.of<FavoritesBloc>(context)
                                  .add(RemoveFavoriteEvent(book));
                            } else {
                              BlocProvider.of<FavoritesBloc>(context)
                                  .add(AddFavoriteEvent(book));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              InfoContainerWidget(),
              const SizedBox(height: 16.0),
              Text(
                'Description',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                book.description,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              DetailCart(book: book),
            ],
          ),
        );
      },
    );
  }
}
