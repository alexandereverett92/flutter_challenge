part of 'images_bloc.dart';

@immutable
abstract class ImagesEvent extends Equatable {
  const ImagesEvent();
}

/// Event to dispatch when loading images from the picsum api
/// Will retrieve the next 'page' of images
/// https://picsum.photos/
class ImagesNext extends ImagesEvent {
  const ImagesNext();

  @override
  List<Object> get props => <Object>[];
}
