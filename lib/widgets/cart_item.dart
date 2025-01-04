import 'package:booktify/bloc/cart/cart_bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItem extends StatelessWidget {
  final BookModel book;

  const CartItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 138,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<CartBloc>().add(RemoveCartItemEvent(book));
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.myGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.network(book.imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    book.name,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${book.price * book.quantity}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (book.quantity > 1) {
                                context.read<CartBloc>().add(
                                      UpdateCartQuantityEvent(
                                        book: book,
                                        newQty: -1,
                                      ),
                                    );
                              }
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.black,
                              size: 14,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            child: Center(
                              child: Text(book.quantity.toString()),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (book.quantity < 5) {
                                context.read<CartBloc>().add(
                                      UpdateCartQuantityEvent(
                                        book: book,
                                        newQty: 1,
                                      ),
                                    );
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
