part of 'booktify_bloc.dart';

sealed class BooktifyState extends Equatable {
  const BooktifyState();
  
  @override
  List<Object> get props => [];
}

final class BooktifyInitial extends BooktifyState {}
