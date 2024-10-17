import 'package:flutter/material.dart';

typedef GridRenderChild<T> = Widget Function(T value, int index);

class Grid<T> extends StatelessWidget {
  List<T> data;
  GridRenderChild<T> renderChild;
  double horizontalGap = 0;
  double verticalGap = 0;
  int columns = 1;

  Grid(
    this.data,
    this.renderChild, {
    super.key,
    this.horizontalGap = 0,
    this.verticalGap = 0,
    this.columns = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double itemWidth = (constraints.maxWidth - 10) / this.columns; // Half
      return Wrap(
          spacing: this.horizontalGap,
          runSpacing: this.verticalGap,
          children: List.generate(data.length, (index) {
            var item = data[index];
            return SizedBox(
              width: itemWidth,
              child: renderChild(item, index),
            );
          }));
    });
  }
}
