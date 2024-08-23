import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../state/contoller/dealer_wise_summary_controller.dart';
import '../../../../../state/contoller/secondary_report_distributor_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

class SelectDateFilterWidget extends StatefulWidget {
  final void Function(String, String, String) dateRangeSelected;

  const SelectDateFilterWidget({Key? key, required this.dateRangeSelected});

  @override
  State<SelectDateFilterWidget> createState() => _SelectDateFilterWidget();
}

class _SelectDateFilterWidget extends State<SelectDateFilterWidget> {
  int? selectedRadio;
  DealerSummaryController dealerSummaryController = Get.find();
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;

  String startDate = "";
  String endDate = "";
  String dateRange = "";
  SecondaryReportDistrubutorController secondaryReportPdfDistributorController =
      Get.find();

  @override
  void initState() {
    super.initState();
    if (dealerSummaryController.selectedDateFilter.value == "MTD") {
      selectedRadio = 0;
    } else if (dealerSummaryController.selectedDateFilter.value == "QTD") {
      selectedRadio = 1;
    } else if (dealerSummaryController.selectedDateFilter.value == "Custom") {
      selectedRadio = 2;
      startDate = dealerSummaryController.from.value;
      endDate = dealerSummaryController.to.value;
    } else
      selectedRadio = null;
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation(context).date,
          style: GoogleFonts.poppins(
            color: AppColors.darkText2,
            fontSize: 16 * f,
            fontWeight: FontWeight.w500,
          ),
        ),
        VerticalSpace(height: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedRadio = 0;
                  //updateDates();
                });
              },
              child: Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: selectedRadio,
                    onChanged: (value) {
                      setState(() {
                        selectedRadio = value;
                        //updateDates();
                      });
                    },
                    activeColor: AppColors.lumiBluePrimary,
                  ),
                  Text("MTD"),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedRadio = 1;
                  //updateDates();
                });
              },
              child: Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    onChanged: (value) {
                      setState(() {
                        selectedRadio = value;
                        //updateDates();
                      });
                    },
                    activeColor: AppColors.lumiBluePrimary,
                  ),
                  Text("QTD"),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedRadio = 2;
                  startDate = "";
                  endDate = "";
                  //updateDates();
                });
              },
              child: Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    onChanged: (value) {
                      setState(() {
                        selectedRadio = value;
                        //updateDates();
                      });
                    },
                    activeColor: AppColors.lumiBluePrimary,
                  ),
                  Text(translation(context).custom),
                ],
              ),
            ),
          ],
        ),
        if (selectedRadio == 2)
          CustomCalendarView(
            labelText: translation(context).dob,
            hintText: translation(context).selectDateFormat,
            icon: Icon(
              Icons.calendar_month_outlined,
              color: AppColors.grey,
            ),
            calendarType: AppConstants.rangeSelectionCalenderType,
            dateFormat: "dd/MM/yyyy",
            errorText: "",
            daysRange: 180,
            calendarStartDate: DateTime(1950, 1, 1),
            calendarEndDate: DateTime.now(),
            startDateEditController:
                secondaryReportPdfDistributorController.startDateController,
            endDateEditController:
                secondaryReportPdfDistributorController.endDateController,
            onDateSelected: (selectedDate) {
              print("view1 ${selectedDate}");
            },
            onDateRangeSelected: (startDateVal, endDateVal) {
              print("view2 ${startDateVal}- ${endDateVal}");
              var inputFormat = DateFormat('dd/MM/yyyy');
              var startDateObject =
                  inputFormat.parse(startDateVal); // <-- dd/MM 24H format
              var endDateObject =
                  inputFormat.parse(endDateVal); // <-- dd/MM 24H format

              setState(() {
                startDate = startDateVal;
                endDate = endDateVal;
                isStartDateSelected = true;
                isEndDateSelected = true;
              });
            },
          ),
        VerticalSpace(height: 12),
        Row(children: [
          Expanded(
            child: CommonButton(
              backGroundColor: AppColors.lightWhite1,
              textColor:
                  dealerSummaryController.selectedDateFilter.value.isNotEmpty
                      ? AppColors.lumiBluePrimary
                      : AppColors.grayText,
              onPressed: () {
                setState(() {
                  dealerSummaryController.selectedDateFilter.value = "";
                  dealerSummaryController.from.value = "";
                  dealerSummaryController.to.value = "";
                  widget.dateRangeSelected(
                      "",
                      dealerSummaryController.from.value,
                      dealerSummaryController.to.value);
                  secondaryReportPdfDistributorController
                      .fetchSecondaryReportPdfDistributor(
                          fromDate: dealerSummaryController.from.value,
                          toDate: dealerSummaryController.to.value);
                  dealerSummaryController
                      .fetchSecondaryReportSummaryDistributor(
                          fromDate: dealerSummaryController.from.value,
                          toDate: dealerSummaryController.to.value);
                  selectedRadio = null;
                  Navigator.pop(context);
                });
              },
              isEnabled: true,
              buttonText: translation(context).reset,
              containerBackgroundColor: AppColors.lightWhite1,
              containerHeight: 48 * h,
              withContainer: false,
            ),
          ),
          HorizontalSpace(width: 8),
          Expanded(
            child: CommonButton(
              onPressed: () {
                updateDates();
                dealerSummaryController.fetchSecondaryReportSummaryDistributor(
                    fromDate: dealerSummaryController.from.value,
                    toDate: dealerSummaryController.to.value);
                secondaryReportPdfDistributorController
                    .fetchSecondaryReportPdfDistributor(
                        fromDate: dealerSummaryController.from.value,
                        toDate: dealerSummaryController.to.value);
                widget.dateRangeSelected(
                    dateRange,
                    dealerSummaryController.from.value,
                    dealerSummaryController.to.value);
                Navigator.pop(context);
              },
              isEnabled:
                  dealerSummaryController.selectedDateFilter.value.isNotEmpty,
              buttonText: translation(context).submit,
              containerBackgroundColor: AppColors.lightWhite1,
              containerHeight: 48 * h,
              withContainer: false,
            ),
          )
        ]),
        VerticalSpace(height: 12),
      ],
    );
  }

  void updateDates() {
    if (selectedRadio == 0) {
      startDate = DateFormat('01/MM/yyyy').format(DateTime.now());
      endDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      dateRange = "MTD";
      dealerSummaryController.selectedDateFilter.value = "MTD";
      dealerSummaryController.from.value = startDate;
      dealerSummaryController.to.value = endDate;
      secondaryReportPdfDistributorController.startDateController.text = "";
      secondaryReportPdfDistributorController.endDateController.text = "";
    } else if (selectedRadio == 1) {
      DateTime now = DateTime.now();
      DateTime startOfQuarter =
          DateTime(now.year, (now.month - 1) ~/ 3 * 3 + 1, 1);
      startDate = DateFormat('01/MM/yyyy').format(startOfQuarter);
      dateRange = "QTD";
      endDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      dealerSummaryController.selectedDateFilter.value = "QTD";
      dealerSummaryController.from.value = startDate;
      dealerSummaryController.to.value = endDate;
      secondaryReportPdfDistributorController.startDateController.text = "";
      secondaryReportPdfDistributorController.endDateController.text = "";
    } else if (selectedRadio == 2) {
      if (startDate != "" && endDate != "") {
        dateRange = "${startDate} - ${endDate}";
        dealerSummaryController.selectedDateFilter.value = "Custom";
        dealerSummaryController.from.value = startDate;
        dealerSummaryController.to.value = endDate;
      } else {
        dateRange = dealerSummaryController.selectedDateFilter.value;
      }
    }
  }
}
