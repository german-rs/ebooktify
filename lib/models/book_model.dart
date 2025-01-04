import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final String id;
  final String author;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final int quantity;

  const BookModel({
    required this.id,
    required this.author,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    this.quantity = 1,
  });

  BookModel copyWith({
    String? id,
    String? author,
    String? name,
    String? imageUrl,
    double? price,
    String? description,
    int? quantity,
  }) {
    return BookModel(
      id: id ?? this.id,
      author: author ?? this.author,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        id,
        author,
        name,
        imageUrl,
        price,
        description,
        quantity,
      ];
}
