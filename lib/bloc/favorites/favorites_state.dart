import 'package:equatable/equatable.dart';
import 'package:booktify/models/book_model.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState extends Equatable {
  final List<BookModel> favorites;
  final FavoritesStatus status;
  final String error;

  const FavoritesState({
    this.favorites = const [],
    this.status = FavoritesStatus.initial,
    this.error = '',
  });

  FavoritesState copyWith({
    List<BookModel>? favorites,
    FavoritesStatus? status,
    String? error,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [favorites, status, error];
}
