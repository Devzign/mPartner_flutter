import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../ismartdisclaimer/components/ismart_termscondition_alert.dart';

import '../../../../../utils/localdata/language_constants.dart';

class TermsConditionsWidget extends StatelessWidget {
  const TermsConditionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler =  DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =  DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 24 * variablePixelWidth,
          vertical: 20 * variablePixelWidth),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 5 * variablePixelWidth,
            height: 5 * variablePixelHeight,
            decoration: const ShapeDecoration(
              color: Color(0xFFD9D9D9),
              shape: OvalBorder(),
            ),
          ),
          TextButton(
              onPressed: () {
                // Navigator.push(
                // context, MaterialPageRoute(builder: (context) => TermsConditionsBottomSheet()));
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  enableDrag: true,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return TermsConditionsBottomSheet(
                      firstAppearance: false,
                    );
                  },
                );
              },
              child: Text(
                translation(context).termsAndConditions,
                style: GoogleFonts.poppins(
                    color: AppColors.grayText,
                    fontSize: 14 * textMultiplier,
                    fontWeight: FontWeight.w500,
                    height: 0.20 * variablePixelHeight,
                    letterSpacing: 0.10,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.grayText),
              )),
          Container(
            width: 5 * variablePixelWidth,
            height: 5 * variablePixelHeight,
            decoration: const ShapeDecoration(
              color: Color(0xFFD9D9D9),
              shape: OvalBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
