import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:booktify/models/book_model.dart';

// Events
abstract class CurrentReadingEvent extends Equatable {
  const CurrentReadingEvent();

  @override
  List<Object> get props => [];
}

class UpdateCurrentReading extends CurrentReadingEvent {
  final BookModel book;
  final bool isReading;

  const UpdateCurrentReading(this.book, this.isReading);

  @override
  List<Object> get props => [book, isReading];
}

// State
class CurrentReadingState extends Equatable {
  final BookModel? currentBook;
  final bool isReading;

  const CurrentReadingState({
    this.currentBook,
    this.isReading = false,
  });

  CurrentReadingState copyWith({
    BookModel? currentBook,
    bool? isReading,
  }) {
    return CurrentReadingState(
      currentBook: currentBook ?? this.currentBook,
      isReading: isReading ?? this.isReading,
    );
  }

  @override
  List<Object?> get props => [currentBook, isReading];
}

// Bloc
class CurrentReadingBloc
    extends Bloc<CurrentReadingEvent, CurrentReadingState> {
  CurrentReadingBloc() : super(const CurrentReadingState()) {
    on<UpdateCurrentReading>(_onUpdateCurrentReading);
  }

  void _onUpdateCurrentReading(
    UpdateCurrentReading event,
    Emitter<CurrentReadingState> emit,
  ) {
    if (event.isReading) {
      emit(state.copyWith(
        currentBook: event.book,
        isReading: true,
      ));
    } else {
      emit(const CurrentReadingState());
    }
  }
}
