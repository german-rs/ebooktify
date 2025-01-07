import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:booktify/models/book_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class CurrentReadingEvent extends Equatable {
  const CurrentReadingEvent();

  @override
  List<Object> get props => [];
}

class UpdateCurrentReading extends CurrentReadingEvent {
  final BookModel book;
  final bool isReading;

  const UpdateCurrentReading(this.book, this.isReading);

  @override
  List<Object> get props => [book, isReading];
}

class LoadCurrentReading extends CurrentReadingEvent {
  const LoadCurrentReading();
}

enum CurrentReadingStatus { initial, loading, success, failure }

class CurrentReadingState extends Equatable {
  final BookModel? currentBook;
  final bool isReading;
  final CurrentReadingStatus status;

  const CurrentReadingState({
    this.currentBook,
    this.isReading = false,
    this.status = CurrentReadingStatus.initial,
  });

  CurrentReadingState copyWith({
    BookModel? currentBook,
    bool? isReading,
    CurrentReadingStatus? status,
  }) {
    return CurrentReadingState(
      currentBook: currentBook ?? this.currentBook,
      isReading: isReading ?? this.isReading,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [currentBook, isReading, status];
}

class CurrentReadingBloc
    extends Bloc<CurrentReadingEvent, CurrentReadingState> {
  final Dio _dio = Dio();
  final String urlReading = dotenv.env['READ_URL'] ?? '';

  CurrentReadingBloc() : super(const CurrentReadingState()) {
    on<UpdateCurrentReading>(_onUpdateCurrentReading);
    on<LoadCurrentReading>(_onLoadCurrentReading);

    add(const LoadCurrentReading());
  }

  void _onUpdateCurrentReading(
    UpdateCurrentReading event,
    Emitter<CurrentReadingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CurrentReadingStatus.loading));

      await _dio.patch(
        "$urlReading/${event.book.id}.json",
        data: {
          "is_reading": event.isReading,
        },
      );

      if (event.isReading) {
        emit(state.copyWith(
          currentBook: event.book,
          isReading: true,
          status: CurrentReadingStatus.success,
        ));
      } else {
        emit(const CurrentReadingState(status: CurrentReadingStatus.success));
      }
    } catch (error) {
      emit(state.copyWith(status: CurrentReadingStatus.failure));
    }
  }

  void _onLoadCurrentReading(
    LoadCurrentReading event,
    Emitter<CurrentReadingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CurrentReadingStatus.loading));

      final response = await _dio.get("$urlReading.json");

      if (response.data != null) {
        final data = response.data as Map<String, dynamic>;

        BookModel? currentReadingBook;

        data.forEach((key, value) {
          if (value is Map<String, dynamic> && value['is_reading'] == true) {
            currentReadingBook = BookModel.fromMap(key, value);
          }
        });

        if (currentReadingBook != null) {
          emit(state.copyWith(
            currentBook: currentReadingBook,
            isReading: true,
            status: CurrentReadingStatus.success,
          ));
        } else {
          emit(const CurrentReadingState(status: CurrentReadingStatus.success));
        }
      } else {
        emit(const CurrentReadingState(status: CurrentReadingStatus.success));
      }
    } catch (error) {
      emit(state.copyWith(status: CurrentReadingStatus.failure));
    }
  }
}
