library web_scroll_flutter;

import 'package:flutter/material.dart';
import 'package:web_scroll_flutter/scrollbar.dart';
import 'package:web_scroll_flutter/smooth_scroll_web.dart';

const DEFAULT_MIN_WIDTH = 6.0;
const DEFAULT_MAX_WIDTH = 15.0;
const DEFAULT_ANIMATION_LENGTH_MS = 200;
const DEFAULT_SCROLL_THUMB_COLOR = const Color(0xCC9E9E9E);
const DEFAULT_SCROLLBAR_COLOR = const Color(0x77FFFFFF);

class WebScrollBar extends StatefulWidget {
  ///Same ScrollController as the child widget's.
  final ScrollController? controller;

  ///Child widget.
  final Widget? child;

  ///The height of the child widget.
  final double? visibleHeight;

  ///Lenght of the Thumb fade in out animations in milliseconds.
  final int animationLength;

  ///The color of the scroll thumb
  final Color scrollThumbColor;

  ///The background color of the scrollbar.
  final Color scrollbarColor;

  ///The width of the scrollbar, when it is 'hidden'
  final double scrollbarMinWidth;

  ///The width of the scrollbar, when it is 'showing'
  final double scrollbarMaxWidth;

  WebScrollBar({
    @required this.controller,
    @required this.child,
    @required this.visibleHeight,
    this.scrollbarMinWidth = DEFAULT_MIN_WIDTH,
    this.scrollbarMaxWidth = DEFAULT_MAX_WIDTH,
    this.animationLength = DEFAULT_ANIMATION_LENGTH_MS,
    this.scrollThumbColor = DEFAULT_SCROLL_THUMB_COLOR,
    this.scrollbarColor = DEFAULT_SCROLLBAR_COLOR,
  });

  @override
  _WebScrollBarState createState() => _WebScrollBarState();
}

class _WebScrollBarState extends State<WebScrollBar> {
  @override
  Widget build(BuildContext context) {
    return SmoothScrollWeb(
      controller: widget.controller,
      child: ScrollBar(
        controller: widget.controller,
        visibleHeight: MediaQuery.of(context).size.height,
        animationLength: widget.animationLength,
        scrollThumbColor: widget.scrollThumbColor,
        scrollbarColor: widget.scrollbarColor,
        scrollbarMaxWidth: widget.scrollbarMaxWidth,
        scrollbarMinWidth: widget.scrollbarMinWidth,
        child: widget.child,
      ),
    );
  }
}
