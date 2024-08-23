import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/displaymethods/display_methods.dart';
import '../../utils/app_colors.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({super.key, required this.myIcon});

  final Widget myIcon;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      width: 40 * variablePixelWidth,
      height: 40 * variablePixelHeight,
      padding: EdgeInsets.all(8 * variablePixelWidth),
      decoration: ShapeDecoration(
        color: AppColors.lumiLight4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50 * variablePixelWidth),
        ),
      ),
      child: Center(
          child: SizedBox(
        height: 24 * variablePixelHeight,
        width: 24 * variablePixelWidth,
        child: myIcon,
      )),
    );
  }
}

class SVGContainer extends StatelessWidget {
  const SVGContainer({super.key, required this.myIcon});

  final Widget myIcon;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      width: 40 * variablePixelWidth,
      height: 40 * variablePixelHeight,
      padding: EdgeInsets.all(8 * variablePixelWidth),
      decoration: ShapeDecoration(
        color: AppColors.lumiLight4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50 * variablePixelWidth),
        ),
      ),
      child: Center(
          child: SizedBox(
        height: 24 * variablePixelHeight,
        width: 24 * variablePixelWidth,
        child: SvgPicture.asset('/'),
      )),
    );
  }
}
