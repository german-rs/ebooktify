import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'booktify_event.dart';
part 'booktify_state.dart';

class BooktifyBloc extends Bloc<BooktifyEvent, BooktifyState> {
  BooktifyBloc() : super(BooktifyInitial()) {
    on<BooktifyEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
