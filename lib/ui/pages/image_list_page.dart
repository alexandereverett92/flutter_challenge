import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gelato_flutter_challenge/blocs/images/images_bloc.dart';
import 'package:gelato_flutter_challenge/ui/components/image_display.dart';

import '../../blocs/images/images_bloc.dart';
import '../components/image_display.dart';

class ImageListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    final ImagesBloc _imagesBloc = context.read<ImagesBloc>();

    if (_imagesBloc.state.status != ImagesStatus.Success) return;

    if (scrollController.offset >
        scrollController.position.maxScrollExtent -
            scrollController.position.viewportDimension * 0.25) {
      _imagesBloc.add(const ImagesNext());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagesBloc, ImagesState>(
      builder: (BuildContext context, ImagesState state) {
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: const Text('Challenge'),
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    cacheExtent: MediaQuery.of(context).size.longestSide * 1.5,
                    itemCount: state.images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return ImageDisplay(
                        url: state.images[index].downloadUrl,
                      );
                    },
                  ),
                  if (state.status == ImagesStatus.Loading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                              width: 24,
                              height: 24,
                            ),
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  if (state.status == ImagesStatus.Error)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(state.errorText),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
