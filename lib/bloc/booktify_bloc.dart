import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'booktify_event.dart';
import 'booktify_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:booktify/models/book_model.dart';

class BooktifyBloc extends Bloc<BooktifyEvent, BooktifyState> {
  BooktifyBloc() : super(const BooktifyState()) {
    on<LoadCarouselEvent>(_onLoadCarouselEvent);
  }

  final Dio _dio = Dio();
  final String _url = dotenv.env['API_URL'] ?? '';

  void _onLoadCarouselEvent(
      LoadCarouselEvent event, Emitter<BooktifyState> emit) async {
    emit(state.copyWith(carouselStatus: CarouselStatus.loading));

    try {
      final response = await _dio.get(_url);
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

      emit(
          state.copyWith(carouselStatus: CarouselStatus.success, books: books));
    } catch (_) {
      emit(state.copyWith(carouselStatus: CarouselStatus.failure));
    }
  }
}
