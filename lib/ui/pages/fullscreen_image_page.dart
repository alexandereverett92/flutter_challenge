import 'dart:async';

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
  bool showHighResImage = false;

  @override
  void initState() {
    setShowHighResImage();
    super.initState();
  }

  /// Set the image high res version of the image to display after the transition completes.
  /// Prevents image being shown twice during the transition
  void setShowHighResImage() {
    Timer(const Duration(milliseconds: 300), () {
      if (mounted)
        setState(() {
          showHighResImage = true;
        });
    });
  }

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

  double getPositionTop(Offset offset, PicsumImageData imageData,
      BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      final double imageHeight =
          imageData.getHeightForWidthDisplay(constraints.maxWidth.toInt());

      if (offset == null) return (constraints.maxHeight - imageHeight) / 2;

      return offset.dy - (imageHeight / 2);
    } else {
      if (offset == null) return 0;
      final double imageHeight = constraints.maxHeight;

      return offset.dy - (imageHeight / 2);
    }
  }

  double getPositionLeft(Offset offset, PicsumImageData imageData,
      BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      if (offset == null) return 0;
      final double imageWidth =
          constraints.maxWidth - imageDisplayHorizontalPadding * 2;

      return offset.dx - (imageWidth / 2);
    } else {
      final double imageWidth =
          imageData.getWidthForHeightDisplay(constraints.maxHeight.toInt());

      if (offset == null) return (constraints.maxWidth - imageWidth) / 2;

      return offset.dy - (imageWidth / 2);
    }
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
            child: SafeArea(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Center(
                  child: Stack(
                    children: <Widget>[
                      AnimatedPositioned(
                        duration: Duration(
                          milliseconds: animationDuration.inMilliseconds ~/ 2,
                        ),
                        top: getPositionTop(
                          currentDragPosition,
                          widget.imageData,
                          constraints,
                          MediaQuery.of(context).orientation,
                        ),
                        left: getPositionLeft(
                          currentDragPosition,
                          widget.imageData,
                          constraints,
                          MediaQuery.of(context).orientation,
                        ),
                        child: Center(
                          child: Draggable<Widget>(
                            affinity: Axis.vertical,
                            maxSimultaneousDrags: 1,
                            onDragUpdate: onDragUpdate,
                            onDragEnd: onDragEnd,
                            childWhenDragging: Container(),
                            feedback: _FullscreenImageDisplay(
                              showHighRes: showHighResImage,
                              imageData: widget.imageData,
                              imageProvider: widget.imageProvider,
                              constraints: constraints,
                              status: FullscreenImageStatus.Dragged,
                            ),
                            child: _FullscreenImageDisplay(
                              showHighRes: showHighResImage,
                              imageData: widget.imageData,
                              imageProvider: widget.imageProvider,
                              constraints: constraints,
                              status: status,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
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
    this.showHighRes = false,
  });
  final PicsumImageData imageData;
  final ImageProvider imageProvider;
  final BoxConstraints constraints;
  final FullscreenImageStatus status;
  final bool showHighRes;

  double getImagePaddingForStatus(FullscreenImageStatus status) {
    return status == FullscreenImageStatus.Display
        ? 0
        : imageDragHorizontalPadding;
  }

  BoxConstraints getBoxConstraintsForOrientation(Orientation orientation,
      BoxConstraints constraints, PicsumImageData imageData) {
    switch (orientation) {
      case Orientation.portrait:
        return constraints.copyWith(
          maxHeight: imageData.getHeightForWidthDisplay(
            constraints.maxWidth.toInt(),
          ),
        );
      case Orientation.landscape:
        return constraints.copyWith(
          maxWidth: imageData.getWidthForHeightDisplay(
            constraints.maxHeight.toInt(),
          ),
        );
      default:
        return constraints;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return ConstrainedBox(
        constraints: getBoxConstraintsForOrientation(
          MediaQuery.of(context).orientation,
          constraints,
          imageData,
        ),
        child: AnimatedPadding(
          duration: animationDuration,
          padding: EdgeInsets.symmetric(
            horizontal: getImagePaddingForStatus(status),
          ),
          child: Stack(
            children: [
              ImageHero(
                imageProvider: imageProvider,
                url: imageData.downloadUrl,
              ),
              AnimatedOpacity(
                opacity: showHighRes ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageData.downloadUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
