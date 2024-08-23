import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/displaymethods/display_methods.dart';
import '../../utils/utils.dart';

class RupeeWithSignWidgetWithDecimal extends StatelessWidget {
  RupeeWithSignWidgetWithDecimal(
      {super.key,
      required this.cash,
      required this.color,
      required this.size,
      required this.weight,
      required this.width,
      this.showSign = false,
      this.signText = ''});

  final double width;
  final double cash;
  final Color color;
  final int size;
  final FontWeight weight;
  final bool showSign;
  final String signText;

  final _myGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AutoSizeText(
          "\u{20B9} ",
          group: _myGroup,
          maxLines: 1,
          stepGranularity: 0.25,
          minFontSize: (size * f).roundToDouble() - 1,
          style: GoogleFonts.roboto(
            color: color,
            fontSize: size * f,
            fontWeight: weight,
          ),
        ),
        if (showSign)
          AutoSizeText(
            signText,
            group: _myGroup,
            maxLines: 1,
            stepGranularity: 0.25,
            minFontSize: (size * f).roundToDouble() - 1,
            style: GoogleFonts.roboto(
              color: color,
              fontSize: size * f,
              fontWeight: weight,
            ),
          ),
        Container(
          constraints: BoxConstraints(maxWidth: (width - 25) * w),
          child: AutoSizeText(
            rupeeNoSignWithDecimal.format(cash),
            group: _myGroup,
            maxLines: 1,
            stepGranularity: 0.25,
            minFontSize: (size * f).roundToDouble() - 1,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: size * f,
              fontWeight: weight,
            ),
          ),
        ),
      ],
    );
  }
}
