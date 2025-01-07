import 'package:booktify/bloc/cart/cart_bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:booktify/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailCart extends StatefulWidget {
  final BookModel book;
  const DetailCart({super.key, required this.book});
  @override
  DetailCartState createState() => DetailCartState();
}

class DetailCartState extends State<DetailCart> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CartStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.book.name} added to cart'),
              action: SnackBarAction(
                label: 'View Cart',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartView()),
                ),
              ),
            ),
          );
        } else if (state.status == CartStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.myWhite,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('QTY', style: TextStyle(fontSize: 16.0)),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (_quantity > 1) {
                        setState(() => _quantity--);
                      }
                    },
                  ),
                  Text('$_quantity', style: const TextStyle(fontSize: 16.0)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_quantity < 5) {
                        setState(() => _quantity++);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            flex: 4,
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.myOrange,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: state.status == CartStatus.loading
                      ? null
                      : () {
                          final bookToAdd = widget.book.copyWith(
                            quantity: _quantity,
                          );
                          context.read<CartBloc>().add(
                                AddToCartEvent(bookToAdd),
                              );
                        },
                  child: state.status == CartStatus.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Add to Cart',
                          style: TextStyle(
                              fontSize: 16.0, color: AppColors.myWhite),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
