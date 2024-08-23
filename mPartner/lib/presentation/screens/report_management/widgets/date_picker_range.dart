import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class DatePickerRangeWidget extends StatefulWidget {
  final Function(DateTime, DateTime) onDateRangeSelected;

  DatePickerRangeWidget({Key? key, required this.onDateRangeSelected})
      : super(key: key);

  @override
  _DatePickerRangeWidgetState createState() => _DatePickerRangeWidgetState();
}

class _DatePickerRangeWidgetState extends State<DatePickerRangeWidget> {
  late DateTime startDate;
  late DateTime endDate;
  late DateTime initialStartDate;
  late DateTime initialEndDate;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().subtract(Duration(days: 6));
    endDate = DateTime.now();
    initialStartDate = DateTime(2000, 1, 1);
    initialEndDate = DateTime(2050, 1, 1);

    startDateController.text = "";
    endDateController.text = "";
  }

  void _confirmDateRange() {
    widget.onDateRangeSelected(startDate, endDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    int monthsDifference = (initialEndDate.year - initialStartDate.year) * 12 +
        initialEndDate.month -
        initialStartDate.month;

    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme:
            const ColorScheme.light(primary: AppColors.lumiBluePrimary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28 * variablePixelWidth),
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close)),
          ),
          VerticalSpace(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 28*variablePixelHeight),
                  height: 50 * variablePixelHeight,
                  child: TextField(
                    readOnly: true,
                    controller: startDateController,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * f,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      labelText: translation(context).from,
                      hintText: "DD/MM/YYYY",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.0 * variablePixelMultiplier)),
                        borderSide: const BorderSide(
                            color: AppColors.lumiBluePrimary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.0 * variablePixelMultiplier)),
                        borderSide:
                            const BorderSide(color: AppColors.dividerColor),
                      ),
                      labelStyle: GoogleFonts.poppins(
                        color: startDateController.text.isEmpty
                            ? AppColors.darkGreyText
                            : AppColors.lumiBluePrimary,
                        fontSize: 12 * f,
                        fontWeight: FontWeight.w400,
                        height: 0.11 * variablePixelHeight,
                        letterSpacing: 0.40 * variablePixelWidth,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14 * f,
                        fontWeight: FontWeight.w500,
                        height: 0.12 * variablePixelHeight,
                        letterSpacing: 0.50 * variablePixelWidth,
                      ),
                      // prefixStyle: customPrefixStyle,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16*variablePixelWidth,),
              Expanded(
                child: Container(
                  padding:
                  EdgeInsets.only(right: 28 * variablePixelWidth),
                  height: 50 * variablePixelHeight,
                  child: TextField(
                    readOnly: true,
                    controller: endDateController,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * f,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      labelText: translation(context).to,
                      hintText: "DD/MM/YYYY",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.0 * variablePixelMultiplier)),
                        borderSide: const BorderSide(
                            color: AppColors.lumiBluePrimary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.0 * variablePixelMultiplier)),
                        borderSide:
                            const BorderSide(color: AppColors.dividerColor),
                      ),
                      labelStyle: GoogleFonts.poppins(
                        color: endDateController.text.isEmpty
                            ? AppColors.darkGreyText
                            : AppColors.lumiBluePrimary,
                        fontSize: 12 * f,
                        fontWeight: FontWeight.w400,
                        height: 0.11 * variablePixelHeight,
                        letterSpacing: 0.40 * variablePixelWidth,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14 * f,
                        fontWeight: FontWeight.w500,
                        height: 0.12 * variablePixelHeight,
                        letterSpacing: 0.50 * variablePixelWidth,
                      ),
                      // prefixStyle: customPrefixStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
          VerticalSpace(height: 10),
         /* Container(
            padding: EdgeInsets.symmetric(horizontal: 24 * variablePixelWidth),
            height: 350 * variablePixelHeight,
            width: double.infinity,
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              navigationDirection: DateRangePickerNavigationDirection.vertical,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  DateTime? newStartDate = args.value.startDate;
                  DateTime? newEndDate = args.value.endDate;
                  if (newStartDate == null || newEndDate == null) {
                    return; // Handle the case where no date range is selected
                  }
                  if (newStartDate.isBefore(initialStartDate) ||
                      newEndDate.isAfter(initialEndDate)) {
                    setState(() {
                      startDate = initialStartDate;
                      endDate = initialEndDate;
                      startDateController.text =
                          DateFormat('dd/MM/yyyy').format(startDate);
                      endDateController.text =
                          DateFormat('dd/MM/yyyy').format(endDate);
                    });
                  } 
                  else {
                    setState(() {
                      startDate = newStartDate;
                      endDate = newEndDate;
                      startDateController.text =
                          DateFormat('dd/MM/yyyy').format(startDate);
                      endDateController.text =
                          DateFormat('dd/MM/yyyy').format(endDate);
                    });
                  }
                }
              },
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: null,
              minDate: initialStartDate,
              maxDate: DateTime.now(),
              monthViewSettings: DateRangePickerMonthViewSettings(
                showTrailingAndLeadingDates: false,
                enableSwipeSelection: false,
              ),
            ),
          ),*/
          VerticalSpace(height: 10),
          Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _confirmDateRange,
                child: Text('Confirm'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
