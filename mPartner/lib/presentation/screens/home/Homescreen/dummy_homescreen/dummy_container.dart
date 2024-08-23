import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';

class DummyContainer extends StatelessWidget {
  double containerHeight, containerWidth;
  bool roundedBorder;
  DummyContainer(
      {super.key, required this.containerHeight, required this.containerWidth, required this.roundedBorder});

  @override
  Widget build(BuildContext context) {

    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: roundedBorder == false ? BoxDecoration(
        color: Colors.grey[300],
      ) : BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0 * pixelMultiplier),
      )
    );
  }
}
