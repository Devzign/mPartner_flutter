import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';
import '../../utils/displaymethods/display_methods.dart';

class CommonWhiteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String buttonText;
  Color backGroundColor;
  Color textColor;
  bool defaultButton;
  Color containerBackgroundColor;
  bool withContainer;
  double? leftPadding;
  double? rightPadding;
  final bool showLoader;
  double containerHeight, bottomPadding, horizontalPadding, topPadding;
  bool isGreyColor;

  CommonWhiteButton({
    super.key,
    required this.onPressed,
    required this.isEnabled,
    required this.buttonText,
    this.backGroundColor = AppColors.lumiBluePrimary,
    this.textColor = AppColors.lightWhite,
    this.defaultButton = true,
    this.containerHeight = 56,
    this.bottomPadding = 16,
    this.horizontalPadding = 24,
    this.rightPadding,
    this.leftPadding,
    this.topPadding = 5,
    this.containerBackgroundColor = AppColors.lightWhite,
    this.withContainer = true,
    this.showLoader = false,
    this.isGreyColor = false,
  });

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Container(
        height: containerHeight,
        decoration: BoxDecoration(
          border: isGreyColor
              ? Border.all(
                  color: AppColors.lumiBluePrimary, // Border color
                  width: 1.5, // Border width
                )
              : Border.all(
                  color: AppColors.hintColor, // Border color
                  width: 1.5, // Border width
                ),
          borderRadius: BorderRadius.circular(30.0 * r),
        ),
        child: ElevatedButton(
          onPressed: isEnabled && !showLoader ? () => onPressed!() : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0 * r),
            ),
            backgroundColor: backGroundColor,
            disabledBackgroundColor: AppColors.white,
            minimumSize: Size(double.infinity, 50 * h),
          ),
          child: showLoader
              ? const CircularProgressIndicator(color: AppColors.lightWhite)
              : Text(
                  maxLines: 1,
                  buttonText,
                  // softWrap: true,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15.0 * f,
                    fontWeight: FontWeight.normal,
                    color: isGreyColor
                        ? AppColors.lumiBluePrimary
                        : AppColors.hintColor,
                  ),
                ),
        ));
  }
}
