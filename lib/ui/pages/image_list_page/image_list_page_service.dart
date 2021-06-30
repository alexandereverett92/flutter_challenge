import 'package:flutter/cupertino.dart';
import 'package:gelato_flutter_challenge/blocs/images/images_bloc.dart';
import 'package:gelato_flutter_challenge/models/picsum_image_data.dart';

class ImageListPageService {
  static const int minImagesPerRow = 3;

  /// Gives [true] when the following conditions are met:
  /// - [status] is success
  /// - [scrollController] has been attached to the view
  /// - The current scrolling position is less than twice
  /// the visible scroll area from the end.
  static bool shouldLoadImages(
      ScrollControllerData scrollController, ImagesState imagesState) {
    if (imagesState.status != ImagesStatus.Success) return false;

    if (!scrollController.hasClients) return false;

    if (scrollController.maxScrollExtent == null) return true;

    return scrollController.offset >
        scrollController.maxScrollExtent -
            scrollController.viewportDimension * 2;
  }

  /// Get an appropriate number of images to show in each row.
  /// Each image displayed is half the cached image size.
  /// Applies the [minImagesPerRow]
  static int getAxisCountForScreenWidth(double screenWidth) {
    final int count = (screenWidth / scaleDownWidth).ceil();

    return count > minImagesPerRow ? count : minImagesPerRow;
  }
}

class ScrollControllerData {
  const ScrollControllerData({
    this.hasClients,
    this.maxScrollExtent,
    this.offset,
    this.viewportDimension,
  });
  final bool hasClients;
  final double maxScrollExtent;
  final double offset;
  final double viewportDimension;

  static ScrollControllerData fromScrollController(
      ScrollController scrollController) {
    return ScrollControllerData(
      hasClients: scrollController.hasClients,
      offset: scrollController.offset,
      maxScrollExtent: scrollController.position.maxScrollExtent,
      viewportDimension: scrollController.position.viewportDimension,
    );
  }
}
