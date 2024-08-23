import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';

class CustomAlertWidget extends StatelessWidget {
  final String description;
  final String promptQues;
  final bool isSingleButton;
  final void Function()? onPressedYes;
  final void Function()? onPressedNo;

  const CustomAlertWidget(
      {Key? key,
      required this.description,
      required this.promptQues,
      required this.onPressedYes,
      required this.onPressedNo,
      this.isSingleButton = false})
      : super(key: key);

  void _handleOnPressedYes() {
    onPressedYes?.call();
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double variableTextMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12 * variablePixelWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                description,
                style: GoogleFonts.poppins(
                  color: AppColors.iconColor,
                  fontSize: 14 * variableTextMultiplier,
                  fontWeight:
                      (isSingleButton ? FontWeight.w600 : FontWeight.w400),
                  letterSpacing: 0.25,
                ),
              ),
              SizedBox(
                height: isSingleButton
                    ? 12 * variablePixelHeight
                    : 4 * variablePixelHeight,
              ),
              Text(
                promptQues,
                softWrap: false,
                overflow: TextOverflow.visible,
                maxLines: isSingleButton ? 1 : 2,
                style: GoogleFonts.poppins(
                  color: AppColors.iconColor,
                  fontSize: (isSingleButton ? 12 : 16) * variableTextMultiplier,
                  fontWeight:
                      (isSingleButton ? FontWeight.w400 : FontWeight.w600),
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: isSingleButton
              ? 10 * variablePixelHeight
              : 6 * variablePixelHeight,
        ),
        Visibility(
            visible: !isSingleButton,
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 12 * variablePixelHeight,
                  horizontal: 10 * variablePixelWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    child: Text(
                      translation(context).no,
                      style: GoogleFonts.poppins(
                        color: AppColors.lumiBluePrimary,
                        fontSize: 16 * variableTextMultiplier,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 60 * variablePixelWidth,
                          vertical: 12 * variablePixelHeight),
                      backgroundColor: AppColors.lightWhite1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(color: AppColors.lumiBluePrimary),
                    ),
                    onPressed: onPressedNo,
                  ),
                  SizedBox(
                    width: 8 * variablePixelWidth,
                  ),
                  ElevatedButton(
                    child: Text(
                      translation(context).yes,
                      style: GoogleFonts.poppins(
                        color: AppColors.lightWhite1, // Text color
                        fontSize: 16 * variableTextMultiplier,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 60 * variablePixelWidth,
                          vertical: 12 * variablePixelHeight),
                      backgroundColor: AppColors.lumiBluePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _handleOnPressedYes,
                  )
                ],
              ),
            )),
        Visibility(
            visible: isSingleButton,
            child: ElevatedButton(
              child: Text(
                translation(context).scanNext,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: GoogleFonts.poppins(
                  color: AppColors.lightWhite1, // Text color
                  fontSize: 16 * variableTextMultiplier,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(
                    135 * variablePixelWidth,
                    10 * variablePixelHeight,
                    145 * variablePixelWidth,
                    10 * variablePixelHeight),
                backgroundColor: AppColors.lumiBluePrimary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30 * variablePixelMultiplier),
                ),
              ),
              onPressed: _handleOnPressedYes,
            )),
        SizedBox(
          height: isSingleButton
              ? 16 * variablePixelHeight
              : 8 * variablePixelHeight,
        ),
      ],
    );
  }
}
