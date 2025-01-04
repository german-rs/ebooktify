part of 'carousel_bloc.dart';

enum CarouselStatus { initial, loading, success, failure }

class CarouselState extends Equatable {
  const CarouselState({
    this.status = CarouselStatus.initial,
    this.carouselStatus = CarouselStatus.initial,
    this.books = const [],
    this.error = '',
  });

  final CarouselStatus status;
  final CarouselStatus carouselStatus;
  final List<BookModel> books;
  final String error;

  CarouselState copyWith({
    CarouselStatus? status,
    CarouselStatus? carouselStatus,
    List<BookModel>? books,
    String? error,
  }) {
    return CarouselState(
      status: status ?? this.status,
      carouselStatus: carouselStatus ?? this.carouselStatus,
      books: books ?? this.books,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, carouselStatus, books, error];
}
