import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Padding(
      padding: EdgeInsets.fromLTRB(24 * variablePixelWidth,
          8 * variablePixelHeight, 24 * variablePixelWidth, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 16 * variablePixelWidth,
              height: 16 * variablePixelHeight,
              child: Icon(Icons.info_outline,
                  color: AppColors.grayText, size: 16 * pixelMultiplier),
            ),
          ),
          const VerticalSpace(height: 4),
          Expanded(
            child: Text(
              (message!='')? message: translation(context).infoMessage,
              softWrap: true,
              style: GoogleFonts.poppins(
                fontSize: 12 * textMultiplier,
                height: 16 / 12,
                fontWeight: FontWeight.w400,
                color: AppColors.grayText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
