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
    on<UpdateReadingStatusEvent>(_onUpdateReadingStatus);
  }

  void _onUpdateReadingStatus(
      UpdateReadingStatusEvent event, Emitter<ReadingState> emit) async {
    try {
      emit(state.copyWith(status: ReadingStatus.loading));

      await _dio.patch(
        "$urlReading/${event.book.id}.json",
        data: {
          "is_reading": event.isReading,
        },
      );

      final updatedBooks = state.reading.map((book) {
        if (book.id == event.book.id) {
          return book.copyWith(isReading: event.isReading);
        }
        return book;
      }).toList();

      emit(state.copyWith(
        reading: updatedBooks,
        status: ReadingStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ReadingStatus.failure,
        error: 'Failed to update reading status: ${error.toString()}',
      ));
    }
  }

  void _onLoadReadingEvent(
      LoadReadingEvent event, Emitter<ReadingState> emit) async {
    emit(state.copyWith(status: ReadingStatus.loading));

    try {
      final response = await _dio.get("$urlReading.json");

      if (response.data == null) {
        emit(state.copyWith(
          status: ReadingStatus.success,
          reading: [],
        ));
        return;
      }

      final data = response.data as Map<String, dynamic>;

      final List<BookModel> books = [];

      data.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          books.add(BookModel.fromMap(key, value));
        }
      });

      emit(state.copyWith(
        status: ReadingStatus.success,
        reading: books,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ReadingStatus.failure,
        error: 'Failed to load reading books: ${error.toString()}',
      ));
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
          "author": event.book.author,
          "name": event.book.name,
          "image_url": event.book.imageUrl,
          "price": event.book.price,
          "description": event.book.description,
          "is_reading": event.book.isReading,
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
