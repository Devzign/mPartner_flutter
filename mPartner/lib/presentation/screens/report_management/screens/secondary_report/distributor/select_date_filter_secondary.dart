import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../../state/contoller/secondary_report_distributor_controller.dart';
import '../../../../../../state/contoller/user_data_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../../widgets/common_button.dart';
import '../../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../../widgets/verticalspace/vertical_space.dart';

class SelectDateFilterSecondaryWidget extends StatefulWidget {
  final void Function(String) dateRangeSelected;

  const SelectDateFilterSecondaryWidget(
      {Key? key, required this.dateRangeSelected});

  @override
  State<SelectDateFilterSecondaryWidget> createState() =>
      _SelectDateFilterSecondaryWidgetWidget();
}

class _SelectDateFilterSecondaryWidgetWidget
    extends State<SelectDateFilterSecondaryWidget> {
  int? selectedRadio;
  SecondaryReportDistrubutorController dealerWiseListController = Get.find();
  UserDataController userDataController = Get.find();
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;
  String startDate = "DD/MM/YYYY";
  String endDate = "DD/MM/YYYY";
  String dateRange = "";
  bool isSubmitEnabled = false;

  @override
  void initState() {
    super.initState();
    if (dealerWiseListController.selectedDateFilter.value == "MTD") {
      selectedRadio = 0;
      isSubmitEnabled = true;
    } else if (dealerWiseListController.selectedDateFilter.value == "QTD") {
      selectedRadio = 1;
      isSubmitEnabled = true;
    } else if (dealerWiseListController.selectedDateFilter.value == "Custom") {
      selectedRadio = 2;
      startDate = dealerWiseListController.from.value;
      endDate = dealerWiseListController.to.value;
      isSubmitEnabled = true;
    } else {
      selectedRadio = null;
      isSubmitEnabled = false;
    }
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
                  isSubmitEnabled = true;
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
                        isSubmitEnabled = true;
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
                  isSubmitEnabled = true;
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
                        isSubmitEnabled = true;
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
                  isSubmitEnabled = true;
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
                        isSubmitEnabled = true;
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
                dealerWiseListController.startDateController,
            endDateEditController: dealerWiseListController.endDateController,
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
              textColor: isSubmitEnabled
                  ? AppColors.lumiBluePrimary
                  : AppColors.grayText,
              onPressed: () {
                if (isSubmitEnabled) {
                  setState(() async {
                    selectedRadio = null;
                    dateRange = "";
                    dealerWiseListController.selectedDateFilter.value = "";
                    dealerWiseListController.from.value = "";
                    dealerWiseListController.to.value = "";
                    dealerWiseListController.startDateController.text = "";
                    dealerWiseListController.endDateController.text = "";
                    widget.dateRangeSelected(dateRange);
                    Navigator.pop(context);
                    await dealerWiseListController
                        .fetchSecondaryReportSummaryDistributor(
                            fromDate: dealerWiseListController.from.value,
                            toDate: dealerWiseListController.to.value);
                    await dealerWiseListController
                        .fetchSecondaryReportPdfDistributor(
                            fromDate: dealerWiseListController.from.value,
                            toDate: dealerWiseListController.to.value);

                  });
                }
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
              onPressed: () async {
                updateDates();
                widget.dateRangeSelected(dateRange);
                Navigator.pop(context);
                if (dealerWiseListController.oldStartDateInMillis == 0) {
                  dealerWiseListController.oldStartDateInMillis = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day - 180)
                      .millisecondsSinceEpoch;
                  dealerWiseListController.oldEndDateInMillis =
                      DateTime.now().millisecondsSinceEpoch;
                }
                String toFullDate =
                    convertDateFormat(dealerWiseListController.to.value);
                String fromFullDate =
                    convertDateFormat(dealerWiseListController.from.value);
                int toDateMilli = getDateFromFullDate(toFullDate);
                int fromDateMilli = getDateFromFullDate(fromFullDate);
                if (fromDateMilli >=
                        dealerWiseListController.oldStartDateInMillis &&
                    fromDateMilli <=
                        dealerWiseListController.oldEndDateInMillis &&
                    toDateMilli >=
                        dealerWiseListController.oldStartDateInMillis &&
                    toDateMilli <= dealerWiseListController.oldEndDateInMillis) {
                  dealerWiseListController.applyFilter();
                  await dealerWiseListController
                      .fetchSecondaryReportPdfDistributor(
                          fromDate: dealerWiseListController.from.value,
                          toDate: dealerWiseListController.to.value);
                } else {
                  dealerWiseListController.oldStartDateInMillis = fromDateMilli;
                  dealerWiseListController.oldEndDateInMillis = toDateMilli;
                  await dealerWiseListController
                      .fetchSecondaryReportPdfDistributor(
                          fromDate: dealerWiseListController.from.value,
                          toDate: dealerWiseListController.to.value);
                  await dealerWiseListController
                      .fetchSecondaryReportSummaryDistributor(
                          fromDate: dealerWiseListController.from.value,
                          toDate: dealerWiseListController.to.value);
                }

              },
              isEnabled: isSubmitEnabled,
              buttonText: translation(context).submit,
              containerBackgroundColor: AppColors.lightWhite1,
              containerHeight: 48 * h,
              withContainer: false,
            ),
          ),
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
      dealerWiseListController.selectedDateFilter.value = "MTD";
      dealerWiseListController.from.value = startDate;
      dealerWiseListController.to.value = endDate;
      dealerWiseListController.startDateController.text = "";
      dealerWiseListController.endDateController.text = "";
    } else if (selectedRadio == 1) {
      DateTime now = DateTime.now();
      DateTime startOfQuarter =
          DateTime(now.year, (now.month - 1) ~/ 3 * 3 + 1, 1);
      startDate = DateFormat('01/MM/yyyy').format(startOfQuarter);
      endDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      dateRange = "QTD";
      dealerWiseListController.selectedDateFilter.value = "QTD";
      dealerWiseListController.from.value = startDate;
      dealerWiseListController.to.value = endDate;
      dealerWiseListController.startDateController.text = "";
      dealerWiseListController.endDateController.text = "";
    } else if (selectedRadio == 2) {
      if (startDate != "DD/MM/YYYY" && endDate != "DD/MM/YYYY") {
        dateRange = "${startDate} - ${endDate}";
        dealerWiseListController.selectedDateFilter.value = "Custom";
        dealerWiseListController.from.value = startDate;
        dealerWiseListController.to.value = endDate;
      } else {
        dateRange = dealerWiseListController.selectedDateFilter.value;
      }
    }
  }
}
