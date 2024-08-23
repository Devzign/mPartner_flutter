import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/displaymethods/display_methods.dart';
import 'rupee_with_sign_widget.dart';

class CashWidget extends StatelessWidget {
  const CashWidget({super.key, required this.cash});

  final int cash;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();

    return Container(
      // height: 20 * variablePixelHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(
        8 * variablePixelWidth,
        2 * variablePixelHeight,
        8 * variablePixelWidth,
        2 * variablePixelHeight,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0 * variablePixelWidth),
        color: AppColors.lumiLight4,
      ),
      child: RupeeWithSignWidget(
          cash: double.tryParse("$cash") ?? 0,
          color: AppColors.lumiBluePrimary,
          size: 12,
          weight: FontWeight.w500,
          width: 120),
    );
  }
}
