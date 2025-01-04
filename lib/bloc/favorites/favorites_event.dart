import 'package:equatable/equatable.dart';
import 'package:booktify/models/book_model.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class AddFavoriteEvent extends FavoritesEvent {
  final BookModel book;

  const AddFavoriteEvent(this.book);

  @override
  List<Object> get props => [book];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final BookModel book;

  const RemoveFavoriteEvent(this.book);

  @override
  List<Object> get props => [book];
}
