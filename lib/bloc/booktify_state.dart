import 'package:equatable/equatable.dart';

class BooktifyState extends Equatable {
  const BooktifyState({
    this.carouselStatus = CarouselStatus.initial,
    this.books = const [],
  });

  final CarouselStatus carouselStatus;
  final List<Book> books;

  BooktifyState copyWith({
    CarouselStatus? carouselStatus,
    List<Book>? books,
  }) {
    return BooktifyState(
      carouselStatus: carouselStatus ?? this.carouselStatus,
      books: books ?? this.books,
    );
  }

  @override
  List<Object> get props => [carouselStatus, books];
}

enum CarouselStatus { initial, loading, success, failure }

class Book extends Equatable {
  const Book({
    required this.id,
    required this.author,
    required this.name,
    required this.imageUrl,
  });

  final String id;
  final String author;
  final String name;
  final String imageUrl;

  @override
  List<Object> get props => [id, author, name, imageUrl];
}
