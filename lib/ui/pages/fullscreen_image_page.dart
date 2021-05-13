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
      body: Hero(
        tag: widget.url,
        transitionOnUserGestures: true,
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
    );
  }
}
