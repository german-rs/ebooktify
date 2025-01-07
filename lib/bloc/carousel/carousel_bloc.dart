import 'package:bloc/bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'carousel_event.dart';
part 'carousel_state.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  final Dio _dio;
  final String _url;

  CarouselBloc({
    Dio? dio,
    String? baseUrl,
  })  : _dio = dio ?? Dio(),
        _url = baseUrl ?? dotenv.env['API_URL'] ?? '',
        super(const CarouselState()) {
    on<LoadCarouselEvent>(_onLoadCarouselEvent);
  }

  void _onLoadCarouselEvent(
      LoadCarouselEvent event, Emitter<CarouselState> emit) async {
    try {
      emit(state.copyWith(status: CarouselStatus.loading));

      final response = await _dio.get("$_url.json");

      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw Exception("Invalid API response format");
      }

      final data = response.data as Map<String, dynamic>;
      final books = _parseBooks(data);

      emit(state.copyWith(
        status: CarouselStatus.success,
        books: books,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CarouselStatus.failure,
        error: 'Failed to load books: $error',
      ));
    }
  }

  List<BookModel> _parseBooks(Map<String, dynamic> data) {
    return data.entries.map((entry) {
      final bookData = entry.value as Map<String, dynamic>;

      if (!bookData.containsKey('author') ||
          !bookData.containsKey('name') ||
          !bookData.containsKey('image_url') ||
          !bookData.containsKey('price') ||
          !bookData.containsKey('description')) {
        throw Exception(
            "Datos incompletos en el libro con ID: ${entry.key}. Datos: $bookData");
      }

      return BookModel(
        id: entry.key,
        author: bookData['author'] ?? '',
        name: bookData['name'] ?? '',
        imageUrl: bookData['image_url'] ?? '',
        price: (bookData['price'] as num).toDouble(),
        description: bookData['description'],
      );
    }).toList();
  }
}
