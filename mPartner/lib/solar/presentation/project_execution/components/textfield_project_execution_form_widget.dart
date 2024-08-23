import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../presentation/widgets/common_divider.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../data/models/option.dart';
import '../../../state/controller/ProjectExecutionFormController.dart';
import '../../solar_design/design_request_form/components/dropdown_selector.dart';
import '../model/support_reason_model.dart';

enum CityState { City, State }

class TextFieldProjectExecutionForm extends StatefulWidget {
  TextFieldProjectExecutionForm(
      {super.key,
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
      this.isSecondaryMobilePrefixEnabled = false,
      this.isMobilePrefixEnabled = false,
      this.isSolutionTypeSelector = false,
      required this.context,
      this.solutionTypes,
      this.isAverageEnergySelector = false,
      this.averageEnergyValues,
      this.isCityStateSelector = false,
      this.isSupportReason = false,
      this.isSubCategory = false,
      this.supportReasonList,
      this.cityStateEnum,
      this.selectedState,
      this.cityController,
      this.focusNode,
      this.subCategoryController});

  final TextEditingController controller;
  final TextEditingController? subCategoryController;
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
  final bool isMobilePrefixEnabled;
  final bool isSecondaryMobilePrefixEnabled;
  final bool isSolutionTypeSelector;
  final List<Option>? solutionTypes;
  final bool isAverageEnergySelector;
  final List<Option>? averageEnergyValues;
  final bool isCityStateSelector;
  final String? selectedState;
  final CityState? cityStateEnum;
  final bool? isSupportReason;
  final bool? isSubCategory;
  final List<SupportReason>? supportReasonList;
  final TextEditingController? cityController;
  final BuildContext context;
  final FocusNode? focusNode;

  @override
  State<TextFieldProjectExecutionForm> createState() =>
      _TextFieldProjectExecutionFormState();
}

class _TextFieldProjectExecutionFormState
    extends State<TextFieldProjectExecutionForm> {
  String mobileNumberWithoutPrefix = '';
  ProjectExecutionFormController projectExecutionFormController = Get.find();

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
          words[i] =
              words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
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
        readOnly: widget.readOnly,
        focusNode: widget.focusNode,
        textCapitalization: (translation(context).contactPersonEmailId==widget.labelText||translation(context).secondaryContactEmailId==widget.labelText)?TextCapitalization.none: TextCapitalization.words,
        enabled: true,
        onTapOutside: (event){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap;
            print('im here');
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

          if ((widget.isSupportReason == true ||
                  widget.isSubCategory == true) &&
              widget.supportReasonList != null) {
            List<Option> supportReasonCategoryList = [];

            if (widget.isSupportReason == true) {
              widget.supportReasonList?.forEach((element) {
                supportReasonCategoryList
                    .add(Option(id: element.reasonId, name: element.reason));
              });
            }

            if (widget.isSubCategory == true) {
              widget.supportReasonList?.forEach((element) {
                if (element.reason ==
                    projectExecutionFormController
                        .selectedSupportReason.value) {
                  element.subCategories.forEach((subCategory) {
                    supportReasonCategoryList.add(Option(
                        id: subCategory.subCategoryId,
                        name: subCategory.subCategory));
                  });
                }
              });
            }

            if (widget.isSupportReason == true) {
              showSelectorBottomSheet(
                  true,
                  widget.context,
                  variablePixelHeight,
                  variablePixelWidth,
                  variableTextMultiplier,
                  variablePixelMultiplier,
                  null,
                  widget.controller,
                  translation(context).selectReasonForSupport,
                  supportReasonCategoryList,
                  widget.subCategoryController,
                  true);
            }

            if (widget.isSubCategory == true&&projectExecutionFormController
                .selectedSupportReason.value.isNotEmpty) {
              showSelectorBottomSheet(
                true,
                widget.context,
                variablePixelHeight,
                variablePixelWidth,
                variableTextMultiplier,
                variablePixelMultiplier,
                null,
                widget.controller,
                translation(context).selectSubCategory,
                supportReasonCategoryList,
              );
            }
          }

          if (widget.isCityStateSelector == true) {
            String title =
                'Select ${widget.cityStateEnum.toString().split('.').last}';
            // if (widget.cityStateEnum == CityState.State) {
            //   projectExecutionFormController.getStates();
            // } else
            if (widget.cityStateEnum == CityState.City) {
              projectExecutionFormController.getCities();
            }
            if (widget.cityStateEnum == CityState.State ||
                (widget.cityStateEnum == CityState.City &&
                    projectExecutionFormController.selectedState.value != '')) {
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
                  margin: EdgeInsets.fromLTRB(
                      8 * variablePixelWidth,
                      8 * variablePixelHeight,
                      8 * variablePixelWidth,
                      8 * variablePixelHeight),
                  child: Column(
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
                        padding:
                            EdgeInsets.only(left: 16.0 * variablePixelWidth),
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
                        child:
                            const CustomDivider(color: AppColors.dividerColor),
                      ),
                      Obx(
                        () => (projectExecutionFormController.isLoading.value)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                constraints: BoxConstraints(
                                    maxHeight: 500 * variablePixelHeight),
                                child: ListView(
                                  shrinkWrap: true,
                                  children:
                                      ((widget.cityStateEnum == CityState.State)
                                              ? projectExecutionFormController
                                                  .stateList
                                              : projectExecutionFormController
                                                  .cityList)
                                          .map((dynamic solution) {
                                    return ListTile(
                                      // dense: true,
                                      // visualDensity: const VisualDensity(
                                      //     horizontal: 0, vertical: -1),
                                      contentPadding: EdgeInsets.only(
                                          left: 24 * variablePixelWidth,
                                          right: 24 * variablePixelHeight,
                                          top: 0,
                                          bottom: 0),
                                      title: Text(
                                        capitalizeEachWord(widget.cityStateEnum ==
                                            CityState.State?solution.stateName:solution.districtName),
                                        style: GoogleFonts.poppins(
                                          fontSize: 16 * variableTextMultiplier,
                                          height: 24 / 16,
                                          letterSpacing:
                                              0.5 * variablePixelWidth,
                                          color: AppColors.darkGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onTap: () {
                                        if (widget.cityStateEnum ==
                                            CityState.State) {
                                          widget.onChangedFunction("");
                                          projectExecutionFormController
                                              .updateSelectedState(solution.stateName);
                                          projectExecutionFormController
                                              .updateSelectedStateId(solution.stateId);
                                          projectExecutionFormController
                                              .cityList
                                              .clear();
                                          setState(() {
                                            if (widget.cityController != null)
                                              widget.cityController!.clear();
                                          });
                                        }
                                         setState(() {
                                           widget.controller.text =
                                               capitalizeEachWord(widget.cityStateEnum ==
                                                   CityState.State?solution.stateName:solution.districtName );
                                         });

                                        Navigator.pop(context);
                                      },
                                    );
                                  }).toList(),
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
          suffixIcon: GestureDetector(
              onTap: widget.onIconPress,
              child:
                  SizedBox(height: 20, width: 20, child: widget.trailingIcon)),
          prefixIconConstraints:
          const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIcon: widget.isMobileNumber&&(widget.isMobilePrefixEnabled||widget.isSecondaryMobilePrefixEnabled)
              ? Padding(
              padding: EdgeInsets.only(left: 10 * variablePixelWidth,bottom: 4*variablePixelHeight),
              child: Text("+91 - ", style: customPrefixStyle))
              : null,
          contentPadding: EdgeInsets.fromLTRB(
              16 * variablePixelWidth,
              4 * variablePixelHeight,
              8 * variablePixelWidth,
              4 * variablePixelHeight),
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
          focusedBorder: (widget.trailingIcon!=null)?enabledOutlineInputBorder:focusedOutlineInputBorder,
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
