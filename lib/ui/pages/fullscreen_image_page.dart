import 'package:flutter/material.dart';
import 'package:gelato_flutter_challenge/ui/components/image_hero.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ImageHero(
            imageProvider: widget.imageProvider,
            url: widget.url,
          ),
        ),
      ),
    );
  }
}
