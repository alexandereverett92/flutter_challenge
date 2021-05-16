import 'package:flutter/material.dart';
import 'package:gelato_flutter_challenge/models/picsum_image_data.dart';
import 'package:gelato_flutter_challenge/ui/components/image_hero.dart';

enum FullscreenImageStatus { Display, Dragged, DragPop, Closing }

const int dragPopDistance = 75;

class FullscreenImagePage extends StatefulWidget {
  const FullscreenImagePage({
    @required this.imageProvider,
    @required this.imageData,
  });
  final ImageProvider imageProvider;
  final PicsumImageData imageData;

  @override
  State<StatefulWidget> createState() => _FullscreenImagePageState();
}

class _FullscreenImagePageState extends State<FullscreenImagePage> {
  FullscreenImageStatus status = FullscreenImageStatus.Display;

  Offset dragStartPosition;
  Offset currentDragPosition;
  double currentDragDistance;

  double getOpacityForDistanceDragged(double distance, double imageHeight) {
    const int fadeStartDistance = dragPopDistance ~/ 2;

    if (distance == null || distance.abs() < fadeStartDistance) return 1.0;

    double opacity = 1.0 - ((distance.abs() - fadeStartDistance) / 100);

    if (opacity > 1) opacity = 1;

    return opacity >= 0 ? opacity : 0.0;
  }

  double getImagePaddingForStatus(FullscreenImageStatus status) {
    return status == FullscreenImageStatus.Display ? 0 : 24;
  }

  double getPositionTop(Offset offset, double height, double containerHeight) {
    if (offset == null) return (containerHeight - height) / 2;

    return offset.dy - (height / 2);
  }

  double getPositionLeft(Offset offset, double width) {
    if (offset == null) return 0;

    return offset.dx - (width / 2);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: getOpacityForDistanceDragged(
        currentDragDistance,
        widget.imageData.getHeightForWidthDisplay(
          MediaQuery.of(context).size.width.toInt(),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(),
        body: InteractiveViewer(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.all(
                status == FullscreenImageStatus.Display ? 4 : 28),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 75),
                    top: getPositionTop(
                      currentDragPosition,
                      widget.imageData.getHeightForWidthDisplay(
                        constraints.maxWidth.toInt(),
                      ),
                      constraints.maxHeight,
                    ),
                    left: getPositionLeft(
                        currentDragPosition, constraints.maxWidth - 8),
                    child: Center(
                      child: Draggable(
                        affinity: Axis.vertical,
                        maxSimultaneousDrags: 1,
                        onDragUpdate: (DragUpdateDetails drag) {
                          if (mounted)
                            setState(() {
                              dragStartPosition ??= drag.globalPosition;

                              currentDragPosition = drag.globalPosition;
                            });

                          currentDragDistance =
                              dragStartPosition.dy - currentDragPosition.dy;

                          if (currentDragDistance > dragPopDistance ||
                              currentDragDistance < -dragPopDistance) {
                            status = FullscreenImageStatus.DragPop;
                          } else {
                            status = FullscreenImageStatus.Dragged;
                          }
                        },
                        onDragEnd: (_) {
                          if (status == FullscreenImageStatus.DragPop) {
                            setState(() {
                              status = FullscreenImageStatus.Closing;
                            });
                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              currentDragPosition = null;
                              currentDragDistance = null;
                              dragStartPosition = null;

                              status = FullscreenImageStatus.Display;
                            });
                          }
                        },
                        childWhenDragging: Container(),
                        feedback: ConstrainedBox(
                          constraints: constraints.copyWith(
                            maxHeight:
                                widget.imageData.getHeightForWidthDisplay(
                              constraints.maxWidth.toInt(),
                            ),
                          ),
                          child: AnimatedPadding(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            child: ImageHero(
                              imageProvider: widget.imageProvider,
                              url: widget.imageData.downloadUrl,
                            ),
                          ),
                        ),
                        child: ConstrainedBox(
                          constraints: constraints.copyWith(
                            maxHeight:
                                widget.imageData.getHeightForWidthDisplay(
                              constraints.maxWidth.toInt(),
                            ),
                          ),
                          child: AnimatedPadding(
                            duration: const Duration(milliseconds: 150),
                            padding: EdgeInsets.symmetric(
                                horizontal: getImagePaddingForStatus(status)),
                            child: ImageHero(
                              imageProvider: widget.imageProvider,
                              url: widget.imageData.downloadUrl,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
