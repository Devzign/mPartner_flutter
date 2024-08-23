import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';

class PincodeTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  PincodeTextField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Container(
      margin:  EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
      height: 55 * variablePixelHeight,
      child: TextField(
        controller: controller,
        maxLength: 6,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        keyboardType: TextInputType.number,
        style: GoogleFonts.poppins(
          fontSize: 14 * textFontMultiplier,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.50 * variablePixelWidth,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          labelText: translation(context).enterPincode,
          hintText: translation(context).enterPincodeOfShop,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
            borderSide: const BorderSide(color: AppColors.lumiBluePrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
            borderSide: const BorderSide(color: AppColors.lightGrey1),
          ),
          labelStyle: GoogleFonts.poppins(
            color: controller.text.isEmpty
                ? AppColors.darkGreyText
                : AppColors.lumiBluePrimary,
            fontSize: 14 * textFontMultiplier,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.40 * variablePixelWidth,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14 * textFontMultiplier,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.50 * variablePixelWidth,
          ),
        ),
      ),
    );
  }
}
