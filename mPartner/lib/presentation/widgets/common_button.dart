import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';
import '../../utils/displaymethods/display_methods.dart';

class CommonButton extends StatelessWidget {
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
  FontWeight fontWeight;

  CommonButton(
      {super.key,
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
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return withContainer
        ? Container(
            color: containerBackgroundColor,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  leftPadding ??
                      horizontalPadding *
                          DisplayMethods(context: context)
                              .getVariablePixelWidth(),
                  topPadding *
                      DisplayMethods(context: context).getVariablePixelHeight(),
                  rightPadding ??
                      horizontalPadding *
                          DisplayMethods(context: context)
                              .getVariablePixelWidth(),
                  bottomPadding *
                      DisplayMethods(context: context)
                          .getVariablePixelHeight()),
              child: Container(
                  height: containerHeight,
                  decoration: BoxDecoration(
                    border: defaultButton
                        ? null
                        : Border.all(
                            color: AppColors.lumiBluePrimary, // Border color
                            width: 1.5, // Border width
                          ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: ElevatedButton(
                    onPressed:
                        isEnabled && !showLoader ? () => onPressed!() : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: backGroundColor,
                      disabledBackgroundColor: AppColors.lightWhite2,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: showLoader
                        ? const CircularProgressIndicator(
                            color: AppColors.lightWhite,
                          )
                        : Text(
                            maxLines: 1,
                            buttonText,
                            // softWrap: true,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 15.0 * DisplayMethods(context: context).getTextFontMultiplier(),
                              fontWeight: fontWeight,
                              color: textColor,
                            ),
                          ),
                  )),
            ),
          )
        : Container(
            height: containerHeight,
            decoration: BoxDecoration(
              border: defaultButton
                  ? null
                  : Border.all(
                      color: AppColors.lumiBluePrimary, // Border color
                      width: 1.5, // Border width
                    ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: ElevatedButton(
              onPressed: isEnabled && !showLoader ? () => onPressed!() : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: backGroundColor,
                disabledBackgroundColor: AppColors.lightWhite2,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: showLoader
                  ? const CircularProgressIndicator(color: AppColors.lightWhite)
                  : Text(
                      maxLines: 1,
                      buttonText,
                      // softWrap: true,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: fontWeight,
                        color: textColor,
                      ),
                    ),
            ));
  }
}

class CommonButtonWithBorder extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String buttonText;
  Color backGroundColor;
  Color textColor;
  bool defaultButton;
  Color containerBackgroundColor;
  bool withContainer;
  double? leftPadding; double? rightPadding;
  final bool showLoader;
  double containerHeight, bottomPadding, horizontalPadding, topPadding;
  CommonButtonWithBorder({
    super.key,
    required this.onPressed,
    required this.isEnabled,
    required this.buttonText,
    this.backGroundColor = AppColors.white,
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
  });

  @override
  Widget build(BuildContext context) {
    return withContainer
        ? Container(
      color: containerBackgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            leftPadding??horizontalPadding *
                DisplayMethods(context: context).getVariablePixelWidth(),
            topPadding *
                DisplayMethods(context: context).getVariablePixelHeight(),
            rightPadding??horizontalPadding *
                DisplayMethods(context: context).getVariablePixelWidth(),
            bottomPadding *
                DisplayMethods(context: context)
                    .getVariablePixelHeight()),
        child: Container(
            height: containerHeight,
            decoration: BoxDecoration(
              border:  Border.all(
                color: AppColors.lumiBluePrimary, // Border color
                width: 1.5, // Border width
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: ElevatedButton(
              onPressed: isEnabled && !showLoader ? () => onPressed!() : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),


                ),

                backgroundColor: Colors.white,
                disabledBackgroundColor: AppColors.lightWhite2,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: showLoader ?
              const CircularProgressIndicator(color: AppColors.lightWhite,)
                  : Text(
                maxLines: 1,
                buttonText,
                // softWrap: true,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                ),
              ),
            )),
      ),
    )
        : Container(
        height: containerHeight,
        decoration: BoxDecoration(
          border: defaultButton
              ? null
              : Border.all(
            color: AppColors.lumiBluePrimary, // Border color
            width: 1.5, // Border width
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: ElevatedButton(
          onPressed: isEnabled && !showLoader ? () => onPressed!() : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: backGroundColor,
            disabledBackgroundColor: AppColors.lightWhite2,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: showLoader ?
          const CircularProgressIndicator(color: AppColors.lightWhite)
              : Text(
            maxLines: 1,
            buttonText,
            // softWrap: true,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
        ));
  }
}