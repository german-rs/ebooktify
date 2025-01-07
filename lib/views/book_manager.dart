import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:booktify/widgets/custom_app_bar.dart';
import 'package:booktify/widgets/book_form.dart';
import 'package:flutter/material.dart';

class BookManager extends StatelessWidget {
  final BookModel? book;

  const BookManager({super.key, this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        type: AppBarType.bookManager,
      ),
      backgroundColor: AppColors.myWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BookForm(book: book),
      ),
    );
  }
}
