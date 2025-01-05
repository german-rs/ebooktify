import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final String id;
  final String author;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final int quantity;
  final bool isReading; // Nuevo campo

  const BookModel({
    required this.id,
    required this.author,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    this.quantity = 1,
    this.isReading = false, // Asignamos un valor por defecto
  });

  // Método factory para crear un BookModel desde un Map
  factory BookModel.fromMap(String id, Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] as String? ?? id,
      author: map['author'] as String? ?? 'Unknown Author',
      name: map['name'] as String? ?? 'Unknown Name',
      imageUrl: map['image_url'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String? ?? '',
      isReading: map['is_reading'] as bool? ?? false, // Manejo seguro de null
    );
  }

  // Método para convertir el BookModel a un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'name': name,
      'image_url': imageUrl,
      'price': price,
      'description': description,
      'is_reading': isReading,
    };
  }

  BookModel copyWith({
    String? id,
    String? author,
    String? name,
    String? imageUrl,
    double? price,
    String? description,
    int? quantity,
    bool? isReading, // Añadido al copyWith
  }) {
    return BookModel(
      id: id ?? this.id,
      author: author ?? this.author,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      isReading: isReading ?? this.isReading, // Añadido al constructor
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
        isReading, // Añadido a props
      ];
}
