import 'package:booktify/bloc/current_reading_bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/bloc/reading/reading_bloc.dart';

class ReadingView extends StatefulWidget {
  const ReadingView({super.key});

  @override
  State<ReadingView> createState() => _ReadingViewState();
}

class _ReadingViewState extends State<ReadingView> {
  @override
  void initState() {
    super.initState();
    context.read<ReadingBloc>().add(const LoadReadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading'),
        centerTitle: true,
      ),
      body: BlocBuilder<ReadingBloc, ReadingState>(
        builder: (context, state) {
          if (state.status == ReadingStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == ReadingStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReadingBloc>().add(const LoadReadingEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.reading.isEmpty) {
            return const Center(
              child: Text(
                'No books purchased',
                style: TextStyle(fontSize: 18.0),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ReadingBloc>().add(const LoadReadingEvent());
              return;
            },
            child: ListView.builder(
              itemCount: state.reading.length,
              itemBuilder: (context, index) {
                final book = state.reading[index];
                return BookCard(book: book);
              },
            ),
          );
        },
      ),
    );
  }
}

class BookCard extends StatefulWidget {
  final BookModel book;

  const BookCard({required this.book, super.key});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  widget.book.imageUrl,
                  width: 50,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.book),
                ),
              ),
              title: Text(
                widget.book.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.author,
                    style: const TextStyle(fontSize: 10),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: const [
                        Icon(Icons.star, color: Colors.yellow, size: 16.0),
                        Icon(Icons.star, color: Colors.yellow, size: 16.0),
                        Icon(Icons.star, color: Colors.yellow, size: 16.0),
                        Icon(Icons.star, color: Colors.yellow, size: 16.0),
                        Icon(Icons.star, color: Colors.grey, size: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.book.isReading ? Colors.grey : AppColors.myOrange,
                  alignment: Alignment.center,
                ),
                onPressed: () {
                  // Actualizar el estado en el ReadingBloc
                  context.read<ReadingBloc>().add(
                        UpdateReadingStatusEvent(
                          widget.book,
                          !widget.book.isReading,
                        ),
                      );

                  // Actualizar el CurrentReadingBloc
                  context.read<CurrentReadingBloc>().add(
                        UpdateCurrentReading(
                          widget.book.copyWith(
                            isReading: !widget.book.isReading,
                          ),
                          !widget.book.isReading,
                        ),
                      );
                },
                child: Text(
                  widget.book.isReading ? 'Leyendo' : 'Iniciar lectura',
                  style:
                      const TextStyle(color: AppColors.myWhite, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
