import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/booktify_bloc.dart';
import 'views/main_view.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => BooktifyBloc(),
      child: const MaterialApp(
        home: MainView(),
      ),
    ),
  );
}
