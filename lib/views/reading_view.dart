import 'package:booktify/widgets/custom_app_bar.dart';
import 'package:booktify/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/bloc/reading/current/current_reading_bloc.dart';
import 'package:booktify/bloc/reading/reading_bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';

class ReadingView extends StatelessWidget {
  const ReadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          _ReadingHeader(),
          _ReadingContent(),
        ],
      ),
    );
  }
}

class _ReadingHeader extends StatelessWidget {
  const _ReadingHeader();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: const CustomAppBar(
        type: AppBarType.reading,
      ),
    );
  }
}

class _ReadingContent extends StatefulWidget {
  const _ReadingContent();

  @override
  State<_ReadingContent> createState() => _ReadingContentState();
}

class _ReadingContentState extends State<_ReadingContent> {
  @override
  void initState() {
    super.initState();
    _loadReadingList();
  }

  void _loadReadingList() {
    context.read<ReadingBloc>().add(const LoadReadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: BlocBuilder<ReadingBloc, ReadingState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(ReadingState state) {
    if (state.status == ReadingStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ReadingStatus.failure) {
      return _ErrorView(
        error: state.error,
        onRetry: _loadReadingList,
      );
    }

    if (state.reading.isEmpty) {
      return const _EmptyView();
    }

    return _BookList(books: state.reading);
  }
}

class _ErrorView extends StatelessWidget {
  final String? error;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No books purchased',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}

class _BookList extends StatelessWidget {
  final List<BookModel> books;

  const _BookList({required this.books});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ReadingBloc>().add(const LoadReadingEvent());
      },
      child: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) => BookCard(book: books[index]),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final BookModel book;

  const BookCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      color: AppColors.myGrey,
      child: Row(
        children: [
          Expanded(
            child: _BookInfo(book: book),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: _ReadingButton(book: book),
          ),
        ],
      ),
    );
  }
}

class _BookInfo extends StatelessWidget {
  final BookModel book;

  const _BookInfo({required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _BookCover(imageUrl: book.imageUrl),
      title: Text(
        book.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.author,
            style: const TextStyle(fontSize: 10),
          ),
          const RatingStars(),
        ],
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  final String imageUrl;

  const _BookCover({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        imageUrl,
        width: 50,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.book),
      ),
    );
  }
}

class _ReadingButton extends StatelessWidget {
  final BookModel book;

  const _ReadingButton({required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: book.isReading ? Colors.grey : AppColors.myOrange,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => _handleReadingStatus(context),
        child: Text(
          book.isReading ? 'Leyendo' : 'Iniciar lectura',
          style: const TextStyle(color: AppColors.myWhite, fontSize: 10),
        ),
      ),
    );
  }

  void _handleReadingStatus(BuildContext context) {
    context.read<ReadingBloc>().add(
          UpdateReadingStatusEvent(
            book,
            !book.isReading,
          ),
        );
    context.read<CurrentReadingBloc>().add(
          UpdateCurrentReading(
            book.copyWith(
              isReading: !book.isReading,
            ),
            !book.isReading,
          ),
        );
  }
}
