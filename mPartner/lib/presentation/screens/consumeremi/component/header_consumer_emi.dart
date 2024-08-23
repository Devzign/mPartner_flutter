import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../cashredemption/widgets/green_tick_icon.dart';
import '../widget/dotted_line.dart';

class HeaderConsumerEmi extends StatelessWidget {
  const HeaderConsumerEmi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Container(
      margin: EdgeInsets.fromLTRB(24 * variablePixelWidth, 4 * variablePixelHeight, 24 * variablePixelWidth, 24 * variablePixelHeight),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 68 * variablePixelWidth,
                height: 68 * variablePixelHeight,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0 * pixelMultiplier),
                  border: Border.all(
                    color: AppColors.lumiLightBlue,
                    width: 1.0 * variablePixelWidth,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/mpartner/logo.png',
                      width: 44 * variablePixelWidth,
                      height: 9 * variablePixelHeight,
                    ),
                    Image.asset(
                      'assets/mpartner/mPartner.png',
                      width: 20 * variablePixelWidth,
                      height: 11 * variablePixelHeight,
                    ),
                  ],
                ),
              ),
              const HorizontalSpace(width: 8),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 69 * variablePixelWidth,
                    child: CustomPaint(
                      painter: DottedLinePainter(),
                    ),
                  ),
                  const Positioned(
                    child: CustomTickIcon(),
                  ),
                ],
              ),
              Container(
                width: 68 * variablePixelWidth,
                height: 68 * variablePixelHeight,
                child: Image.asset(
                  'assets/mpartner/hdfc-logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 16 * variablePixelHeight, right: 24 * variablePixelWidth),
            child: Container(
              width: 345 * variablePixelWidth,
              height: 40 * variablePixelHeight,
              child: Text(
                translation(context).headerTagLine,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 14 * textFontMultiplier,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10 * variablePixelWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
