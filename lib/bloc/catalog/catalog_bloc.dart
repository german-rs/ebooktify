import 'package:bloc/bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  var uuid = const Uuid();
  final Dio _dio;
  final String _url;

  CatalogBloc({
    Dio? dio,
    String? baseUrl,
  })  : _dio = dio ?? Dio(),
        _url = baseUrl ?? dotenv.env['API_URL'] ?? '',
        super(const CatalogState()) {
    on<LoadCatalogEvent>(_onLoadCatalogEvent);
    on<DeleteBookEvent>(_onDeleteBookEvent);
    on<CreateNewBookEvent>(_onCreateNewBookEvent);
    on<UpdateCatalogBookEvent>(_onUpdateCatalogBookEvent);
  }

  void _onLoadCatalogEvent(
      LoadCatalogEvent event, Emitter<CatalogState> emit) async {
    emit(state.copyWith(status: CatalogStatus.loading));

    try {
      final response = await _dio.get("$_url.json");

      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw Exception("La respuesta de la API no tiene el formato esperado.");
      }

      final data = response.data as Map<String, dynamic>;
      final books = _parseBooks(data);
      emit(state.copyWith(status: CatalogStatus.success, books: books));
    } catch (error) {
      emit(state.copyWith(
          status: CatalogStatus.failure,
          error: 'Error al cargar los libros: $error'));
    }
  }

  void _onCreateNewBookEvent(
      CreateNewBookEvent event, Emitter<CatalogState> emit) async {
    emit(state.copyWith(status: CatalogStatus.loading));

    try {
      final String prodUID = uuid.v1();
      final data = {
        "author": event.author,
        "name": event.name,
        "description": event.description,
        "image_url": event.imageUrl,
        "price": event.price,
      };

      await _dio.put("$_url/$prodUID.json", data: data);

      final newProduct = BookModel(
        id: prodUID,
        author: event.author,
        name: event.name,
        description: event.description,
        imageUrl: event.imageUrl,
        price: event.price,
      );

      final updatedProducts = [...state.books, newProduct];
      emit(state.copyWith(
          status: CatalogStatus.success, books: updatedProducts));
    } catch (error) {
      emit(state.copyWith(
          status: CatalogStatus.failure,
          error: 'Error al crear el libro: $error'));
    }
  }

  void _onUpdateCatalogBookEvent(
      UpdateCatalogBookEvent event, Emitter<CatalogState> emit) async {
    emit(state.copyWith(status: CatalogStatus.loading));

    try {
      final book = event.bookModel;
      await _dio.put("$_url/${book.id}.json", data: {
        "author": book.author,
        "name": book.name,
        "description": book.description,
        "image_url": book.imageUrl,
        "price": book.price,
      });

      final updatedProducts = [
        for (var p in state.books)
          if (p.id == book.id) book else p
      ];
      emit(state.copyWith(
          status: CatalogStatus.success, books: updatedProducts));
    } catch (error) {
      emit(state.copyWith(
          status: CatalogStatus.failure,
          error: 'Error al actualizar el libro: $error'));
    }
  }

  void _onDeleteBookEvent(
      DeleteBookEvent event, Emitter<CatalogState> emit) async {
    emit(state.copyWith(status: CatalogStatus.loading));

    try {
      await _dio.delete("$_url/${event.bookId}.json");

      final updatedBooks =
          state.books.where((book) => book.id != event.bookId).toList();
      emit(state.copyWith(status: CatalogStatus.success, books: updatedBooks));
    } catch (error) {
      emit(state.copyWith(
          status: CatalogStatus.failure,
          error: 'Error al eliminar el libro: $error'));
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
        throw Exception("Datos incompletos en el libro con ID: ${entry.key}");
      }

      return BookModel(
        id: entry.key,
        author: bookData['author'],
        name: bookData['name'],
        imageUrl: bookData['image_url'],
        price: (bookData['price'] as num).toDouble(),
        description: bookData['description'],
      );
    }).toList();
  }
}
