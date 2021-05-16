part of 'images_bloc.dart';

enum ImagesStatus { Loading, Error, Success }

@JsonSerializable(explicitToJson: true)
@immutable
class ImagesState extends Equatable {
  const ImagesState({
    this.status = ImagesStatus.Loading,
    this.images = const <PicsumImageData>[],
    this.currentPage = 0,
    this.errorText = '',
  });

  factory ImagesState.fromJson(Map<String, dynamic> json) =>
      _$ImagesStateFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesStateToJson(this);

  final ImagesStatus status;
  final List<PicsumImageData> images;
  final int currentPage;
  final String errorText;

  ImagesState copyWith({
    ImagesStatus status,
    List<PicsumImageData> images,
    int currentPage,
    String errorText,
  }) {
    return ImagesState(
      status: status ?? this.status,
      images: images ?? this.images,
      currentPage: currentPage ?? this.currentPage,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object> get props => <Object>[status, images, currentPage, errorText];

  @override
  bool get stringify => true;
}
