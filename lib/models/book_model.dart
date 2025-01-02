import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final String id;
  final String author;
  final String name;
  final String imageUrl;
  final double price;
  final String description; // Agregando el campo description

  const BookModel({
    required this.id,
    required this.author,
    required this.name,
    required this.imageUrl,
    required this.price, // Incluyendo el campo price
    required this.description, // Incluyendo el campo description
  });

  BookModel copyWith({
    String? id,
    String? author,
    String? name,
    String? imageUrl,
    double? price,
    String? description, // Agregando el campo description en copyWith
  }) {
    return BookModel(
      id: id ?? this.id,
      author: author ?? this.author,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price, // Actualizando el campo price
      description:
          description ?? this.description, // Actualizando el campo description
    );
  }

  @override
  List<Object?> get props => [
        id,
        author,
        name,
        imageUrl,
        price,
        description, // Incluyendo el campo description en props
      ];
}
