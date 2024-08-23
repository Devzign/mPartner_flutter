import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

class CustomTickIcon extends StatelessWidget {
  final double size;

  const CustomTickIcon({
    Key? key,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.greenTick,
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: AppColors.white,
          size: size * 0.6 * pixelMultiplier,
        ),
      ),
    );
  }
}
