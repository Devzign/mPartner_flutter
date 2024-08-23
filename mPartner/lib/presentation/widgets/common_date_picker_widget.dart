import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../utils/localdata/language_constants.dart';

class CommonDatePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final int daysToEnable;

  CommonDatePickerWidget(
      {Key? key, required this.onDateSelected, this.daysToEnable = 0})
      : super(key: key);

  @override
  _CommonDatePickerWidgetState createState() => _CommonDatePickerWidgetState();
}

class _CommonDatePickerWidgetState extends State<CommonDatePickerWidget> {
  late DateTime selectedDate;
  late DateTime firstDate;
  late DateTime lastDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    firstDate = widget.daysToEnable != 0
        ? DateTime.now().subtract(Duration(days: widget.daysToEnable))
        : DateTime(2021);
    lastDate = widget.daysToEnable != 0 ? DateTime.now() : DateTime(2050);
  }

  void _confirmDate() {
    widget.onDateSelected(selectedDate);
    Navigator.of(context).pop(); // Close the date picker
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme:
            const ColorScheme.light(primary: AppColors.lumiBluePrimary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 24 * variablePixelMultiplier),
            alignment: Alignment.topLeft,
            child: Text(
              translation(context).selectDateFormat,
              style: GoogleFonts.poppins(
                color: AppColors.lumiBluePrimary,
                fontSize: 12 * variablePixelMultiplier,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(
            height: 16 * variablePixelHeight,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20 * variablePixelWidth),
            alignment: Alignment.topLeft,
            child: Text(
              DateFormat('EE, d MMM').format(selectedDate),
              style: GoogleFonts.poppins(
                color: AppColors.lumiBluePrimary,
                fontSize: 32 * variablePixelMultiplier,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: firstDate,
            lastDate: lastDate,
            onDateChanged: (newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                // Close the date picker without saving
                child: Text(translation(context).cancel),
              ),
              TextButton(
                onPressed: _confirmDate,
                child: Text(translation(context).confirm),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
