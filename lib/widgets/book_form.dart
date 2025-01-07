import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/bloc/catalog/catalog_bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';

class BookForm extends StatefulWidget {
  final BookModel? book;

  const BookForm({super.key, this.book});

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  final _authorController = TextEditingController();
  final _bookNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _initializeControllers(widget.book!);
    }
  }

  void _initializeControllers(BookModel book) {
    _authorController.text = book.author;
    _bookNameController.text = book.name;
    _descriptionController.text = book.description;
    _imageUrlController.text = book.imageUrl;
    _priceController.text = book.price.toString();
  }

  @override
  void dispose() {
    _authorController.dispose();
    _bookNameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter the $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state.status == CatalogStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state.status == CatalogStatus.success) {
          _clearControllers();
          Navigator.pop(context);
        }
      },
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildTextFormField(_authorController, 'Author'),
                  _buildTextFormField(_bookNameController, 'Book name'),
                  _buildTextFormField(_descriptionController, 'Description',
                      maxLines: 3),
                  _buildImageUrlField(),
                  _buildTextFormField(_priceController, 'Price',
                      keyboardType: TextInputType.number, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveOrUpdateBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.myOrange,
                      foregroundColor: AppColors.myWhite,
                    ),
                    child:
                        Text(widget.book == null ? 'Save book' : 'Update book'),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<CatalogBloc, CatalogState>(
            builder: (context, state) {
              if (state.status == CatalogStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator ?? (value) => _validateField(value, label),
      ),
    );
  }

  void _saveOrUpdateBook() {
    if (_formKey.currentState!.validate()) {
      final imageUrl = _imageUrlController.text.isEmpty
          ? 'assets/img/no-image.jpg'
          : _imageUrlController.text;

      final bookEvent = widget.book == null
          ? CreateNewBookEvent(
              author: _authorController.text,
              name: _bookNameController.text,
              description: _descriptionController.text,
              imageUrl: imageUrl,
              price: double.parse(_priceController.text),
            )
          : UpdateCatalogBookEvent(
              bookModel: BookModel(
                id: widget.book!.id,
                author: _authorController.text,
                name: _bookNameController.text,
                description: _descriptionController.text,
                imageUrl: imageUrl,
                price: double.parse(_priceController.text),
              ),
            );

      context.read<CatalogBloc>().add(bookEvent);
    }
  }

  void _clearControllers() {
    _authorController.clear();
    _bookNameController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _priceController.clear();
  }

  Widget _buildImageUrlField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _imageUrlController,
          decoration: InputDecoration(
            labelText: 'Image URL',
            hintText: 'Enter image URL or leave empty for default image',
            suffixIcon: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                _showDefaultImageInfo(context);
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Default: assets/img/no-image.jpg will be used if left empty',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _showDefaultImageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image URL Information'),
        content: const Text(
          'You can provide an image URL or leave it empty to use the default image (assets/img/no-image.jpg).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
