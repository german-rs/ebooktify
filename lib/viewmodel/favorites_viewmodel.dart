import 'package:booktify/bloc/favorites/favorites_event.dart';
import 'package:booktify/bloc/favorites/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/bloc/favorites/favorites_bloc.dart';
import 'package:booktify/models/book_model.dart';

class FavoritesViewModel {
  final BuildContext context;

  FavoritesViewModel(this.context);

  FavoritesState get state => context.watch<FavoritesBloc>().state;

  List<BookModel> get favorites {
    if (state.status == FavoritesStatus.success) {
      return state.favorites;
    }
    return [];
  }

  bool get isLoading => state.status == FavoritesStatus.loading;

  String? get error {
    if (state.status == FavoritesStatus.failure) {
      return state.error;
    }
    return null;
  }

  void loadFavorites() {
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }

  void addFavorite(BookModel book) {
    context.read<FavoritesBloc>().add(AddFavoriteEvent(book));
  }

  void removeFavorite(BookModel book) {
    context.read<FavoritesBloc>().add(RemoveFavoriteEvent(book));
  }
}
