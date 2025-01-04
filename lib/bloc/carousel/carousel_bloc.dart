import 'package:bloc/bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'carousel_event.dart';
part 'carousel_state.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  final Dio _dio = Dio();
  final String _url = dotenv.env['API_URL'] ?? '';

  CarouselBloc() : super(const CarouselState()) {
    on<LoadCarouselEvent>(_onLoadCarouselEvent);
  }

  void _onLoadCarouselEvent(
      LoadCarouselEvent event, Emitter<CarouselState> emit) async {
    emit(state.copyWith(
        status: CarouselStatus.loading,
        carouselStatus: CarouselStatus.loading));

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

      emit(state.copyWith(
          status: CarouselStatus.success,
          carouselStatus: CarouselStatus.success,
          books: books));
    } catch (_) {
      emit(state.copyWith(
          status: CarouselStatus.failure,
          carouselStatus: CarouselStatus.failure,
          error: 'Failed to load carousel'));
    }
  }
}
