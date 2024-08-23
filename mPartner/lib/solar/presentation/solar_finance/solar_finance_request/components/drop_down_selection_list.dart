import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class DropDownSelectionWidget extends StatelessWidget {
  String labelText, placeholdertext;
  final TextEditingController controller;
  IconData icon;
  Widget modalBody;
  Color textColor;
  bool isEnabled;
  bool isMandatory;
  final VoidCallback? onSuffixPress;
  final ValueChanged<String>? onChanged;
  DropDownSelectionWidget(
      {super.key,
        required this.labelText,
        required this.controller,
        required this.placeholdertext,
        required this.icon,
        this.onChanged,
        this.onSuffixPress,
        this.modalBody = const Scaffold(),
        this.textColor = AppColors.hintColor,
        this.isEnabled = true,
        this.isMandatory = true});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight= DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();


    final OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    );

    final OutlineInputBorder enabledOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    );

    final TextStyle customHintStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w400,
      height: 0.12 * variablePixelHeight,
      letterSpacing: 0.50,
    );

    final TextStyle textStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: () {
        if(isEnabled){
          showModalBottomSheet(
              isScrollControlled: true,
              useSafeArea: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28 * pixelMultiplier),
                      topRight: Radius.circular(28 * pixelMultiplier))),
              showDragHandle: true,
              backgroundColor: Colors.white,
              context: context,
              builder: (BuildContext ctx) {
                return Container(child: modalBody);
              });
        }
      },
      style: textStyle,
      readOnly: true,
      decoration: InputDecoration(
          label: isMandatory ? Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: labelText,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
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
          ) : Text(
              labelText,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: 14 * textFontMultiplier,
                fontWeight: FontWeight.w400,
                height: 0.12 * variablePixelHeight,
                letterSpacing: 0.50,
              )
          ),
          suffixIcon: icon != null
              ? IconButton(
            icon: Icon(icon, color: isEnabled? AppColors.downArrowColor : AppColors.disabledDownArrorwColor),
            onPressed: onSuffixPress,
          ) : null,
          hintText: placeholdertext,
          focusedBorder: focusedOutlineInputBorder,
          enabledBorder: enabledOutlineInputBorder,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: customHintStyle,
          contentPadding: EdgeInsets.fromLTRB(16 * variablePixelWidth, 16 * variablePixelHeight, 8 * variablePixelWidth, 8 * variablePixelHeight)
      ),
    );
  }
}
