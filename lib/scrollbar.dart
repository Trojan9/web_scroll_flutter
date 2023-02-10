import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum ThumbAnimation {
  IN,
  OUT,
}

class ScrollBar extends StatefulWidget {
  final ScrollController controller;
  final Widget child;
  final double visibleHeight;
  final int? animationLength;
  final Color? scrollThumbColor;
  final Color? scrollbarColor;
  final double? scrollbarMinWidth;
  final double? scrollbarMaxWidth;

  ScrollBar({
    required this.controller,
    required this.child,
    required this.visibleHeight,
    this.scrollbarMinWidth,
    this.scrollbarMaxWidth,
    this.animationLength,
    this.scrollThumbColor,
    this.scrollbarColor,
  });

  @override
  _ScrollBarState createState() => _ScrollBarState();
}

class _ScrollBarState extends State<ScrollBar> {
  double offsetTop = 0;
  double? ratio;
  double? thumbHeight;
  double? fullHeight;
  ThumbAnimation thumbAnimation = ThumbAnimation.IN;

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (fullHeight == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          fullHeight = widget.controller.position.maxScrollExtent +
              widget.controller.position.viewportDimension;
        });
      });
      return widget.child;
    }

    final remainder = (fullHeight! - widget.visibleHeight);

    if (remainder < 0) {
      return widget.child;
    }

    ratio = fullHeight! / widget.visibleHeight;
    thumbHeight = (1 / ratio!) * widget.visibleHeight;

    return _getAnimatedScrollbar();
  }

  Widget _getAnimatedScrollbar() {
    Tween<double> tween;

    if (thumbAnimation == ThumbAnimation.OUT) {
      tween = Tween<double>(
          begin: widget.scrollbarMinWidth, end: widget.scrollbarMaxWidth);
    } else {
      tween = Tween<double>(
          begin: widget.scrollbarMaxWidth, end: widget.scrollbarMinWidth);
    }

    return TweenAnimationBuilder<double>(
      tween: tween,
      duration: Duration(milliseconds: widget.animationLength!),
      curve: Curves.bounceIn,
      builder: (BuildContext cont, double width, Widget? w) {
        return Stack(
          fit: StackFit.loose,
          alignment: Alignment.topRight,
          children: [
            widget.child,
            _getMouseRegion(_getScrollbarBackground(width)),
            _getScrollThumb(width),
          ],
        );
      },
    );
  }

  Widget _getMouseRegion(Widget child) {
    return MouseRegion(
      onEnter: (s) {
        setState(() {
          thumbAnimation = ThumbAnimation.OUT;
        });
      },
      onExit: (s) {
        setState(() {
          thumbAnimation = ThumbAnimation.IN;
        });
      },
      child: child,
    );
  }

  Widget _getScrollbarBackground(double width) {
    return Container(
      width: width,
      height: widget.visibleHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: widget.scrollbarColor,
        border: Border.all(color: widget.scrollbarColor!, width: 1),
      ),
    );
  }

  Widget _getScrollThumb(double width) {
    return Positioned(
      top: fullHeight != null ? calculateTop() : 0,
      child: _getMouseRegion(
        GestureDetector(
          onVerticalDragDown: (s) {
            offsetTop = widget.controller.offset.toDouble() -
                (s.localPosition.dy * ratio!);
          },
          onVerticalDragUpdate: (dragDetails) {
            final newPosition =
                (dragDetails.localPosition.dy * ratio!) + offsetTop;
            widget.controller.jumpTo(newPosition);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: widget.scrollThumbColor,
              border: Border.all(color: widget.scrollThumbColor!, width: 1),
            ),
            width: width,
            height: thumbHeight,
          ),
        ),
      ),
    );
  }

  double calculateTop() {
    return (widget.visibleHeight / fullHeight!) *
        widget.controller.position.extentBefore;
  }
}
