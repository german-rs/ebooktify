import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'info_container_widget.dart'; // Importando el nuevo widget para la información adicional del libro
import 'detail_cart.dart'; // Importando el nuevo widget para el carrito de compras

class BookDetailSection extends StatelessWidget {
  final BookModel book;

  const BookDetailSection({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Abarcar todo el ancho de la pantalla
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.myWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7, // 70% del ancho
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price: \$${book.price}', // Precio real del libro desde la API
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      book.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      book.author,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3, // 30% del ancho
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.bookmark_border_outlined),
                      onPressed: () {
                        // Acción al presionar el icono de favorito
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          InfoContainerWidget(), // Usando el nuevo widget para la información adicional del libro
          const SizedBox(height: 16.0),
          Text(
            'Description',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            book.description,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          DetailCart(), // Usando el nuevo widget para el carrito de compras
        ],
      ),
    );
  }
}
