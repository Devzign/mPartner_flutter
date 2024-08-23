import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

void showAlertBottomSheet(BuildContext context, double variablePixelHeight,
    double variablePixelWidth, double textFontMultiplier, double pixelMultiplier,{FocusNode? amountFocusNode, String? maxAmountLimitMessage}){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
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
                    if(amountFocusNode!=null) FocusScope.of(context).requestFocus(amountFocusNode);
                  },
                  child: Center(
                    child: Container(
                      height: 5 * variablePixelHeight,
                      width: 50 * variablePixelWidth,
                      decoration: BoxDecoration(
                        color: AppColors.grayText,
                        borderRadius: BorderRadius.circular(12 * pixelMultiplier),
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
                  padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                  child: Text(
                    translation(context).alert,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 20 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      height: 0.06,
                      letterSpacing: 0.50,
                    ),
                  ),
                ),
                const VerticalSpace(height: 16),
                Padding(
                  padding: EdgeInsets.only(left: 16 * pixelMultiplier),
                  child: const CustomDivider(color: AppColors.dividerColor),
                ),
                const VerticalSpace(height: 16),
                Padding(
                  padding: EdgeInsets.only(
                      right: 24 * variablePixelWidth,
                      left: 16 * variablePixelWidth),
                  child: Container(
                    width: 345 * variablePixelWidth,
                    child: Text(
                      maxAmountLimitMessage ?? translation(context).transferAmountValidation,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGrey,
                        fontSize: 14 * textFontMultiplier,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 24),
                CommonButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if(amountFocusNode!=null) FocusScope.of(context).requestFocus(amountFocusNode);
                  },
                  isEnabled: true,
                  buttonText: translation(context).enterAgain,
                  containerBackgroundColor: AppColors.white,
                )
              ],
            ),
          ),
        ],
      ),
    ),
  ).whenComplete(() {
    //Navigator.of(context).pop();
    if(amountFocusNode!=null) FocusScope.of(context).requestFocus(amountFocusNode);
    });
}
