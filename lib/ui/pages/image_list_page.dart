import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gelato_flutter_challenge/blocs/images/images_bloc.dart';
import 'package:gelato_flutter_challenge/models/picsum_image_data.dart';
import 'package:gelato_flutter_challenge/ui/components/grid_image_display.dart';
import 'package:gelato_flutter_challenge/ui/components/sized_loading_indicator.dart';

class ImageListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    loadMoreImages();
    scrollController.addListener(maybeLoadMoreImages);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void maybeLoadMoreImages() {
    if (shouldLoadImages(scrollController)) {
      loadMoreImages();
    }
  }

  void loadMoreImages() {
    context.read<ImagesBloc>().add(const ImagesNext());
  }

  /// Gives [true] when the following conditions are met:
  /// - [status] is success
  /// - [scrollController] has been attached to the view
  /// - The current scrolling position is less than twice
  /// the visible scroll area from the end.
  bool shouldLoadImages(ScrollController scrollController) {
    final ImagesBloc _imagesBloc = context.read<ImagesBloc>();

    if (_imagesBloc.state.status != ImagesStatus.Success) return false;

    if (!scrollController.hasClients) return false;

    if (scrollController.position.maxScrollExtent == null) return true;

    return scrollController.offset >
        scrollController.position.maxScrollExtent -
            scrollController.position.viewportDimension * 2;
  }

  /// Get an appropriate number of images to show in each row.
  /// Each image displayed is half the cached image size.
  /// Based displaying 3 images in a row for an iPhone12 pro max
  int getAxisCountForScreenWidth(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return (width / scaleDownWidth).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImagesBloc, ImagesState>(
      listener: (_, __) => maybeLoadMoreImages(),
      child: BlocBuilder<ImagesBloc, ImagesState>(
        builder: (BuildContext context, ImagesState state) {
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: getAxisCountForScreenWidth(context),
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
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: SizedLoadingIndicator(),
                              ),
                            ],
                          ),
                        if (state.status == ImagesStatus.Error)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextButton(
                              onPressed: loadMoreImages,
                              child: Text(
                                state.errorText +
                                    ' Please tap here to try again.',
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
        },
      ),
    );
  }
}
