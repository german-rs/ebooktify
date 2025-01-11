import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/bloc/reading/reading_bloc.dart';
import 'package:booktify/models/book_model.dart';

class ReadingViewModel {
  final BuildContext context;

  ReadingViewModel(this.context);

  ReadingState get state => context.watch<ReadingBloc>().state;

  List<BookModel> get readingBooks {
    if (state.status == ReadingStatus.success) {
      return state.reading;
    }
    return [];
  }

  bool get isLoading => state.status == ReadingStatus.loading;

  String? get error {
    if (state.status == ReadingStatus.failure) {
      return state.error;
    }
    return null;
  }

  void loadReadingBooks() {
    context.read<ReadingBloc>().add(LoadReadingEvent());
  }

  void addReadingBook(BookModel book) {
    context.read<ReadingBloc>().add(AddReadingEvent(book));
  }

  void removeReadingBook(BookModel book) {
    context.read<ReadingBloc>().add(RemoveReadingEvent(book));
  }

  void updateReadingStatus(BookModel book, bool isReading) {
    context.read<ReadingBloc>().add(UpdateReadingStatusEvent(book, isReading));
  }
}
