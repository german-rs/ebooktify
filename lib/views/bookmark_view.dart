import 'package:booktify/bloc/favorites/favorites_bloc.dart';
import 'package:booktify/bloc/favorites/favorites_event.dart';
import 'package:booktify/bloc/favorites/favorites_state.dart';
import 'package:booktify/widgets/custom_app_bar.dart';
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
      appBar: const CustomAppBar(
        type: AppBarType.bookmark,
      ),
      body: Container(
        // Agrega este Container
        color: Colors.white, // Y coloca el color aquí
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
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
      ),
    );
  }
}
