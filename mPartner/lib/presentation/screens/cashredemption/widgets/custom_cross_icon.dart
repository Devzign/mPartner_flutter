import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

class CustomCrossIcon extends StatelessWidget {
  const CustomCrossIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      width: 24 * pixelMultiplier,
      height: 24 * pixelMultiplier,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.errorRed,
      ),
      child: Center(
        child: Icon(
          Icons.close,
          color: AppColors.white,
          size: 24 * 0.7 * pixelMultiplier,
        ),
      ),
    );
  }
}
