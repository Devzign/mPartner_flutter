import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../state/contoller/auth_contoller.dart';
import '../../../utils/app_constants.dart';
import '../../screens/network_management/dealer_electrician/components/custom_calender.dart';

DateTime selectedDate = DateTime.now();

class CustomCalendarView extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Icon icon;
  final String calendarType;
  final String? errorText;
  final String dateFormat;
  final DateTime calendarStartDate;
  final DateTime calendarEndDate;
  final TextEditingController? singleDateEditController;
  final TextEditingController? startDateEditController;
  final TextEditingController? endDateEditController;
  final Function(String) onDateSelected;
  final Function(String, String) onDateRangeSelected;
  final double? height;
  final int? daysRange;
  final DateTime? disableDate;
  final DateTime? initialDateSelection;

  const CustomCalendarView(
      {required this.labelText,
      required this.hintText,
      required this.icon,
      required this.calendarType,
      this.errorText,
        this.daysRange,
      required this.dateFormat,
      required this.calendarStartDate,
      required this.calendarEndDate,
      this.singleDateEditController,
      this.startDateEditController,
      this.endDateEditController,
      required this.onDateSelected,
      required this.onDateRangeSelected,
      this.height,
      this.initialDateSelection,
        this.disableDate,
      super.key});

  @override
  State<CustomCalendarView> createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  late double variablePixelHeight;
  late double variablePixelWidth;
  late double variablePixelMultiplier;
  late double variableTextMultiplier;
  late String userType;

  AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void _handleTap() async {
    if (widget.calendarType == AppConstants.rangeSelectionCalenderType) {
      if (widget.startDateEditController!.text.isEmpty) {
        authController.isCalendarAtFirst = true;
      } else {
        authController.isCalendarAtFirst = true;
      }
      await showCustomDateRangePicker(
        context: context,
        initialDateRange:
            DateTimeRange(start: DateTime.now(), end: DateTime.now()),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime.now(),
        helpText: translation(context).selectDateValue,
        daysRange:widget.daysRange,
        onSelectStartEndDate: (DateTimeRange onSelectStartEndDate) {
          String startDate =
              DateFormat(widget.dateFormat).format(onSelectStartEndDate.start);
          String endDate =
              DateFormat(widget.dateFormat).format(onSelectStartEndDate.end);
          print("#### ${startDate} ### ${endDate}");
          widget.onDateRangeSelected("${startDate}", "${endDate}");
          widget.startDateEditController?.text = startDate;
          widget.endDateEditController?.text = endDate;
        },
      );
      /* if (selectedDate != null) {
        initialSelectedDate = selectedDate;
        List<String> splitDate =
            selectedDate.toString().split(" ")[0].split("-");
        controller.dobTextEditController.text =
            "${splitDate[2]}/${splitDate[1]}/${splitDate[0]}";
        widget.singleDateEditController?.text =
            "${splitDate[2]}/${splitDate[1]}/${splitDate[0]}";
      }*/
    } else if (widget.calendarType ==
        AppConstants.singleSelectionCalenderType) {
      await showCustomDatePicker(
        context: context,
        initialDate: widget.initialDateSelection ?? DateTime.now(),
        firstDate: widget.calendarStartDate /*??DateTime(1950, 1)*/,
        lastDate: widget.calendarEndDate /*DateTime.now()*/,
        helpText: translation(context).selectDateValue,
        daysRange:widget.daysRange,
        disableDate:widget.disableDate,
        onSelectedDate: (DateTime onSelectedDate) {
          print("#### ${onSelectedDate}");
          String convertedDate =
              DateFormat(widget.dateFormat).format(onSelectedDate);
          widget.onDateSelected(convertedDate);
          widget.singleDateEditController?.text = convertedDate;
        },
      );
      /* if (selectedDate != null) {
        initialSelectedDate = selectedDate;
        List<String> splitDate =
            selectedDate.toString().split(" ")[0].split("-");
        controller.dobTextEditController.text =
            "${splitDate[2]}/${splitDate[1]}/${splitDate[0]}";
        widget.singleDateEditController?.text =
            "${splitDate[2]}/${splitDate[1]}/${splitDate[0]}";
        widget.onDateSelected!(selectedDate.toString());
      }*/
      /* final DateTime? newDate = await showCustomDatePicker(
        context: context,
        initialDate:initialSelectedDate,
        firstDate: DateTime(1950, 1),
        lastDate: DateTime.now(),
        helpText: 'Select date',

      );
      if(newDate!=null) {
        initialSelectedDate = newDate!;
        List<String> splitDate = newDate.toString().split(" ")[0].split("-");
        widget.onDateSelected!(newDate.toString(), widget.dropDownType);
        textEditingController.text =
        "${splitDate[2]}/${splitDate[1]}/${splitDate[0]}";
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    variableTextMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    final OutlineInputBorder enabledOutlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(4 * variablePixelMultiplier)),
      borderSide: BorderSide(color: AppColors.dividerColor),
    );

    final OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(4 * variablePixelMultiplier)),
      borderSide: BorderSide(color: AppColors.dividerColor),
    );

    var textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
        //  padding: widget.height!=null?EdgeInsets.only(top: 14*variablePixelHeight):EdgeInsets.all(0),
        // height:widget.height??50*variablePixelHeight,
        child: (widget.calendarType == AppConstants.singleSelectionCalenderType)
            ? TextFormField(
                readOnly: true,
                onTap: _handleTap,
                style: GoogleFonts.poppins(
                  fontSize: 14 * variableTextMultiplier,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.50,
                ),
                controller: widget.singleDateEditController,
                decoration: InputDecoration(
                  errorText:
                      widget.errorText!.isNotEmpty ? widget.errorText : null,
                  label: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.labelText,
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.40,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: GoogleFonts.poppins(
                            color: AppColors.errorRed,
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: widget.hintText,
                  suffixIcon: widget.icon,
                  focusedBorder: focusedOutlineInputBorder,
                  enabledBorder: enabledOutlineInputBorder,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  floatingLabelStyle: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontStyle: FontStyle.normal,
                      fontSize: 14 * variableTextMultiplier,
                      fontWeight: FontWeight.w400),
                  hintStyle: GoogleFonts.poppins(
                    color: AppColors.hintColor,
                    fontSize: 14 * variableTextMultiplier,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: 0.15,
                    letterSpacing: 0.50,
                  ),
                  labelStyle: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 14 * variableTextMultiplier,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 0.15,
                    letterSpacing: 0.50,
                  ),
                ),
              )
            : GestureDetector(
                onTap: _handleTap,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50 * variablePixelHeight,
                          child: TextFormField(
                            readOnly: true,
                            enabled: false,
                            controller: widget.startDateEditController,
                            style: GoogleFonts.poppins(
                              color: (widget
                                      .startDateEditController!.text.isNotEmpty)
                                  ? AppColors.black
                                  : AppColors.calendarHintColor,
                              fontSize: 14 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: translation(context).from,
                              hintText: "DD/MM/YYYY",
                              suffixIcon: widget.icon,
                              contentPadding: EdgeInsets.only(
                                  left: 15 * variablePixelWidth,
                                  top: 20 * variablePixelHeight),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    4.0 * variablePixelMultiplier)),
                                borderSide: BorderSide(
                                    color: AppColors.lumiBluePrimary),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    4.0 * variablePixelMultiplier)),
                                borderSide:
                                    BorderSide(color: AppColors.dividerColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    4.0 * variablePixelMultiplier)),
                                borderSide:
                                    BorderSide(color: AppColors.dividerColor),
                              ),
                              labelStyle: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 14 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                height: 0.11,
                                letterSpacing: 0.40,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: GoogleFonts.poppins(
                                color: AppColors.calendarHintColor,
                                fontSize: 14 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                // height: 0.12,
                                letterSpacing: 0.50,
                              ),
                              // prefixStyle: customPrefixStyle,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16 * variablePixelWidth,
                      ),
                      Expanded(
                        child: Container(
                          height: 50 * variablePixelHeight,
                          child: TextFormField(
                            readOnly: true,
                            enabled: false,
                            controller: widget.endDateEditController,
                            style: GoogleFonts.poppins(
                              color: (widget
                                      .endDateEditController!.text.isNotEmpty)
                                  ? AppColors.black
                                  : AppColors.calendarHintColor,
                              fontSize: 14 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: translation(context).to,
                              hintText: "DD/MM/YYYY",
                              suffixIcon: widget.icon,
                              contentPadding: EdgeInsets.only(
                                  left: 15 * variablePixelWidth,
                                  top: 20 * variablePixelHeight),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    4.0 * variablePixelMultiplier)),
                                borderSide: BorderSide(
                                    color: AppColors.lumiBluePrimary),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    4.0 * variablePixelMultiplier)),
                                borderSide:
                                    BorderSide(color: AppColors.dividerColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    4.0 * variablePixelMultiplier)),
                                borderSide:
                                    BorderSide(color: AppColors.dividerColor),
                              ),
                              labelStyle: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 14 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                height: 0.11,
                                letterSpacing: 0.40,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: GoogleFonts.poppins(
                                color: AppColors.calendarHintColor,
                                fontSize: 14 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                // height: 0.12,
                                letterSpacing: 0.50,
                              ),
                              // prefixStyle: customPrefixStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
