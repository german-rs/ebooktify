import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/booktify_bloc.dart';
import 'views/main_view.dart';
import 'utils/app_color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    BlocProvider(
      create: (context) => BooktifyBloc(),
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
