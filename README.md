# WebScrollBar

A simple package, that creates a scrollbar for Flutter Web

# Getting started
The package should only be used for Flutter Web and on the desktop version of the site, there are better suited mobile scrollbars, than this package.

You can use the package with any Scrollable widget, but you have to set its physics to NeverScrollableScrollPhysics(), because it is the only way to deactivate the default scrolling and we need complete control over the scrolling.

You can use it on dynamically sized widgets also, but it is a possibility to control the height of the scrollbar window. Both examples can be found in the Examples section

This package depends on my other package, which is the smooth_scroll_web package. The scrollbar would not work without it.

# Moving the scrollbar
![Movement](https://github.com/Trojan9/web_scroll_flutter/blob/master/scrollbar_moving.gif)
# Resizing the widget
![Resizing](https://github.com/Trojan9/web_scroll_flutter/blob/master/scrollbar_resize.gif)

# Examples
```dart
class ScrollbarExample extends StatelessWidget {
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    ///DYNAMIC SIZE EXAMPLE
    return Container(
      color: Colors.red,
      child: WebScrollBar(
        child: _getChild(),
        controller: controller,
        visibleHeight: MediaQuery.of(context).size.height,
      ),
    );

    ///FIXED HEIGHT EXAMPLE
    return Column(
      children: [
        Container(
          height: 500,
          color: Colors.red,
          child: SmoothScrollWeb(
            controller: controller,
            child: ScrollBar(
              child: _getChild(),
              controller: controller,
              visibleHeight: 500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getChild() {
    return Container(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        child: Column(
          children: [
            for (int i = 0; i < 200; i++)
              Container(
                height: 10,
                color: RandomColor.generate(),
              ),
          ],
        ),
      ),
    );
  }
}
