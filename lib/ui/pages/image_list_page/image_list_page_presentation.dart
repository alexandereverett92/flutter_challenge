import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelato_flutter_challenge/blocs/images/images_bloc.dart';
import 'package:gelato_flutter_challenge/ui/components/grid_image_display.dart';
import 'package:gelato_flutter_challenge/ui/components/sized_loading_indicator.dart';

import '../../../test_keys.dart';

class ImageListPagePresentation extends StatelessWidget {
  const ImageListPagePresentation({
    @required this.state,
    @required this.scrollController,
    @required this.crossAxisCount,
    @required this.loadImages,
  });
  final ImagesState state;
  final ScrollController scrollController;
  final int crossAxisCount;
  final VoidCallback loadImages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge'),
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return SingleChildScrollView(
            controller: scrollController,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  GridView.builder(
                    cacheExtent: 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GridImageDisplay(
                        imageData: state.images[index],
                      );
                    },
                  ),
                  if (state.status == ImagesStatus.Loading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: SizedLoadingIndicator(key: loadingSpinnerKey),
                        ),
                      ],
                    ),
                  if (state.status == ImagesStatus.Error)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: loadImages,
                        child: Text(
                          state.errorText + ' Please tap here to try again.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
