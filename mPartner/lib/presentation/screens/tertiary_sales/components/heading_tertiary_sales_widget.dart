import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpartner/utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

import '../../../../utils/localdata/language_constants.dart';

class HeadingTertiarySales extends StatefulWidget {
  const HeadingTertiarySales({super.key});

  @override
  State<HeadingTertiarySales> createState() => _HeadingTertiarySalesState();
}

class _HeadingTertiarySalesState extends State<HeadingTertiarySales> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Padding(
      padding: EdgeInsets.fromLTRB(
          2.0 * variablePixelWidth, 0.0, 2.0 * variablePixelWidth, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: AppColors.titleColor,
              ),
              onPressed: () => {Navigator.pop(context)},
            ),
          ),
          Expanded(
            flex: 15,
            child: Text(
              translation(context).tertiarySale,
              style: GoogleFonts.poppins(
                color: AppColors.titleColor,
                fontSize: 22 * textFontMultiplier,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
