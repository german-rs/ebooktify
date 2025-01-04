part of 'reading_bloc.dart';

sealed class ReadingEvent extends Equatable {
  const ReadingEvent();

  @override
  List<Object> get props => [];
}

class LoadReadingEvent extends ReadingEvent {
  const LoadReadingEvent();

  @override
  List<Object> get props => [];
}

class AddReadingEvent extends ReadingEvent {
  final BookModel book;

  const AddReadingEvent(this.book);

  @override
  List<Object> get props => [book];
}

class RemoveReadingEvent extends ReadingEvent {
  final BookModel book;

  const RemoveReadingEvent(this.book);

  @override
  List<Object> get props => [book];
}
