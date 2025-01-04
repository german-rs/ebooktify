import 'package:booktify/bloc/favorites/favorites_bloc.dart';
import 'package:booktify/bloc/favorites/favorites_event.dart';
import 'package:booktify/bloc/favorites/favorites_state.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/widgets/book_item.dart';

class BookmarkView extends StatefulWidget {
  const BookmarkView({super.key});

  @override
  State<BookmarkView> createState() => _BookmarkViewState();
}

class _BookmarkViewState extends State<BookmarkView> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myWhite,
        title: const Text(
          'Bookmark',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.favorites.isEmpty) {
            return const Center(
              child: Text(
                'No hay libros marcados como favoritos',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final book = state.favorites[index];
              return BookItem(book: book);
            },
          );
        },
      ),
    );
  }
}
