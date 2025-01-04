part of 'cart_bloc.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.cartStatus = CartStatus.initial,
    this.cart = const [],
    this.error = '',
  });

  final CartStatus status;
  final CartStatus cartStatus;
  final List<BookModel> cart;
  final String error;

  CartState copyWith({
    CartStatus? status,
    CartStatus? cartStatus,
    List<BookModel>? cart,
    String? error,
  }) {
    return CartState(
      status: status ?? this.status,
      cartStatus: cartStatus ?? this.cartStatus,
      cart: cart ?? this.cart,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, cartStatus, cart, error];
}
