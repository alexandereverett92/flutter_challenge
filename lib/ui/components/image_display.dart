import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gelato_flutter_challenge/ui/pages/fullscreen_image_page.dart';
import 'package:gelato_flutter_challenge/ui/transitions/fade_page_route.dart';

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
            FadePageRoute<FullscreenImagePage>(
              child: FullscreenImagePage(
                imageProvider: imageProvider,
                url: widget.url,
              ),
            ),
          );
        },
        child: Hero(
          tag: widget.url,
          transitionOnUserGestures: true,
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
      ),
      placeholder: (BuildContext context, String url) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 24, height: 24),
          child: const CircularProgressIndicator(),
        ),
      ),
      errorWidget: (BuildContext context, String url, Object error) =>
          const Icon(Icons.error),
    );
  }
}
