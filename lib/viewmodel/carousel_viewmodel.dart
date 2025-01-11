import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/bloc/carousel/carousel_bloc.dart';
import 'package:booktify/models/book_model.dart';

class CarouselViewModel {
  final BuildContext context;

  CarouselViewModel(this.context);

  CarouselState get state => context.watch<CarouselBloc>().state;

  List<BookModel> get books {
    if (state.status == CarouselStatus.success) {
      return state.books;
    }
    return [];
  }

  List<BookModel> get trendingBooks {
    return books.take(5).toList();
  }

  bool get isLoading => state.status == CarouselStatus.loading;

  String? get error {
    if (state.status == CarouselStatus.failure) {
      return state.error;
    }
    return null;
  }
}
