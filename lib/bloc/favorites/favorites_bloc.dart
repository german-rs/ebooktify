import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:booktify/models/book_model.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final String urlFavorites = dotenv.env['FAV_URL'] ?? '';

  final Dio _dio = Dio();

  FavoritesBloc() : super(const FavoritesState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  void _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<FavoritesState> emit) async {
    try {
      emit(state.copyWith(status: FavoritesStatus.loading));

      final response = await _dio.get("$urlFavorites.json");
      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        emit(state.copyWith(
          favorites: [],
          status: FavoritesStatus.success,
        ));
        return;
      }

      final favorites = data.entries.map((entry) {
        final bookData = entry.value as Map<String, dynamic>;
        return BookModel(
          id: bookData['id'] ?? entry.key,
          author: bookData['author'] ?? '',
          name: bookData['name'] ?? '',
          imageUrl: bookData['image_url'] ?? '',
          price: (bookData['price'] ?? 0).toDouble(),
          description: bookData['description'] ?? '',
        );
      }).toList();

      emit(state.copyWith(
        favorites: favorites,
        status: FavoritesStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FavoritesStatus.failure,
        error: 'Failed to load favorites: ${error.toString()}',
      ));
    }
  }

  void _onAddFavorite(
      AddFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      emit(state.copyWith(status: FavoritesStatus.loading));

      final existingIndex =
          state.favorites.indexWhere((book) => book.id == event.book.id);
      if (existingIndex >= 0) {
        return;
      }

      await _dio.put(
        "$urlFavorites/${event.book.id}.json",
        data: {
          "id": event.book.id,
          "author": event.book.author,
          "name": event.book.name,
          "image_url": event.book.imageUrl,
          "price": event.book.price,
          "description": event.book.description,
        },
      );

      final updatedFavorites = List<BookModel>.from(state.favorites)
        ..add(event.book);

      emit(state.copyWith(
        favorites: updatedFavorites,
        status: FavoritesStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FavoritesStatus.failure,
        error: 'Failed to add favorite: ${error.toString()}',
      ));
    }
  }

  void _onRemoveFavorite(
      RemoveFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      emit(state.copyWith(status: FavoritesStatus.loading));

      await _dio.delete(
        "$urlFavorites/${event.book.id}.json",
      );

      final updatedFavorites =
          state.favorites.where((book) => book.id != event.book.id).toList();

      emit(state.copyWith(
        favorites: updatedFavorites,
        status: FavoritesStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FavoritesStatus.failure,
        error: 'Failed to remove favorite: ${error.toString()}',
      ));
    }
  }
}
