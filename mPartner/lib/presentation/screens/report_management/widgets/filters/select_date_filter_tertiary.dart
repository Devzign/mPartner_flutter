import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../state/contoller/customer_wise_list_controller.dart';
import '../../../../../state/contoller/dealer_wise_summary_controller.dart';
import '../../../../../state/contoller/tertiary_report_summary_controller.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/utils.dart';
import '../../../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../date_picker_range.dart';
import '../dropdown_button.dart';

class SelectDateFilterTertiaryWidget extends StatefulWidget {
  final void Function(String) dateRangeSelected;
  const SelectDateFilterTertiaryWidget(
      {Key? key, required this.dateRangeSelected});

  @override
  State<SelectDateFilterTertiaryWidget> createState() =>
      _SelectDateFilterTertiaryWidget();
}

class _SelectDateFilterTertiaryWidget
    extends State<SelectDateFilterTertiaryWidget> {
  int? selectedRadio;
  CustomerWiseListController customerWiseListController = Get.find();
  UserDataController userDataController = Get.find();
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;
  String startDate = "DD/MM/YYYY";
  String endDate = "DD/MM/YYYY";
  String dateRange = "";
  TertiaryReportSummaryController tertiaryReportSummaryController = Get.find();
  bool isSubmitEnabled = false;

  @override
  void initState() {
    super.initState();
    if (customerWiseListController.selectedDateFilter.value == "MTD") {
      selectedRadio = 0;
      isSubmitEnabled = true;
    } else if (customerWiseListController.selectedDateFilter.value == "QTD") {
      selectedRadio = 1;
      isSubmitEnabled = true;
    } else if (customerWiseListController.selectedDateFilter.value ==
        "Custom") {
      selectedRadio = 2;
      startDate = customerWiseListController.from.value;
      endDate = customerWiseListController.to.value;
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
            calendarStartDate: DateTime(1950, 1,1) ,
            calendarEndDate: DateTime.now(),
            startDateEditController:
                tertiaryReportSummaryController.startDateController,
            endDateEditController:
                tertiaryReportSummaryController.endDateController,
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
              textColor: isSubmitEnabled ? AppColors.lumiBluePrimary : AppColors.grayText,
              onPressed: () {
                if(isSubmitEnabled){
                   setState(() async {
                  selectedRadio = null;
                  dateRange = "";
                  customerWiseListController.selectedDateFilter.value = "";
                  customerWiseListController.from.value = "";
                  customerWiseListController.to.value = "";
                  tertiaryReportSummaryController.startDateController.text = "";
                  tertiaryReportSummaryController.endDateController.text = "";
                  widget.dateRangeSelected(dateRange);
                  if (customerWiseListController.dataFromMilli.value > 0 || customerWiseListController.dataToMilli.value > 0) {
                    await customerWiseListController.fetchTertiaryReportSummary(
                      userDataController.sapId,
                      fromDate: customerWiseListController.from.value,
                      toDate: customerWiseListController.to.value);
                  } else {
                    customerWiseListController.applyFilter();
                  }
                  Navigator.pop(context);
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
                String fromFullDate = convertDateFormat(customerWiseListController.from.value);
                int fromDateMilli = getDateFromFullDate(fromFullDate);
                String toFullDate = convertDateFormat(customerWiseListController.to.value);
                int toDateMilli = getDateFromFullDate(toFullDate);

                if(fromDateMilli < customerWiseListController.dataFromMilli.value ||
                  toDateMilli > customerWiseListController.dataToMilli.value) {
                  customerWiseListController.fetchTertiaryReportSummary(
                    userDataController.sapId,
                    fromDate: customerWiseListController.from.value,
                    toDate: customerWiseListController.to.value);
                } else {
                  customerWiseListController.applyFilter();
                }
                Navigator.pop(context);
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
      customerWiseListController.selectedDateFilter.value = "MTD";
      customerWiseListController.from.value = startDate;
      customerWiseListController.to.value = endDate;
      tertiaryReportSummaryController.startDateController.text = "";
      tertiaryReportSummaryController.endDateController.text = "";
    } else if (selectedRadio == 1) {
      DateTime now = DateTime.now();
      DateTime startOfQuarter =
          DateTime(now.year, (now.month - 1) ~/ 3 * 3 + 1, 1);
      startDate = DateFormat('01/MM/yyyy').format(startOfQuarter);
      endDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      dateRange = "QTD";
      customerWiseListController.selectedDateFilter.value = "QTD";
      customerWiseListController.from.value = startDate;
      customerWiseListController.to.value = endDate;
      tertiaryReportSummaryController.startDateController.text = "";
      tertiaryReportSummaryController.endDateController.text = "";
    } else if (selectedRadio == 2) {
      if (startDate != "DD/MM/YYYY" && endDate != "DD/MM/YYYY") {
        dateRange = "${startDate} - ${endDate}";
        customerWiseListController.selectedDateFilter.value = "Custom";
        customerWiseListController.from.value = startDate;
        customerWiseListController.to.value = endDate;
      } else {
        dateRange = customerWiseListController.selectedDateFilter.value;
      }
    }
  }
}
