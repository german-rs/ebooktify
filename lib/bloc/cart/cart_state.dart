part of 'cart_bloc.dart';

enum CartStatus { initial, loading, success, failure, purchaseSuccess }

class CartState extends Equatable {
  final List<BookModel> cart;
  final CartStatus status;
  final String error;

  const CartState({
    this.cart = const [],
    this.status = CartStatus.initial,
    this.error = '',
  });

  CartState copyWith({
    List<BookModel>? cart,
    CartStatus? status,
    String? error,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [cart, status, error];
}
