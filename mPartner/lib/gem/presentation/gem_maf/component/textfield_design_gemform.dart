import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/gem/presentation/gem_maf/component/show_selector_bootomsheet_gem.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../data/models/gem_option.dart';


class TextFieldDesignGemForm extends StatefulWidget {
  TextFieldDesignGemForm({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.isMandatory,
    required this.labelText,
    required this.hintText,
    required this.onChangedFunction,
    required this.inputFormatters,
    this.bottomPadding = 24,
    this.trailingIcon,
    this.onIconPress,
    this.onTap,
    this.readOnly = false,
    this.maxLength,
    this.errorText = "",
    this.isMobileNumber = false,
    this.isSolutionTypeSelector = false,
    required this.context,
    this.solutionTypes,
    this.isAverageEnergySelector = false,
    this.isCityStateSelector = false,
    this.selectedState,
    this.cityController,
    this.isSecondaryMobilePrefixEnabled = false,
    this.isMobilePrefixEnabled = false,
    this.isRupeeSymbolEnabled=false,
    this.focusNode
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isMandatory;
  final String labelText;
  final String hintText;
  final Function(String) onChangedFunction;
  final List<TextInputFormatter> inputFormatters;
  double bottomPadding;
  Icon? trailingIcon;
  Function()? onIconPress;
  Function()? onTap;
  final bool readOnly;
  final int? maxLength;
  final String? errorText;
  final bool isMobileNumber;
  final bool isSolutionTypeSelector;
  final List<GemOption>? solutionTypes;
  final bool isAverageEnergySelector;
  final bool isCityStateSelector;
  final String? selectedState;
  final TextEditingController? cityController;
  final BuildContext context;
  final bool isMobilePrefixEnabled;
  final bool isSecondaryMobilePrefixEnabled;
  final bool isRupeeSymbolEnabled;
  final FocusNode? focusNode;


  @override
  State<TextFieldDesignGemForm> createState() => _TextFieldDesignFormState();
}

class _TextFieldDesignFormState extends State<TextFieldDesignGemForm> {

  @override
  void initState() {
    super.initState();
  }
  String capitalizeEachWord(String text) {
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        // Special case for "And"
        if (words[i].toLowerCase() == 'and') {
          words[i] = '&';
        } else {
          words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
        }
      }
    }
    return words.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double variableTextMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();

    final TextStyle customHintStyle = GoogleFonts.poppins(
        fontSize: 14 * variableTextMultiplier,
        fontWeight: FontWeight.w400,
        height: 24 / 14,
        letterSpacing: 0.50,
        color: AppColors.grayText);

    final TextStyle customPrefixStyle = GoogleFonts.poppins(
      fontSize: 14 * variableTextMultiplier,
      fontWeight: FontWeight.w400,
      height: 24 / 14,
      letterSpacing: 0.50,
    );

    final TextStyle textStyle = GoogleFonts.poppins(
      fontSize: 14 * variableTextMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.50,
    );

    final OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius:
      BorderRadius.all(Radius.circular(4.0 * variablePixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.lumiBluePrimary),
    );

    final OutlineInputBorder enabledOutlineInputBorder = OutlineInputBorder(
      borderRadius:
      BorderRadius.all(Radius.circular(4.0 * variablePixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    );
    final OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
      borderRadius:
      BorderRadius.all(Radius.circular(4.0 * variablePixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.errorRed),
    );

    return Padding(
      padding:
      EdgeInsets.only(bottom: widget.bottomPadding * variablePixelHeight),
      child: TextField(
        onTapOutside: (event){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        readOnly: widget.readOnly,
        focusNode: widget.focusNode,
        enabled: true,
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap;
          }




          if (widget.isSolutionTypeSelector == true &&
              widget.solutionTypes != null) {
            ShowSelectorBottomSheetGem(
                true,
                widget.context,
                variablePixelHeight,
                variablePixelWidth,
                variableTextMultiplier,
                variablePixelMultiplier,
                null,
                widget.controller,
                translation(context).chooseparticipateType,
                widget.solutionTypes!);
          }
        },
        textCapitalization: (widget.keyboardType!=TextInputType.emailAddress)?TextCapitalization.words:TextCapitalization.none,
        maxLines: 1,
        style: textStyle,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        maxLength: (widget.maxLength == null) ? 50 : widget.maxLength,
        onChanged: (value) {
          widget.onChangedFunction(value);
        },
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          errorMaxLines: 2,
          // suffixText: (widget.isAverageEnergySelector)?'kWh':null,
          suffixIcon: GestureDetector(
              onTap: widget.onIconPress,
              child:
              SizedBox(height: 20, width: 20, child: widget.trailingIcon)),
          contentPadding: EdgeInsets.fromLTRB(
              16 * variablePixelWidth,
              4 * variablePixelHeight,
              8 * variablePixelWidth,
              4 * variablePixelHeight),
          prefixIconConstraints:
          const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIcon: widget.isMobileNumber&&(widget.isMobilePrefixEnabled||widget.isSecondaryMobilePrefixEnabled)
              ? Padding(
              padding: EdgeInsets.only(left: 10 * variablePixelWidth,bottom: 4*variablePixelHeight),
              child: Text("+91 - ", style: customPrefixStyle))
              : widget.isRupeeSymbolEnabled? Padding(
              padding: EdgeInsets.only(left: 10 * variablePixelWidth,bottom: 4*variablePixelHeight),
              child: Text("\u{20B9} ", style: customPrefixStyle)):null,
          label: Text.rich(
            // textScaler: const TextScaler.linear(1.5),
            TextSpan(
              children: [
                TextSpan(
                  text: widget.labelText,
                  style: GoogleFonts.poppins(
                    color: (widget.errorText == "")
                        ? AppColors.darkGreyText
                        : AppColors.errorRed,
                    fontSize: 12 * variableTextMultiplier,
                    height: 16 / 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.40,
                  ),
                ),
                if (widget.isMandatory)
                  TextSpan(
                    text: '*',
                    style: GoogleFonts.poppins(
                      color: AppColors.errorRed,
                      fontSize: 12 * variableTextMultiplier,
                      height: 16 / 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.40,
                    ),
                  ),
              ],
            ),
          ),
          hintText: widget.hintText,
          counterText: "",
          focusedBorder: (widget.isCityStateSelector == true)
              ? enabledOutlineInputBorder : focusedOutlineInputBorder,
          enabledBorder: enabledOutlineInputBorder,
          errorBorder: errorOutlineInputBorder,
          focusedErrorBorder: errorOutlineInputBorder,
          errorText: widget.errorText != "" ? widget.errorText : null,
          labelStyle: GoogleFonts.poppins(
            color: AppColors.grayText,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
            letterSpacing: 0.40,
          ),
          errorStyle: GoogleFonts.poppins(
            color: AppColors.errorRed,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
            letterSpacing: 0.40,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: customHintStyle,
          prefixStyle: customPrefixStyle,
        ),
      ),
    );
  }
}
