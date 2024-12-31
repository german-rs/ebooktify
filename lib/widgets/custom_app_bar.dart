import 'package:booktify/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0), // Añadir padding superior general
      child: AppBar(
        backgroundColor: AppColors.myWhite,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Acción al presionar el icono de tuerca
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Acción al presionar el icono del carrito de compras
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/img/person.jpg'),
              radius: 16,
            ),
          ),
        ],
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20.0), // Espacio superior
          child: Container(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
