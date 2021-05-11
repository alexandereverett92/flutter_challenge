part of 'images_bloc.dart';

@immutable
abstract class ImagesState extends Equatable {
  const ImagesState();
}

class ImagesLoading extends ImagesState {
  @override
  List<Object> get props => <Object>[];
}

class ImagesLoaded extends ImagesState {
  const ImagesLoaded();

  @override
  List<Object> get props => <Object>[];
}

class ImagesError extends ImagesState {
  const ImagesError();

  @override
  List<Object> get props => <Object>[];
}
