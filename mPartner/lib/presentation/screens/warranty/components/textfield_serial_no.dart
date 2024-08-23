import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';

class TextFieldSerialNo extends StatelessWidget {
  TextFieldSerialNo({
    this.isEnabled = true,
    this.horizontalPadding = 0,
    super.key,
    this.clearText = false,
  });

  final double horizontalPadding;
  final bool isEnabled;

  final bool clearText;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * variablePixelWidth),
      child: TextField(
        enabled: isEnabled,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          border: OutlineInputBorder(),
          hintStyle: GoogleFonts.poppins(
              color: AppColors.lightGrey1,
              fontSize: 14 * variablePixelHeight,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.50),
          floatingLabelStyle: GoogleFonts.poppins(
            color: AppColors.lightGrey1,
            fontSize: 12 * variablePixelWidth,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.40,
          ),
          // hintStyle:
          labelText: translation(context).serialNo,
          hintText: translation(context).checkSerialNumber,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
