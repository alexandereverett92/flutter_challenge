import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gelato_flutter_challenge/blocs/images/images_bloc.dart';
import 'package:gelato_flutter_challenge/ui/components/image_display.dart';

import '../components/image_display.dart';

class ImageListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagesBloc, ImagesState>(
      builder: (BuildContext context, ImagesState state) {
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text('Challenge'),
          ),
          body: GridView.builder(
            itemCount: state.images.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              return ImageDisplay(
                url: state.images[index].downloadUrl,
              );
            },
          ),
        );
      },
    );
  }
}
