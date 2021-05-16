import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `PicsumImageData` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'picsum_image_data.g.dart';

const int scaleDownWidth = 300;

@JsonSerializable()
@immutable
class PicsumImageData extends Equatable {
  const PicsumImageData({
    this.id,
    this.author,
    this.width,
    this.height,
    this.url,
    this.downloadUrl,
  });

  /// A necessary factory constructor for creating a new PicsumImageData instance
  /// from a map. Pass the map to the generated `_$PicsumImageDataFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PicsumImageData.fromJson(Map<String, dynamic> json) =>
      _$PicsumImageDataFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PicsumImageDataToJson`.
  Map<String, dynamic> toJson() => _$PicsumImageDataToJson(this);

  final String id;
  final String author;
  final int width;
  final int height;
  final String url;
  @JsonKey(name: 'download_url')
  final String downloadUrl;

  double getHeightForWidthDisplay(int displayWidth) {
    final double ratio = height / width;

    return displayWidth * ratio;
  }

  String scaleDownDownloadUrl() {
    final int scaleDownHeight =
        getHeightForWidthDisplay(scaleDownWidth).toInt();

    List<String> split = downloadUrl.split(RegExp('/'));

    split[split.length - 1] = scaleDownHeight.toString();
    split[split.length - 2] = scaleDownWidth.toString();

    String updatedUrl = '';

    for (int i = 0; i < split.length; i++) {
      updatedUrl += split[i] += '/';
    }

    return updatedUrl;
  }

  @override
  List<Object> get props =>
      <Object>[id, author, width, height, url, downloadUrl];

  @override
  bool get stringify => true;
}
