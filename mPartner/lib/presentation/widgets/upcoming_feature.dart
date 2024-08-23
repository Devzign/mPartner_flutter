import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/displaymethods/display_methods.dart';
import 'coming_soon_widget.dart';

class UpcomingFeatureScreen extends StatelessWidget {
  final bool navigateHomeLogin;

  const UpcomingFeatureScreen({super.key, this.navigateHomeLogin = true});

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

    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24 * variablePixelWidth,
                70 * variablePixelHeight, 24 * variablePixelWidth, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    children: [
                      IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.arrow_back_outlined,
                            color: AppColors.iconColor,
                            // size: 24 * pixelMultiplier,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        width: 10 * variablePixelWidth,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30 * variablePixelHeight,
          ),
          ComingSoonWidget(navigateHomeLogin: navigateHomeLogin),
        ],
      ),
    );
  }
}
