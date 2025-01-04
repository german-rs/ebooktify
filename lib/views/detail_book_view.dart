import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:booktify/widgets/book_detail_section.dart';
import 'package:booktify/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';

class DetailBookView extends StatelessWidget {
  final BookModel book;

  const DetailBookView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myGrey,
      appBar: DetailAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  book.imageUrl,
                  fit: BoxFit.cover,
                  height: 250,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            BookDetailSection(book: book),
          ],
        ),
      ),
    );
  }
}
