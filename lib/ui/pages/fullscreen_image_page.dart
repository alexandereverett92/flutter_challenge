import 'package:flutter/material.dart';

class FullscreenImagePage extends StatefulWidget {
  const FullscreenImagePage({@required this.imageProvider});
  final ImageProvider imageProvider;

  @override
  State<StatefulWidget> createState() => _FullscreenImagePageState();
}

class _FullscreenImagePageState extends State<FullscreenImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
