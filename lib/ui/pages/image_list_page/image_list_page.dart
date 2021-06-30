import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gelato_flutter_challenge/blocs/images/images_bloc.dart';
import 'package:gelato_flutter_challenge/ui/pages/image_list_page/image_list_page_presentation.dart';
import 'package:gelato_flutter_challenge/ui/pages/image_list_page/image_list_page_service.dart';

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
    final ImagesBloc _imagesBloc = context.read<ImagesBloc>();

    if (ImageListPageService.shouldLoadImages(
        ScrollControllerData.fromScrollController(scrollController),
        _imagesBloc.state)) {
      loadMoreImages();
    }
  }

  void loadMoreImages() {
    context.read<ImagesBloc>().add(const ImagesNext());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImagesBloc, ImagesState>(
      listener: (_, __) => maybeLoadMoreImages(),
      child: BlocBuilder<ImagesBloc, ImagesState>(
        builder: (BuildContext context, ImagesState state) {
          return ImageListPagePresentation(
            state: state,
            scrollController: scrollController,
            crossAxisCount: ImageListPageService.getAxisCountForScreenWidth(
                MediaQuery.of(context).size.width),
            loadImages: loadMoreImages,
          );
        },
      ),
    );
  }
}
