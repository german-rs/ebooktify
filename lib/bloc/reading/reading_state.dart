part of 'reading_bloc.dart';

enum ReadingStatus { initial, loading, success, failure }

class ReadingState extends Equatable {
  const ReadingState({
    this.status = ReadingStatus.initial,
    this.reading = const [],
    this.error = '',
  });

  final ReadingStatus status;
  final List<BookModel> reading;
  final String error;

  ReadingState copyWith({
    ReadingStatus? status,
    List<BookModel>? reading,
    String? error,
  }) {
    return ReadingState(
      status: status ?? this.status,
      reading: reading ?? this.reading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, reading, error];
}
