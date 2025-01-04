import 'package:booktify/bloc/cart/cart_bloc.dart';
import 'package:booktify/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadCartEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: AppBar(
        backgroundColor: AppColors.myWhite,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartView()),
                  );
                },
              ),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state.cartStatus == CartStatus.loading) {
                    return const SizedBox.shrink();
                  }

                  if (state.cart.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final total = state.cart.fold(
                    0,
                    (sum, book) => sum + book.quantity,
                  );

                  return Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.myOrange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          total.toString(),
                          style: const TextStyle(
                            color: AppColors.myWhite,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundImage: const AssetImage('assets/img/person.jpg'),
              radius: 16,
            ),
          ),
        ],
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(),
        ),
      ),
    );
  }
}
