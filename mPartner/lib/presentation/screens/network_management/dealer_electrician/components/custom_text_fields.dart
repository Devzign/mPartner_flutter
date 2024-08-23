import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final List<String>? dropdownItems;
  final String? selectedValue;
  final Function(String) onValueChanged;
  final bool isManditory;
  final BuildContext context;
  final String? errorText;
  final bool isAllCaps;
  final bool isEnabled;
  final FocusNode? focusNode;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  CustomTextField(
      {required this.controller,
      required this.labelText,
      required this.keyboardType,
      this.dropdownItems,
      this.selectedValue,
      required this.onValueChanged,
      required this.hintText,
      this.errorText = "",
      this.isAllCaps = false,
      this.isEnabled = true,
      required this.isManditory,
      required this.context,
      this.focusNode,
      this.maxLength,
      this.inputFormatters});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late double labelFontSize;

  late double variablePixelHeight;

  late double variablePixelWidth;

  late double textFontMultiplier;

  late TextStyle customHintStyle;

  late TextStyle customPrefixStyle;

  late TextStyle textStyle;

  late OutlineInputBorder focusedOutlineInputBorder;

  late OutlineInputBorder enabledOutlineInputBorder;

  late OutlineInputBorder errorOutlineInputBorder;

  var variablePixelMultiplier;

  String mobileNumberWithoutPrefix = '';

  @override
  Widget build(BuildContext context) {
    /* if(labelText==translation(context).mobileNumber) {
      if (!controller.text.startsWith('+91 - ')) {
        controller.text = '+91 - ';
      }
    }*/
    variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    getPreBuildData();
    return Container(
   //   height: (widget.errorText!.isNotEmpty ? (85*variablePixelHeight) : (60 * variablePixelHeight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,

            style: textStyle,
            onChanged: (value) {
              if (widget.labelText == translation(context).mobileNumber) {
                /*  if (!value.startsWith('+91 - ')) {
                  controller.text = '+91 - ';
                }*/
                mobileNumberWithoutPrefix = value.startsWith('+91 - ')
                    ? value.substring('+91 - '.length)
                    : value;
              }
              widget.onValueChanged(value);
            },
            readOnly: !widget.isEnabled,
            enabled:widget.labelText == translation(context).state ? false : true,
            keyboardType: widget.keyboardType,
            maxLength: (widget.maxLength == null) ? 50 : widget.maxLength,
            inputFormatters: widget.inputFormatters,
            textCapitalization:
                (widget.keyboardType == TextInputType.emailAddress)
                    ? TextCapitalization.none
                    : (widget.isAllCaps &&
                            widget.keyboardType == TextInputType.text)
                        ? TextCapitalization.characters
                        : TextCapitalization.words,
            decoration: InputDecoration(
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 0, minHeight: 0),
                prefixIcon: widget.labelText ==
                        translation(context).mobileNumber
                    ? Padding(
                        padding: EdgeInsets.only(left: 10 * variablePixelWidth),
                        child: Text("+91 - ", style: customPrefixStyle))
                    : null,
                counterText: "",
                errorText:
                    widget.errorText!.isNotEmpty ? widget.errorText : null,
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.labelText,
                        style: GoogleFonts.poppins(
                          color:
                              (widget.labelText == translation(context).state)
                                  ? AppColors.grayText
                                  : AppColors.blackText,
                          fontSize: 14 * textFontMultiplier,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.40,
                        ),
                      ),
                      (widget.isManditory)
                          ? TextSpan(
                              text: '*',
                              style: GoogleFonts.poppins(
                                color: AppColors.errorRed,
                                fontSize: 14 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.40,
                              ),
                            )
                          : TextSpan(),
                    ],
                  ),
                ),
                hintText: widget.hintText,
                focusedBorder: focusedOutlineInputBorder,
                enabledBorder: enabledOutlineInputBorder,
                disabledBorder: enabledOutlineInputBorder,
                focusedErrorBorder: enabledOutlineInputBorder,
                errorBorder: errorOutlineInputBorder,
                filled: !widget.isEnabled,
                fillColor: AppColors.grey97,
                labelStyle: GoogleFonts.poppins(
                  color: widget.controller.text.isEmpty
                      ? AppColors.darkGreyText
                      : AppColors.lumiBluePrimary,
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.w400,
                  height: 0.11,
                  letterSpacing: 0.40,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle: customHintStyle,
                prefixStyle: customPrefixStyle,
                contentPadding: EdgeInsets.fromLTRB(
                    16 * variablePixelWidth,
                    18 * variablePixelHeight,
                    8 * variablePixelWidth,
                    18 * variablePixelHeight)),
          ),
          if (widget.dropdownItems != null) SizedBox(height: 16),
          if (widget.dropdownItems != null)
            DropdownButton<dynamic>(
              value: widget.selectedValue,
              onChanged: (value) {},
              items: widget.dropdownItems!
                  .map<DropdownMenuItem<dynamic>>((dynamic value) {
                return DropdownMenuItem<dynamic>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text(translation(context).selectanOption),
            ),
        ],
      ),
    );
  }

  // void validateMobileNumber(String mobileNumber) {
  void getPreBuildData() {
    labelFontSize = DisplayMethods(context: widget.context).getLabelFontSize();
    variablePixelHeight =
        DisplayMethods(context: widget.context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: widget.context).getVariablePixelWidth();
    textFontMultiplier =
        DisplayMethods(context: widget.context).getTextFontMultiplier();

    customHintStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w400,
      height: 0.12,
      letterSpacing: 0.50,
    );

    customPrefixStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      height: 0.12,
      letterSpacing: 0.50,
    );

    textStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
    );

    focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(4.0 * variablePixelMultiplier)),
      borderSide: BorderSide(color: AppColors.lumiBluePrimary),
    );

    enabledOutlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(color: AppColors.dividerColor),
    );

    errorOutlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(color: AppColors.errorRed),
    );
  }
}
