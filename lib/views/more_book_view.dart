import 'package:booktify/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/bloc/booktify_bloc.dart';
import 'package:booktify/bloc/booktify_event.dart';
import 'package:booktify/bloc/booktify_state.dart';
import 'package:booktify/views/detail_book_view.dart';
import 'package:booktify/models/book_model.dart'; // Importa BookModel

class MoreBookView extends StatelessWidget {
  const MoreBookView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite,
      appBar: AppBar(
        backgroundColor: AppColors.myWhite,
        title: const Center(child: Text('More Books')),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // Acción al presionar el icono
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => BooktifyBloc()..add(LoadCarouselEvent()),
        child: BlocBuilder<BooktifyBloc, BooktifyState>(
          builder: (context, state) {
            if (state.carouselStatus == CarouselStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.carouselStatus == CarouselStatus.failure) {
              return const Center(child: Text('Failed to load books'));
            } else if (state.carouselStatus == CarouselStatus.success) {
              return _buildBookGrid(context, state.books);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBookGrid(BuildContext context, List<BookModel> books) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.6,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailBookView(book: book),
              ),
            );
          },
          child: _buildBookItem(book),
        );
      },
    );
  }

  Widget _buildBookItem(BookModel book) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(book.imageUrl, fit: BoxFit.cover, height: 150),
        ),
        const SizedBox(height: 8.0),
        Text(book.author, textAlign: TextAlign.center),
        const SizedBox(height: 4.0),
        Text(
          book.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
