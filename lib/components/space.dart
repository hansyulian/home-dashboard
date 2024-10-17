import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  double width;
  double height;

  Space({super.key, this.width = 8, this.height = 8});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
