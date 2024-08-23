import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

void showConfirmationAlertBottomSheet(BuildContext context, String title, String body,  String confirmationText, VoidCallback onYesPressed){

  double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
  double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
  double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape:  RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const VerticalSpace(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Container(
                    height: 5 * variablePixelHeight,
                    width: 50 * variablePixelWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12 * pixelMultiplier),
                    ),
                  ),
                ),
              ),
              const VerticalSpace(height: 16),
              Container(
                margin: EdgeInsets.only(left: 10.0 * variablePixelWidth, right: 24 * variablePixelWidth),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 28 * pixelMultiplier,
                  ),
                ),
              ),
              const VerticalSpace(height: 12),
              Container(
                margin: EdgeInsets.only(left: 24.0 * variablePixelWidth, right: 24 * variablePixelWidth),
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.titleColor,
                    fontSize: 20 * textFontMultiplier,
                    fontWeight: FontWeight.w600,
                    height: 0.06 * variablePixelHeight,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
              const VerticalSpace(height: 16),
              Container(
                padding: EdgeInsets.only(right: 24 * variablePixelWidth, left: 24 * variablePixelWidth),
                child: const CustomDivider(color: AppColors.dividerColor),
              ),
              const VerticalSpace(height: 24),
              Padding(
                padding: EdgeInsets.only(right: 24 * variablePixelWidth, left: 24 * variablePixelWidth),
                child: Text(
                  body,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 14 * textFontMultiplier,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.10,
                  ),
                ),
              ),
              const VerticalSpace(height: 8),
              Padding(
                padding:  EdgeInsets.only(right: 24 * variablePixelWidth, left: 24 * variablePixelWidth),
                child: Text(
                  confirmationText,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 16 * textFontMultiplier,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10,
                  ),
                ),
              ),
              const VerticalSpace(height: 24),
              Padding(
                padding:  EdgeInsets.only(right: 24 * variablePixelWidth, left: 24 * variablePixelWidth),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 165 * variablePixelWidth,
                        height: 48 * variablePixelHeight,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(AppColors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100 * pixelMultiplier),
                                side: const BorderSide(color: AppColors.lumiBluePrimary),
                              ),
                            ),
                          ),
                          child: Text(translation(context).no,
                            style: GoogleFonts.poppins(
                              color: AppColors.lumiBluePrimary,
                              fontSize: 14 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              height: 0.10 * variablePixelHeight,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const HorizontalSpace(width: 16),
                    Expanded(
                      child: Container(
                        width: 165 * variablePixelWidth,
                        height: 48 * variablePixelHeight,
                        child: ElevatedButton(
                          onPressed: onYesPressed,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(AppColors.lumiBluePrimary),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100 * pixelMultiplier),
                              ),
                            ),
                          ),
                          child: Text(translation(context).yes,
                            style: GoogleFonts.poppins(
                              color: AppColors.lightWhite1,
                              fontSize: 14 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              height: 0.10 * variablePixelHeight,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalSpace(height: 32),
            ],
          ),
        ],
      ),
    ),
  );
}