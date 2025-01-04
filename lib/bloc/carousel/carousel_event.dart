part of 'carousel_bloc.dart';

abstract class CarouselEvent extends Equatable {
  const CarouselEvent();

  @override
  List<Object> get props => [];
}

class LoadCarouselEvent extends CarouselEvent {
  const LoadCarouselEvent();

  @override
  List<Object> get props => [];
}
