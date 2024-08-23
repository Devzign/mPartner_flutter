import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../../utils/app_colors.dart';
import '../../../../../presentation/widgets/common_divider.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/localdata/language_constants.dart';

void showGeocodeInfoBottomSheet(BuildContext context, double variablePixelHeight,
    double variablePixelWidth, double textFontMultiplier, double pixelMultiplier,{FocusNode? amountFocusNode, String? maxAmountLimitMessage}){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
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
                Padding(
                  padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                  child: Text(
                    translation(context).projectCurrentLocation,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 20 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      height: 24/20,
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
                  child: Text(
                    translation(context).geocodeInstructions,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGrey,
                      fontSize: 12 * textFontMultiplier,
                      fontWeight: FontWeight.w400,
                      //height: 18/12,
                    ),
                  ),
                ),
                const VerticalSpace(height: 24),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
