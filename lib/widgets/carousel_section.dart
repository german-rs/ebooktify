import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/bloc/booktify_bloc.dart';
import 'package:booktify/bloc/booktify_event.dart';
import 'package:booktify/bloc/booktify_state.dart';
import 'package:booktify/views/more_book_view.dart';
import 'package:booktify/views/detail_book_view.dart';
import 'package:booktify/models/book_model.dart'; // Importa BookModel

class CarouselSection extends StatelessWidget {
  const CarouselSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BooktifyBloc()..add(LoadCarouselEvent()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16.0),
          _buildCarousel(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Trending Book',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MoreBookView()),
            );
          },
          child: const Text(
            'See more',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return SizedBox(
      height: 250.0,
      child: BlocBuilder<BooktifyBloc, BooktifyState>(
        builder: (context, state) {
          if (state.carouselStatus == CarouselStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.carouselStatus == CarouselStatus.failure) {
            return const Center(child: Text('Failed to load books'));
          } else if (state.carouselStatus == CarouselStatus.success) {
            // Limitar el número de libros a 5
            final books = state.books.take(5).toList();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
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
                  child: _buildBookItem(context, book),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, BookModel book) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(book.imageUrl, fit: BoxFit.cover, height: 150),
          ),
          const SizedBox(height: 8.0),
          Text(book.author),
          const SizedBox(height: 4.0),
          Text(
            book.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
