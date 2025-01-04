import 'package:booktify/bloc/cart/cart_bloc.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:booktify/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CartBloc>()..add(LoadCartEvent()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Shopping Cart",
            style: TextStyle(
              color: AppColors.myDarkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.cart.isEmpty) {
              return const SizedBox.shrink();
            }

            final total = state.cart.fold(
              0.0,
              (sum, book) => sum + (book.price * book.quantity),
            );

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.myDarkGrey,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.myOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.myOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Aquí irá la lógica del checkout
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Procesando checkout...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.cartStatus == CartStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.cartStatus == CartStatus.failure) {
              return Center(
                child: Text(state.error),
              );
            }

            if (state.cart.isEmpty) {
              return const Center(
                child: Text(
                  "Sin productos agregados al carrito de compra",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.myDarkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.cart.length,
              padding: const EdgeInsets.only(bottom: 100),
              itemBuilder: (context, index) {
                final book = state.cart[index];
                return CartItem(book: book);
              },
            );
          },
        ),
      ),
    );
  }
}
