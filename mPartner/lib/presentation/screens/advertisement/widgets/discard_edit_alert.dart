import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

void showDiscardEditsAlert(BuildContext context, double variablePixelHeight,
    double variablePixelWidth, double pixelMultiplier, double textMultiplier) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                8 * variablePixelWidth,
                8 * variablePixelHeight,
                8 * variablePixelWidth,
                8 * variablePixelHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Container(
                      height: 5 * variablePixelHeight,
                      width: 50 * variablePixelWidth,
                      decoration: BoxDecoration(
                        color: AppColors.dividerGreyColor,
                        borderRadius:
                            BorderRadius.circular(12 * pixelMultiplier),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.black,
                  ),
                ),
                const VerticalSpace(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 16.0 * variablePixelWidth),
                  child: Text(
                    translation(context).discardEdits,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 20 * pixelMultiplier,
                      fontWeight: FontWeight.w600,
                      height: 0.06 * textMultiplier,
                      letterSpacing: 0.50 * variablePixelWidth,
                    ),
                  ),
                ),
                const VerticalSpace(height: 16),
                Padding(
                  padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                  child: const CustomDivider(color: AppColors.dividerColor),
                ),
                const VerticalSpace(height: 16),
                Padding(
                  padding: EdgeInsets.only(
                      right: 24 * variablePixelWidth,
                      left: 16 * variablePixelWidth),
                  child: Container(
                    width: 345 * variablePixelWidth,
                    height: 40 * variablePixelHeight,
                    child: Text(
                      translation(context).closeAndLoseEdits,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 14 * textMultiplier,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: 0.10 * variablePixelWidth,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: 24 * variablePixelWidth,
                      left: 16 * variablePixelWidth),
                  child: Container(
                    width: 345 * variablePixelWidth,
                    height: 40 * variablePixelHeight,
                    child: Text(
                      translation(context).sureToContinue,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 16 * textMultiplier,
                        fontWeight: FontWeight.w500,
                        height: 20 / 16,
                        letterSpacing: 0.10 * variablePixelWidth,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: CommonButton(
                        onPressed: ()=>
                          Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.createAdvertisement)),
                        isEnabled: true,
                        buttonText: translation(context).discard,
                        leftPadding: 24 * variablePixelWidth,
                        rightPadding: 8 * variablePixelWidth,
                        textColor: AppColors.lumiBluePrimary,
                        backGroundColor: Colors.white,
                        containerBackgroundColor: AppColors.white,
                        defaultButton: false,
                      ),
                    ),
                    Expanded(
                      child: CommonButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        isEnabled: true,
                        buttonText: translation(context).keepEditing,
                        leftPadding: 8 * variablePixelWidth,
                        rightPadding: 24 * variablePixelWidth,
                        textColor: AppColors.white,
                        backGroundColor: AppColors.lumiBluePrimary,
                        containerBackgroundColor: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}