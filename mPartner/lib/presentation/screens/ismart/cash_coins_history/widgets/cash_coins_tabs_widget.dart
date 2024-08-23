import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class CashCoinTabs extends StatelessWidget {
  final String leftTabText;
  final String rightTabText;
  final bool isLeftTabSelected;
  final VoidCallback onLeftTabPressed;
  final VoidCallback onRightTabPressed;

  const CashCoinTabs({
    super.key,
    required this.leftTabText,
    required this.rightTabText,
    required this.isLeftTabSelected,
    required this.onLeftTabPressed,
    required this.onRightTabPressed,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.4,
      height: 32.0 * variablePixelHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0 * pixelMultiplier),
        border: Border.all(
          color: AppColors.lumiBluePrimary,
          width: 1.0 * variablePixelWidth,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onLeftTabPressed,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isLeftTabSelected
                      ? AppColors.lumiLight4
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0 * pixelMultiplier),
                    bottomLeft: Radius.circular(20.0 * pixelMultiplier),
                  ),
                ),
                child: Text(
                  leftTabText,
                  style: const TextStyle(
                    color: AppColors.lumiBluePrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          VerticalDivider(
            color: AppColors.lumiBluePrimary,
            width: 1.0 * variablePixelWidth,
          ),
          Expanded(
            child: GestureDetector(
              onTap: onRightTabPressed,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isLeftTabSelected
                      ? AppColors.lumiLight4
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0 * pixelMultiplier),
                    bottomRight: Radius.circular(20.0 * pixelMultiplier),
                  ),
                ),
                child: Text(
                  rightTabText,
                  style: const TextStyle(
                    color: AppColors.lumiBluePrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
