import 'package:booktify/bloc/cart/cart_bloc.dart';
import 'package:booktify/views/cart_view.dart';
import 'package:booktify/views/catalog_view.dart';
import 'package:flutter/material.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppBarType {
  home,
  detail,
  reading,
  bookmark,
  cart,
  catalog,
  bookManager,
  moreBooks,
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBarType type;
  final String? title;
  final Color backgroundColor;
  final double height;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onActionPressed;

  const CustomAppBar({
    super.key,
    this.type = AppBarType.home,
    this.title,
    this.backgroundColor = AppColors.myWhite,
    this.height = 60.0,
    this.onLeadingPressed,
    this.onActionPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();
    if (widget.type == AppBarType.home) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CartBloc>().add(LoadCartEvent());
      });
    }
  }

  String _getAppBarTitle() {
    switch (widget.type) {
      case AppBarType.reading:
        return 'Reading';
      case AppBarType.bookmark:
        return 'Bookmark';
      case AppBarType.cart:
        return 'Shopping Cart';
      case AppBarType.catalog:
        return 'Catalogue of Books';
      case AppBarType.bookManager:
        return 'Book Manager';
      case AppBarType.moreBooks:
        return 'More Books';
      case AppBarType.detail:
        return widget.title ?? 'Detail Book';
      default:
        return widget.title ?? '';
    }
  }

  IconData _getActionIcon() {
    switch (widget.type) {
      case AppBarType.detail:
        return Icons.share;
      case AppBarType.moreBooks:
        return Icons.more_horiz;
      default:
        return Icons.share;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case AppBarType.home:
        return _buildHomeAppBar();
      case AppBarType.detail:
      case AppBarType.moreBooks:
        return _buildActionAppBar();
      case AppBarType.reading:
      case AppBarType.bookmark:
      case AppBarType.cart:
      case AppBarType.catalog:
      case AppBarType.bookManager:
        return _buildSimpleAppBar();
    }
  }

  Widget _buildHomeAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: AppBar(
        backgroundColor: widget.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: widget.onLeadingPressed ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CatalogView()),
                );
              },
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
                  if (state.status == CartStatus.loading ||
                      state.cart.isEmpty) {
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
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/img/avatar.jpg'),
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

  Widget _buildActionAppBar() {
    return AppBar(
      backgroundColor: widget.type == AppBarType.detail
          ? AppColors.myGrey
          : AppColors.myWhite,
      title: widget.type == AppBarType.moreBooks
          ? Center(child: Text(_getAppBarTitle()))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _getAppBarTitle(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(_getActionIcon()),
          onPressed: widget.onActionPressed ?? () {},
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  Widget _buildSimpleAppBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: AppBar(
        title: Text(_getAppBarTitle()),
        centerTitle: true,
        backgroundColor: AppColors.myWhite,
      ),
    );
  }
}
