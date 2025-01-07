import 'package:bloc/bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final Dio _dio = Dio();

  final String urlCart = dotenv.env['CART_URL'] ?? '';

  CartBloc() : super(const CartState()) {
    on<LoadCartEvent>(_onLoadCartEvent);
    on<AddToCartEvent>(_onAddToCartEvent);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantityEvent);
    on<RemoveCartItemEvent>(_onRemoveCartItemEvent);
    on<ClearCartEvent>(_onClearCartEvent);
  }

  void _onLoadCartEvent(LoadCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartState(
        status: CartStatus.loading,
      ));

      final response = await _dio.get("$urlCart.json");

      if (response.data == null) {
        emit(CartState(
          cart: [],
          status: CartStatus.success,
        ));
        return;
      }

      final data = response.data as Map<String, dynamic>;
      final List<BookModel> cartItems = [];

      data.forEach((key, value) {
        cartItems.add(BookModel(
          id: value['id'] ?? key,
          author: value['author'] ?? '',
          name: value['name'] ?? '',
          imageUrl: value['image_url'] ?? '',
          price: (value['price'] ?? 0).toDouble(),
          description: value['description'] ?? '',
          quantity: value['quantity'] ?? 1,
        ));
      });

      emit(CartState(
        cart: cartItems,
        status: CartStatus.success,
      ));
    } catch (error) {
      emit(CartState(
        status: CartStatus.failure,
        error: 'Failed to load cart',
      ));
    }
  }

  void _onAddToCartEvent(AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));

      final bookData = {
        "id": event.book.id,
        "author": event.book.author,
        "name": event.book.name,
        "image_url": event.book.imageUrl,
        "price": event.book.price,
        "description": event.book.description,
        "quantity": event.book.quantity,
      };

      final response = await _dio.put(
        "$urlCart/${event.book.id}.json",
        data: bookData,
      );

      if (response.statusCode == 200) {
        final updatedCart = List<BookModel>.from(state.cart);
        final existingIndex =
            updatedCart.indexWhere((b) => b.id == event.book.id);

        if (existingIndex >= 0) {
          updatedCart[existingIndex] = event.book;
        } else {
          updatedCart.add(event.book);
        }

        emit(state.copyWith(
          cart: updatedCart,
          status: CartStatus.success,
        ));
      } else {
        emit(state.copyWith(
          status: CartStatus.failure,
          error: 'Failed to add to cart',
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: CartStatus.failure,
        error: 'Failed to add to cart: ${error.toString()}',
      ));
    }
  }

  void _onUpdateCartQuantityEvent(
      UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    try {
      final newQuantity = event.book.quantity + event.newQty;

      if (newQuantity <= 0) {
        await _dio.delete("$urlCart/${event.book.id}.json");
        final updatedCart =
            state.cart.where((b) => b.id != event.book.id).toList();
        emit(CartState(
          cart: updatedCart,
          status: CartStatus.success,
        ));
      } else {
        await _dio.patch(
          "$urlCart/${event.book.id}.json",
          data: {"quantity": newQuantity},
        );
        final updatedCart = [
          for (var b in state.cart)
            if (b.id == event.book.id) b.copyWith(quantity: newQuantity) else b
        ];
        emit(CartState(
          cart: updatedCart,
          status: CartStatus.success,
        ));
      }
    } catch (_) {
      emit(CartState(
        cart: state.cart,
        status: CartStatus.failure,
        error: 'Failed to update quantity',
      ));
    }
  }

  void _onRemoveCartItemEvent(
      RemoveCartItemEvent event, Emitter<CartState> emit) async {
    try {
      await _dio.delete("$urlCart/${event.book.id}.json");
      final updatedCart =
          state.cart.where((b) => b.id != event.book.id).toList();
      emit(CartState(
        cart: updatedCart,
        status: CartStatus.success,
      ));
    } catch (_) {
      emit(CartState(
        cart: state.cart,
        status: CartStatus.failure,
        error: 'Failed to remove item',
      ));
    }
  }

  void _onClearCartEvent(ClearCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));

      await _dio.delete("$urlCart.json");

      emit(CartState(
        cart: [],
        status: CartStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CartStatus.failure,
        error: 'Failed to clear cart: ${error.toString()}',
      ));
    }
  }
}
