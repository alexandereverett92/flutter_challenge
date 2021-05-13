import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gelato_flutter_challenge/ui/pages/fullscreen_image_page.dart';

class ImageDisplay extends StatefulWidget {
  const ImageDisplay({this.url});
  final String url;

  @override
  State<StatefulWidget> createState() => _ImageDisplay();
}

class _ImageDisplay extends State<ImageDisplay> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeOutDuration: const Duration(milliseconds: 300),
      fadeInDuration: const Duration(milliseconds: 300),
      imageUrl: widget.url,
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) =>
              GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<FullscreenImagePage>(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return FullscreenImagePage(
                  imageProvider: imageProvider,
                );
              },
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      placeholder: (BuildContext context, String url) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
          child: const CircularProgressIndicator(),
        ),
      ),
      errorWidget: (BuildContext context, String url, Object error) =>
          const Icon(Icons.error),
    );
  }
}
