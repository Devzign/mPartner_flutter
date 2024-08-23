import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/textfield_input_handler.dart';

class MobileNumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function() onTap;
  final String prefix;

  MobileNumberTextField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onTap,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Container(
      margin: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
      height: 55 * variablePixelHeight,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 10,
        keyboardType: TextInputType.number,
        style: GoogleFonts.poppins(
          fontSize: 14 * textFontMultiplier,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.50 * variablePixelWidth,
        ),
        inputFormatters: <TextInputFormatter>[
          HandleFirstDigitInMobileTextFieldFormatter(),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        onChanged: onChanged,
        onTap: onTap,
        decoration: InputDecoration(
          contentPadding:  EdgeInsets.only(left: 16 * variablePixelWidth, top: 4 * variablePixelHeight),
          counterText: '',
          labelText: translation(context).mobileNumber,
          hintText: translation(context).enterConsumerMobNo,
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
            height: 0.12 * variablePixelHeight,
            letterSpacing: 0.50 * variablePixelWidth,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIcon: Padding(padding:EdgeInsets.only(left: 16 * variablePixelWidth),
              child: Text(prefix,
                  style: GoogleFonts.poppins(
                    fontSize: 14 * textFontMultiplier,
                    fontWeight: FontWeight.w500,
                    height: 0.12 * variablePixelHeight,
                    letterSpacing: 0.50 * variablePixelWidth,
                )
              )
          ),
        ),
      ),
    );
  }
}
