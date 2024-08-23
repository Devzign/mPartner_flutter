import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../utils/app_colors.dart';
import '../../utils/routes/app_routes.dart';

class NotificationBellIconWidget extends StatelessWidget {
  const NotificationBellIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.notificationHome);
      },
      child: Container(
        width: 40 * variablePixelMultiplier,
        height: 40 * variablePixelMultiplier,
        decoration: ShapeDecoration(
            color: AppColors.white,
            shape: OvalBorder(
                side: BorderSide(
                    width: 1 * variablePixelWidth,
                    color: AppColors.lightGrey2))),
        child: Center(
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.headerIconColors,
            size: 24 * variablePixelMultiplier,
          ),
        ),
      ),
    );
  }
}
