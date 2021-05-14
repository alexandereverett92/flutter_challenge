import 'package:flutter/cupertino.dart';
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
      transitionOnUserGestures: true,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        final Widget hero = flightDirection == HeroFlightDirection.pop
            ? fromHeroContext.widget
            : toHeroContext.widget;
        return hero;
      },
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
