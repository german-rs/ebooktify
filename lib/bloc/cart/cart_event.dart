part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddToCartEvent extends CartEvent {
  final BookModel book;

  const AddToCartEvent(this.book);

  @override
  List<Object> get props => [book];
}

class UpdateCartQuantityEvent extends CartEvent {
  final BookModel book;
  final int newQty;

  const UpdateCartQuantityEvent({
    required this.book,
    required this.newQty,
  });

  @override
  List<Object> get props => [book, newQty];
}

class RemoveCartItemEvent extends CartEvent {
  final BookModel book;

  const RemoveCartItemEvent(this.book);

  @override
  List<Object> get props => [book];
}
