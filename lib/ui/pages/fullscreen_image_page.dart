import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gelato_flutter_challenge/models/picsum_image_data.dart';
import 'package:gelato_flutter_challenge/ui/components/image_hero.dart';

enum FullscreenImageStatus { Display, Dragged, DragPop, Closing }

const int dragPopDistance = 75;
const Duration animationDuration = Duration(milliseconds: 150);
const double imageDisplayHorizontalPadding = 4;
const double imageDragHorizontalPadding = 24;

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

  /// Gives an opacity value for use when fading out the page on image drag.
  /// Gives 1.0 when image is dragged less than half the [dragPopDistance].
  /// From the [dragPopDistance] onwards the value reduces gradually to 0.0.
  double getOpacityForDistanceDragged(double distance) {
    const int fadeStartDistance = dragPopDistance ~/ 2;

    if (distance == null || distance.abs() < fadeStartDistance) return 1.0;

    double opacity = 1.0 - ((distance.abs() - fadeStartDistance) / 100);

    if (opacity > 1) opacity = 1;

    return opacity >= 0 ? opacity : 0.0;
  }

  /// Gives the position of the image from the top of it's container.
  /// Positions based upon the [imageHeight] to place in the center of the
  /// [containerHeight].
  double getPositionTop(
      Offset offset, double imageHeight, double containerHeight) {
    if (offset == null) return (containerHeight - imageHeight) / 2;

    return offset.dy - (imageHeight / 2);
  }

  /// Converts the [offset] to the position of the image from the left of it's
  /// container.
  double getPositionLeft(Offset offset, double imageWidth) {
    if (offset == null) return 0;

    return offset.dx - (imageWidth / 2);
  }

  /// Stores the position of the image being dragged.
  /// Updates the [status] to either [Dragged] or [DragPop]. See [shouldDragPop()]
  void onDragUpdate(DragUpdateDetails drag) {
    if (!mounted) return;

    setState(() {
      dragStartPosition ??= drag.globalPosition;

      currentDragPosition = drag.globalPosition;

      currentDragDistance = dragStartPosition.dy - currentDragPosition.dy;

      if (shouldDragPop(currentDragDistance)) {
        status = FullscreenImageStatus.DragPop;
      } else {
        status = FullscreenImageStatus.Dragged;
      }
    });
  }

  /// Determines which drag status should be used from the [distance] the image
  /// is dragged. Where distance has exceeded the [dragPopDistance] returns true.
  bool shouldDragPop(double distance) {
    return distance > dragPopDistance || distance < -dragPopDistance;
  }

  void onDragEnd(DraggableDetails details) {
    if (!mounted) return;

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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: animationDuration,
      opacity: getOpacityForDistanceDragged(
        currentDragDistance,
      ),
      child: Scaffold(
        appBar: AppBar(),
        body: InteractiveViewer(
          child: AnimatedContainer(
            duration: animationDuration,
            padding: EdgeInsets.all(
              status == FullscreenImageStatus.Display
                  ? imageDisplayHorizontalPadding
                  : imageDragHorizontalPadding,
            ),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: Duration(
                        milliseconds: animationDuration.inMilliseconds ~/ 2),
                    top: getPositionTop(
                      currentDragPosition,
                      widget.imageData.getHeightForWidthDisplay(
                        constraints.maxWidth.toInt(),
                      ),
                      constraints.maxHeight,
                    ),
                    left: getPositionLeft(
                      currentDragPosition,
                      constraints.maxWidth - imageDisplayHorizontalPadding * 2,
                    ),
                    child: Center(
                      child: Draggable<Widget>(
                        affinity: Axis.vertical,
                        maxSimultaneousDrags: 1,
                        onDragUpdate: onDragUpdate,
                        onDragEnd: onDragEnd,
                        childWhenDragging: Container(),
                        feedback: _FullscreenImageDisplay(
                          imageData: widget.imageData,
                          imageProvider: widget.imageProvider,
                          constraints: constraints,
                          status: FullscreenImageStatus.Dragged,
                        ),
                        child: _FullscreenImageDisplay(
                          imageData: widget.imageData,
                          imageProvider: widget.imageProvider,
                          constraints: constraints,
                          status: status,
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

/// Displays the image sized to the [constraints] provided.
/// Applies [imageDragHorizontalPadding] when the [status] is [FullscreenImageStatus.Dragged]
class _FullscreenImageDisplay extends StatelessWidget {
  const _FullscreenImageDisplay({
    this.imageData,
    this.imageProvider,
    this.constraints,
    this.status,
  });
  final PicsumImageData imageData;
  final ImageProvider imageProvider;
  final BoxConstraints constraints;
  final FullscreenImageStatus status;

  double getImagePaddingForStatus(FullscreenImageStatus status) {
    return status == FullscreenImageStatus.Display
        ? 0
        : imageDragHorizontalPadding;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints.copyWith(
        maxHeight: imageData.getHeightForWidthDisplay(
          constraints.maxWidth.toInt(),
        ),
      ),
      child: AnimatedPadding(
        duration: animationDuration,
        padding: EdgeInsets.symmetric(
          horizontal: getImagePaddingForStatus(status),
        ),
        child: ImageHero(
          imageProvider: imageProvider,
          url: imageData.downloadUrl,
        ),
      ),
    );
  }
}
