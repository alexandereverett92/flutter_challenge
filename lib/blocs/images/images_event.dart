part of 'images_bloc.dart';

@immutable
abstract class ImagesEvent extends Equatable {
  const ImagesEvent();
}

class ImagesStart extends ImagesEvent {
  @override
  List<Object> get props => <Object>[];
}

class ImagesNext extends ImagesEvent {
  const ImagesNext();

  @override
  List<Object> get props => <Object>[];
}
