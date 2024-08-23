import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/routes/app_routes.dart';
import '../notification_bell_icon_widget.dart';

class ISmartHeaderWidget extends StatelessWidget {
  final String? title;

  const ISmartHeaderWidget({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultipler =
        DisplayMethods(context: context).getPixelMultiplier();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title ?? "",
          style: GoogleFonts.poppins(
            color: AppColors.darkText2,
            fontSize: 22 * textFontMultiplier,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              const NotificationBellIconWidget(),
              SizedBox(
                width: 16 * variablePixelWidth,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.helpAndSupport);
                },
                child: Container(
                  width: 40 * pixelMultipler,
                  height: 40 * pixelMultipler,
                  decoration: ShapeDecoration(
                      color: AppColors.white,
                      shape: OvalBorder(
                          side: BorderSide(
                              width: 1 * variablePixelWidth,
                              color: AppColors.lightGrey2))),
                  child: Center(
                    child: Icon(Icons.question_mark_outlined,
                        color: AppColors.headerIconColors,
                        size: 24 * pixelMultipler),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
