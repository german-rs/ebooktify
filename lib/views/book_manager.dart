import 'package:booktify/bloc/catalog/catalog_bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:booktify/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookManager extends StatefulWidget {
  final BookModel? book;

  const BookManager({super.key, this.book});

  @override
  State<BookManager> createState() => _BookManagerState();
}

class _BookManagerState extends State<BookManager> {
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
      _authorController.text = widget.book!.author;
      _bookNameController.text = widget.book!.name;
      _descriptionController.text = widget.book!.description;
      _imageUrlController.text = widget.book!.imageUrl;
      _priceController.text = widget.book!.price.toString();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        type: AppBarType.bookManager,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the author name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bookNameController,
                  decoration: const InputDecoration(labelText: 'Book name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the book name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.book == null) {
                        context.read<CatalogBloc>().add(
                              CreateNewBookEvent(
                                author: _authorController.text,
                                name: _bookNameController.text,
                                description: _descriptionController.text,
                                imageUrl: _imageUrlController.text,
                                price: double.parse(_priceController.text),
                              ),
                            );
                      } else {
                        context.read<CatalogBloc>().add(
                              UpdateCatalogBookEvent(
                                bookModel: BookModel(
                                  id: widget.book!.id,
                                  author: _authorController.text,
                                  name: _bookNameController.text,
                                  description: _descriptionController.text,
                                  imageUrl: _imageUrlController.text,
                                  price: double.parse(_priceController.text),
                                ),
                              ),
                            );
                      }

                      _authorController.clear();
                      _bookNameController.clear();
                      _descriptionController.clear();
                      _imageUrlController.clear();
                      _priceController.clear();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.myOrange,
                    foregroundColor: AppColors.myWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child:
                      Text(widget.book == null ? 'Save book' : 'Update book'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
