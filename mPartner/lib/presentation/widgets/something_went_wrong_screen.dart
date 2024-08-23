import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/displaymethods/display_methods.dart';
import '../../utils/routes/app_routes.dart';
import 'something_went_wrong_widget.dart';

class SomethingWentWrongScreen extends StatelessWidget {
  const SomethingWentWrongScreen({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, AppRoutes.ismartHomepage);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Padding(
            padding: EdgeInsets.only(
                top: 24 * variablePixelHeight,
                left: 24 * variablePixelWidth,
                right: 24 * variablePixelWidth),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24 * variablePixelHeight,
                    width: 24 * variablePixelWidth,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_outlined,
                          color: AppColors.iconColor,
                        ),
                        onPressed: onPressed),
                  ),
                  const SomethingWentWrongWidget()
                ]),
          ),
        ),
      ),
    );
  }
}
