import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../horizontalspace/horizontal_space.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton(
      {super.key,
      required this.buttonText,
      required this.buttonHeight,
      required this.onPressed,
    required this.isEnabled,
    this.showIcon = false,
    this.icon = Icons.file_download_outlined,
  
    this.isLoading = false,
  });
  bool showIcon;
  IconData icon;
  String buttonText;
  double buttonHeight;
  VoidCallback onPressed;
  bool isEnabled, isLoading;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Expanded(
      child: ElevatedButton(
          onPressed: isEnabled ? () => onPressed() : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0 * r),
                side: BorderSide(
                    color: isEnabled
                        ? AppColors.lumiBluePrimary
                        : AppColors.lightWhite2)),
            backgroundColor: AppColors.lumiBluePrimary,
            disabledBackgroundColor: AppColors.lightWhite2,
            minimumSize:
                Size(double.infinity, (buttonHeight - 14) * h + 14 * f),
            surfaceTintColor: Colors.white,
          ),
          child: Visibility(
            visible: !isLoading,
            replacement: Center(
                child: CircularProgressIndicator(
              color: AppColors.lumiLight5,
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: showIcon,
                  child: Icon(
                    icon,
                    color: AppColors.white,
                  ),
                ),
                HorizontalSpace(width: showIcon ? 4 : 0),
                Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
