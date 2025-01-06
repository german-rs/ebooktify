import 'package:booktify/bloc/cart/cart_bloc.dart';
import 'package:booktify/bloc/reading/reading_bloc.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:booktify/views/reading_view.dart';
import 'package:booktify/widgets/cart_item.dart';
import 'package:booktify/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CartBloc>()..add(LoadCartEvent()),
      child: Scaffold(
        appBar: const CustomAppBar(
          type: AppBarType.cart,
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
                        onPressed: () async {
                          final cartBloc = context.read<CartBloc>();
                          final readingBloc = context.read<ReadingBloc>();
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);

                          try {
                            // Mostrar diálogo de confirmación
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Confirmar compra'),
                                content: Text(
                                    '¿Deseas proceder con la compra de ${state.cart.length} libros?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, true),
                                    child: const Text('Confirmar'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              // Guardar referencia al ScaffoldMessenger antes de las operaciones asíncronas
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Procesando compra...'),
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              // Añadir cada libro del carrito a Reading
                              for (var book in state.cart) {
                                readingBloc.add(AddReadingEvent(book));
                              }

                              // Esperar un momento para asegurar que los libros se han añadido
                              await Future.delayed(
                                  const Duration(milliseconds: 500));

                              // Limpiar el carrito
                              cartBloc.add(const ClearCartEvent());

                              // Verificar si el widget sigue montado
                              if (context.mounted) {
                                scaffoldMessenger
                                    .clearSnackBars(); // Limpiar SnackBars anteriores
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('¡Compra realizada con éxito!'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                // Navegar a ReadingView
                                navigator.push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ReadingView()),
                                );
                              }
                            }
                          } catch (error) {
                            if (context.mounted) {
                              scaffoldMessenger
                                  .clearSnackBars(); // Limpiar SnackBars anteriores
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error al procesar la compra: ${error.toString()}'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
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
        body: Container(
          color: AppColors.myWhite,
          child: BlocBuilder<CartBloc, CartState>(
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
      ),
    );
  }
}
