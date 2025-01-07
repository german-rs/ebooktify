part of 'catalog_bloc.dart';

enum CatalogStatus { none, initial, loading, success, failure }

class CatalogState extends Equatable {
  const CatalogState({
    this.status = CatalogStatus.initial,
    this.books = const [],
    this.error = '',
  });

  final CatalogStatus status;
  final List<BookModel> books;
  final String error;

  CatalogState copyWith({
    CatalogStatus? status,
    List<BookModel>? books,
    String? error,
  }) {
    return CatalogState(
      status: status ?? this.status,
      books: books ?? this.books,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, books, error];
}
