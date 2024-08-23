import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';


class SecondaryUserFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPress;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatter;

  SecondaryUserFormFieldWidget({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.errorText,
    this.onChanged,
    this.readOnly = false,
    this.suffixIcon,
    this.onSuffixPress,
    this.onTap,
    this.suffixIconColor,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.inputFormatter,
    this.prefixIcon,
    this.prefixIconConstraints,
  });

  @override
  Widget build(BuildContext context) {

    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    final OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.lumiBluePrimary),
    );

    final OutlineInputBorder enabledOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.lumiBluePrimary),
    );

    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0 * pixelMultiplier),
      borderSide: const BorderSide(color: AppColors.errorRed),
    );

    final OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.errorRed),
    );
    final TextStyle customHintStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.50,
    );

    final TextStyle customPrefixStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      height: 0.12 * variablePixelHeight,
      letterSpacing: 0.50,
    );

    final TextStyle textStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
    );

    return TextField(
      inputFormatters: inputFormatter,
      controller: controller,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: onTap,
      style: textStyle,
      maxLength: maxLength,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: labelText,
                  style: GoogleFonts.poppins(
                    color: errorText != null ? AppColors.errorRed : AppColors.darkGreyText,
                    fontSize: 12 * textFontMultiplier,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.40,
                  ),
                ),
                TextSpan(
                  text: '*',
                  style: GoogleFonts.poppins(
                    color: AppColors.errorRed,
                    fontSize: 12 * textFontMultiplier,
                    fontWeight: FontWeight.w400,
                    height: 0.11 * variablePixelHeight,
                    letterSpacing: 0.40,
                  ),
                ),
              ],
            ),
          ),
          suffixIcon: suffixIcon != null
              ? IconButton(
            icon: Icon(suffixIcon, color: suffixIconColor),
            onPressed: onSuffixPress,
          ) : null,
          counterText: "",
          hintText: hintText,
          focusedBorder: focusedOutlineInputBorder,
          enabledBorder: enabledOutlineInputBorder,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: customHintStyle,
          prefixStyle: customPrefixStyle,
          errorText: errorText,
          errorStyle: GoogleFonts.poppins(
            color: AppColors.errorRed,
            fontSize: 12 * textFontMultiplier,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.40,
          ),
          prefixIcon: prefixIcon,
          prefixIconConstraints: prefixIconConstraints,
          errorBorder: errorBorder,
          focusedErrorBorder: focusedErrorBorder,
          contentPadding: EdgeInsets.fromLTRB(16 * variablePixelWidth, 16 * variablePixelHeight, 8 * variablePixelWidth, 8 * variablePixelHeight)
      ),
    );
  }
}

