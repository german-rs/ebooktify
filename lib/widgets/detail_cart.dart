import 'package:flutter/material.dart';
import 'package:booktify/utils/app_color.dart';

class DetailCart extends StatelessWidget {
  const DetailCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    // Acción al presionar el icono de resta
                  },
                ),
                const Text('1', style: TextStyle(fontSize: 16.0)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Acción al presionar el icono de suma
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          flex: 4,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.myOrange,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              // Acción al presionar el botón de añadir al carrito
            },
            child: const Text('Add to Cart',
                style: TextStyle(fontSize: 16.0, color: AppColors.myWhite)),
          ),
        ),
      ],
    );
  }
}
