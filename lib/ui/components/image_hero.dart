import 'package:flutter/material.dart';

class ImageHero extends StatelessWidget {
  const ImageHero({
    this.imageProvider,
    this.url,
    this.boxFit = BoxFit.contain,
  });

  final ImageProvider imageProvider;
  final String url;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: url,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit,
          ),
        ),
      ),
    );
  }
}
