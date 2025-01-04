import 'package:bloc/bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
part 'reading_event.dart';
part 'reading_state.dart';

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  final Dio _dio = Dio();
  final String urlReading = dotenv.env['READ_URL'] ?? '';

  ReadingBloc() : super(const ReadingState()) {
    on<LoadReadingEvent>(_onLoadReadingEvent);
    on<AddReadingEvent>(_onAddReadingEvent);
    on<RemoveReadingEvent>(_onRemoveReading);
  }

  void _onLoadReadingEvent(
      LoadReadingEvent event, Emitter<ReadingState> emit) async {
    emit(state.copyWith(
        status: ReadingStatus.loading, readingStatus: ReadingStatus.loading));

    try {
      final response = await _dio.get("$urlReading.json");
      final data = response.data as Map<String, dynamic>;
      final books = data.entries.map((entry) {
        final bookData = entry.value as Map<String, dynamic>;
        return BookModel(
          id: entry.key,
          author: bookData['author'],
          name: bookData['name'],
          imageUrl: bookData['image_url'],
          price: bookData['price'],
          description: bookData['description'],
        );
      }).toList();

      emit(state.copyWith(
          status: ReadingStatus.success,
          readingStatus: ReadingStatus.success,
          reading: books));
    } catch (error) {
      emit(state.copyWith(
          status: ReadingStatus.failure,
          readingStatus: ReadingStatus.failure,
          error: 'Failed to load reading books'));
    }
  }

  void _onAddReadingEvent(
      AddReadingEvent event, Emitter<ReadingState> emit) async {
    try {
      emit(state.copyWith(status: ReadingStatus.loading));

      final existingIndex =
          state.reading.indexWhere((book) => book.id == event.book.id);

      if (existingIndex >= 0) {
        return;
      }

      await _dio.put(
        "$urlReading/${event.book.id}.json",
        data: {
          "id": event.book.id,
          "author": event.book.name,
          "image_url": event.book.imageUrl,
          "price": event.book.price,
          "description": event.book.description,
        },
      );

      final updateReading = List<BookModel>.from(state.reading)
        ..add(event.book);

      emit(state.copyWith(
        reading: updateReading,
        status: ReadingStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ReadingStatus.failure,
        error: 'Failed to add reading ${error.toString()}',
      ));
    }
  }

  void _onRemoveReading(
      RemoveReadingEvent event, Emitter<ReadingState> emit) async {
    try {
      emit(state.copyWith(status: ReadingStatus.loading));
      await _dio.delete(
        "$urlReading/${event.book.id}.json",
      );

      final updateReading =
          state.reading.where((book) => book.id != event.book.id).toList();

      emit(state.copyWith(
        reading: updateReading,
        status: ReadingStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ReadingStatus.failure,
        error: 'Failed to remove reading book ${error.toString()}',
      ));
    }
  }
}
