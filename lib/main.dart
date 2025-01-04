import 'package:booktify/bloc/carousel/carousel_bloc.dart';
import 'package:booktify/bloc/cart/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/favorites/favorites_bloc.dart';
import 'views/main_view.dart';
import 'utils/app_color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FavoritesBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => CarouselBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.myGrey,
        ),
        home: const MainView(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
