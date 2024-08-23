import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../presentation/widgets/common_divider.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../data/models/city_model.dart';
import '../../../../data/models/option.dart';
import '../../../../data/models/state_model.dart';
import '../../../../state/controller/solar_design_request_controller.dart';
import 'dropdown_selector.dart';

enum CityState { City, State }

class TextFieldDesignForm extends StatefulWidget {
  TextFieldDesignForm({
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
    this.averageEnergyValues,
    this.isCityStateSelector = false,
    this.cityStateEnum,
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
  final List<Option>? solutionTypes;
  final bool isAverageEnergySelector;
  final List<Option>? averageEnergyValues;
  final bool isCityStateSelector;
  final String? selectedState;
  final CityState? cityStateEnum;
  final TextEditingController? cityController;
  final BuildContext context;
  final bool isMobilePrefixEnabled;
  final bool isSecondaryMobilePrefixEnabled;
  final bool isRupeeSymbolEnabled;
  final FocusNode? focusNode;


  @override
  State<TextFieldDesignForm> createState() => _TextFieldDesignFormState();
}

class _TextFieldDesignFormState extends State<TextFieldDesignForm> {
  String mobileNumberWithoutPrefix = '';
  SolarDesignRequestController solarDesignRequestController = Get.find();

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
          
          if (widget.isMobileNumber) {
            mobileNumberWithoutPrefix = widget.controller.text.startsWith('+91 - ')
                ? widget.controller.text.substring('+91 - '.length)
                : widget.controller.text;
          }


          if (widget.isSolutionTypeSelector == true &&
              widget.solutionTypes != null) {
            showSelectorBottomSheet(
                true,
                widget.context,
                variablePixelHeight,
                variablePixelWidth,
                variableTextMultiplier,
                variablePixelMultiplier,
                null,
                widget.controller,
                translation(context).selectSolutionType,
                widget.solutionTypes!);
          }
          // if (widget.isAverageEnergySelector == true &&
          //     widget.averageEnergyValues != null) {
          //   showSelectorBottomSheet(
          //       false,
          //       widget.context,
          //       variablePixelHeight,
          //       variablePixelWidth,
          //       variableTextMultiplier,
          //       variablePixelMultiplier,
          //       null,
          //       widget.controller,
          //       'Average Energy Consumption',
          //       widget.averageEnergyValues!);
          // }

          if (widget.isCityStateSelector == true) {
            String title =(widget.cityStateEnum==CityState.City)?
            translation(context).selectCity:translation(context).selectState;
                // 'Select ${widget.cityStateEnum.toString().split('.').last}';
            // if (widget.cityStateEnum == CityState.State) {
            //   solarDesignRequestController.getStates();
            // } else 
            if (widget.cityStateEnum == CityState.City) {
              solarDesignRequestController.getCities();
            }
            if(widget.cityStateEnum == CityState.State || (widget.cityStateEnum == CityState.City && solarDesignRequestController.selectedState.value!='')) {
              showModalBottomSheet(
              useSafeArea: true,
              context: context,
              enableDrag: false,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0 * variablePixelMultiplier),
              )),
              builder: (context) => Container(
                margin: EdgeInsets.fromLTRB(8 * variablePixelWidth, 8 * variablePixelHeight, 8 * variablePixelWidth, 8 * variablePixelHeight),
                child: 
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Center(
                            child: Container(
                              height: 5 * variablePixelHeight,
                              width: 50 * variablePixelWidth,
                              decoration: BoxDecoration(
                                color: AppColors.dividerGreyColor,
                                borderRadius: BorderRadius.circular(
                                    12 * variablePixelMultiplier),
                              ),
                            ),
                          ),
                        ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: AppColors.black,
                        size: 28 * variablePixelMultiplier,
                      ),
                    ),
                    const VerticalSpace(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0 * variablePixelWidth),
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: AppColors.titleColor,
                          fontSize: 20 * variableTextMultiplier,
                          fontWeight: FontWeight.w600,
                          height: 0.06,
                          letterSpacing: 0.50 * variablePixelWidth,
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                      child: const CustomDivider(color: AppColors.dividerColor),
                    ),
                    Obx(()=>
                    (solarDesignRequestController.isLoading.value)
                      ?const Center(
                        child: CircularProgressIndicator(),
                      )
                      :Container(
                        constraints: BoxConstraints(maxHeight: 500 * variablePixelHeight),
                        child: ListView(
                          shrinkWrap: true,
                          children: (widget.cityStateEnum==CityState.State)
                          ?solarDesignRequestController.stateList.map((SolarStateData state) {
                            return ListTile(
                              contentPadding: EdgeInsets.only(
                                  left: 24 * variablePixelWidth,
                                  right: 24 * variablePixelHeight,
                                  top: 0,
                                  bottom: 0),
                              title: Text(
                                capitalizeEachWord(state.stateName),
                                style: GoogleFonts.poppins(
                                  fontSize: 16 * variableTextMultiplier,
                                  height: 24 / 16,
                                  letterSpacing: 0.5 * variablePixelWidth,
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                              if (widget.cityStateEnum == CityState.State) {
                                solarDesignRequestController
                                      .updateSelectedState(state);
                                      
                                solarDesignRequestController.cityList.clear();
                                setState(() {
                                  if(widget.cityController!=null) widget.cityController!.clear();
                                });
                                }
                                setState(() {
                                  widget.controller.text = capitalizeEachWord(state.stateName);
                                });
                                
                                Navigator.pop(context);
                              },
                            );
                          }).toList()
                          :solarDesignRequestController.cityList.map((SolarCityData city) {
                            return ListTile(
                              contentPadding: EdgeInsets.only(
                                  left: 24 * variablePixelWidth,
                                  right: 24 * variablePixelHeight,
                                  top: 0,
                                  bottom: 0),
                              title: Text(
                                capitalizeEachWord(city.districtName),
                                style: GoogleFonts.poppins(
                                  fontSize: 16 * variableTextMultiplier,
                                  height: 24 / 16,
                                  letterSpacing: 0.5 * variablePixelWidth,
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  widget.controller.text = capitalizeEachWord(city.districtName);
                                });
                                
                                Navigator.pop(context);
                              },
                            );
                          }).toList()
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 24),
                  ],
                ),
              ),
            );
            }
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
