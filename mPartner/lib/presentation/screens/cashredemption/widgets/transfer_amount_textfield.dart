import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

class EnterAmountTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final Function(String)? onChanged;
  final String validationInfo;
  final String? errorText;
  final bool? readOnly;
  final FocusNode? textfieldFocusNode;

  const EnterAmountTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.labelText,
    required this.hintText,
    this.onChanged,
    this.errorText,
    required this.validationInfo,
    this.readOnly,
    this.textfieldFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Container(
      margin: EdgeInsets.only(
        left: 24 * variablePixelWidth,
        top: 20 * variablePixelHeight,
      ),
      child: TextField(
        focusNode: textfieldFocusNode,
        controller: controller,
        keyboardType: keyboardType,
        maxLength: 9,
        style: GoogleFonts.poppins(
          fontSize: 14 * textFontMultiplier,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.50,
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.deny(RegExp('^0+'))
        ],
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
          errorMaxLines: 5,
          contentPadding: EdgeInsets.fromLTRB(16 * variablePixelWidth, 0, 0, 0),
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          counterText: "",
          focusedBorder: readOnly!
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0 * pixelMultiplier),
                  borderSide: BorderSide(color: AppColors.grey))
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0 * pixelMultiplier),
                  borderSide: const BorderSide(color: AppColors.lumiBluePrimary),
                ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0 * pixelMultiplier),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0 * pixelMultiplier),
            borderSide: const BorderSide(color: AppColors.errorRed),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0 * pixelMultiplier),
            borderSide: const BorderSide(color: AppColors.errorRed),
          ),
          labelStyle: GoogleFonts.poppins(
            color: validationInfo.isEmpty
                ? (textfieldFocusNode!=null
                    ?(!textfieldFocusNode!.hasFocus)
                      ? AppColors.darkGrey
                      : AppColors.lumiBluePrimary
                    :AppColors.darkGrey
                    )
                : AppColors.errorRed,
            fontSize: 16 * textFontMultiplier,
            fontWeight: FontWeight.w400,
            height: 0.11,
            letterSpacing: 0.40,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14 * textFontMultiplier,
            fontWeight: FontWeight.w400,
            height: 0.12,
            letterSpacing: 0.50,
          ),
          errorStyle: GoogleFonts.poppins(
            color: AppColors.errorRed,
            fontSize: 12 * textFontMultiplier,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.50,
          ),
        ),
      ),
    );
  }
}
