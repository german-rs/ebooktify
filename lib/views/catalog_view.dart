import 'package:booktify/bloc/catalog/catalog_bloc.dart';
import 'package:booktify/models/book_model.dart';
import 'package:booktify/utils/app_color.dart';
import 'package:booktify/views/book_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(const LoadCatalogEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catalogue of Books',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state.status == CatalogStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == CatalogStatus.success) {
            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                return _BookItem(book: book);
              },
            );
          } else if (state.status == CatalogStatus.failure) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('No hay libros disponibles'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookManager()),
          );
        },
        backgroundColor: AppColors.myOrange,
        foregroundColor: AppColors.myWhite,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BookItem extends StatelessWidget {
  final BookModel book;

  const _BookItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<CatalogBloc>().add(DeleteBookEvent(bookId: book.id));
            },
          ),
          Image.network(
            book.imageUrl,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/img/no-image.jpg');
            },
          ),
        ],
      ),
      title: Text(book.name),
      subtitle: Text(book.author),
      trailing: Text('\$${book.price.toStringAsFixed(2)}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookManager(book: book),
          ),
        );
      },
    );
  }
}
