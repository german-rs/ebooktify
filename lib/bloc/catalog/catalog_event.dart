part of 'catalog_bloc.dart';

abstract class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object> get props => [];
}

class LoadCatalogEvent extends CatalogEvent {
  const LoadCatalogEvent();

  @override
  List<Object> get props => [];
}

class CreateNewBookEvent extends CatalogEvent {
  final String author;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  const CreateNewBookEvent({
    required this.author,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}

class UpdateCatalogBookEvent extends CatalogEvent {
  final BookModel bookModel;

  const UpdateCatalogBookEvent({required this.bookModel});
}

class DeleteBookEvent extends CatalogEvent {
  final String bookId;
  const DeleteBookEvent({required this.bookId});

  @override
  List<Object> get props => [bookId];
}
