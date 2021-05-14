import 'package:flutter/material.dart';

class FullscreenImagePage extends StatefulWidget {
  const FullscreenImagePage({@required this.imageProvider, @required this.url});
  final ImageProvider imageProvider;
  final String url;

  @override
  State<StatefulWidget> createState() => _FullscreenImagePageState();
}

class _FullscreenImagePageState extends State<FullscreenImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InteractiveViewer(
        child: Hero(
          tag: widget.url,
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
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
