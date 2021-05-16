import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gelato_flutter_challenge/models/picsum_image_data.dart';
import 'package:gelato_flutter_challenge/ui/components/image_hero.dart';
import 'package:gelato_flutter_challenge/ui/components/sized_loading_indicator.dart';
import 'package:gelato_flutter_challenge/ui/pages/fullscreen_image_page.dart';
import 'package:gelato_flutter_challenge/ui/transitions/fade_page_route.dart';

const int imageCachedWidth = 600;
const Duration fadeDuration = Duration(milliseconds: 300);

class GridImageDisplay extends StatefulWidget {
  const GridImageDisplay({@required this.imageData});
  final PicsumImageData imageData;

  @override
  State<StatefulWidget> createState() => _ImageDisplay();
}

class _ImageDisplay extends State<GridImageDisplay> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      memCacheHeight:
          widget.imageData.getHeightForWidthDisplay(imageCachedWidth).toInt(),
      memCacheWidth: imageCachedWidth,
      maxWidthDiskCache: imageCachedWidth,
      maxHeightDiskCache:
          widget.imageData.getHeightForWidthDisplay(imageCachedWidth).toInt(),
      fadeOutDuration: fadeDuration,
      fadeInDuration: fadeDuration,
      imageUrl: widget.imageData.downloadUrl,
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) =>
              GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            FadePageRoute<FullscreenImagePage>(
              child: FullscreenImagePage(
                imageProvider: imageProvider,
                imageData: widget.imageData,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ImageHero(
            url: widget.imageData.downloadUrl,
            imageProvider: imageProvider,
            boxFit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (BuildContext context, String url) => Center(
        child: SizedLoadingIndicator(),
      ),
      errorWidget: (BuildContext context, String url, Object error) =>
          const Icon(Icons.error),
    );
  }
}
