import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String buttonText;
  Color backGroundColor;
  Color textColor;
  bool defaultButton;
  Color containerBackgroundColor;
  double containerHeight;
  ContinueButton({
    super.key,
    required this.onPressed,
    required this.isEnabled,
    required this.buttonText,
    this.backGroundColor = AppColors.lumiBluePrimary,
    this.textColor = AppColors.lightWhite,
    this.defaultButton = true,
    this.containerHeight = 48,
    this.containerBackgroundColor = AppColors.lightWhite,
  });

  @override
  Widget build(BuildContext context) {
    var variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    var variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      color: containerBackgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            24 * variablePixelWidth,
            5 * variablePixelHeight,
            24 * variablePixelWidth,
            16 * variablePixelHeight),
        child: Container(
            height: containerHeight,
            decoration: BoxDecoration(
              border: defaultButton
                  ? null
                  : Border.all(
                      color: AppColors.black,
                      width: 1.5,
                    ),
              borderRadius: BorderRadius.circular(8.0 * variablePixelWidth),
            ),
            child: ElevatedButton(
              onPressed: isEnabled ? () => onPressed!() : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30.0 * variablePixelWidth),
                ),
                backgroundColor: backGroundColor,
                disabledBackgroundColor: AppColors.lightWhite2,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                maxLines: 1,
                buttonText,
                // softWrap: true,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.0 * variablePixelHeight,
                  letterSpacing: 0.10,
                  height: 0.10,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            )),
      ),
    );
  }
}
