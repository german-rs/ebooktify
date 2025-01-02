import 'package:equatable/equatable.dart';
import 'package:booktify/models/book_model.dart'; // Importa BookModel

class BooktifyState extends Equatable {
  const BooktifyState({
    this.carouselStatus = CarouselStatus.initial,
    this.books = const [],
  });

  final CarouselStatus carouselStatus;
  final List<BookModel> books;

  BooktifyState copyWith({
    CarouselStatus? carouselStatus,
    List<BookModel>? books,
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
