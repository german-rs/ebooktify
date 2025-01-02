import 'package:flutter/material.dart';
import 'package:booktify/utils/app_color.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.myGrey,
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('Detail Book', style: TextStyle(color: Colors.black)),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // Acción al presionar el icono de compartir
          },
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
