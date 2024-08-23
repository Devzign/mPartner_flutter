import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../horizontalspace/horizontal_space.dart';

class SecondaryButton extends StatelessWidget {
  SecondaryButton({
    super.key,
    required this.buttonText,
    required this.buttonHeight,
    required this.onPressed,
    required this.isEnabled,
    this.showIcon = false,
    this.icon = Icons.share_outlined,
  });
  bool showIcon;
  IconData icon;
  String buttonText;
  double buttonHeight;
  VoidCallback onPressed;
  bool isEnabled;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return Expanded(
      child: ElevatedButton(
          onPressed: isEnabled ? () => onPressed() : null,
          style: ElevatedButton.styleFrom(
            shadowColor: AppColors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0 * r),
                    side: BorderSide(
                        color: isEnabled
                            ? AppColors.lumiBluePrimary
                        : AppColors.grayText)),
            backgroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.lightWhite2,
            minimumSize:
                Size(double.infinity, (buttonHeight - 14) * h + 14 * f),
            surfaceTintColor: AppColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: showIcon,
                child: Icon(
                  icon,
                  color: AppColors.lumiBluePrimary,
                ),
              ),
              HorizontalSpace(width: showIcon ? 4 : 0),
              Text(
                buttonText,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: isEnabled
                      ? AppColors.lumiBluePrimary
                      : AppColors.white,
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10 * w,
                ),
              ),
            ],
          )),
    );
  }
}
