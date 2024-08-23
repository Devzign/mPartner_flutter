import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../../../state/contoller/tertiary_customer_wise_products_controller.dart';
import '../../../../../state/contoller/tertiary_product_wise_details_controller.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../userprofile/components/logout_widget.dart';
import '../../screens/secondary_report/distributor/secondary_report_product_detail_screen.dart';
import '../date_picker_range.dart';
import '../dropdown_button.dart';

class SelectDateStatusFilterTertiaryWidget extends StatefulWidget {
  String name, id, address, totalProducts, productTypesString;
  Map<String, dynamic> productsList;
  final void Function(String) dateRangeSelected;
  SelectDateStatusFilterTertiaryWidget(
      {Key? key,
      required this.id,
      required this.productTypesString,
      required this.productsList,
      required this.name,
      required this.address,
      required this.totalProducts,
      required this.dateRangeSelected});

  @override
  State<SelectDateStatusFilterTertiaryWidget> createState() =>
      _SelectDateFilterTertiaryWidgetState();
}

class _SelectDateFilterTertiaryWidgetState
    extends State<SelectDateStatusFilterTertiaryWidget> {
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;
  String startDate = "DD/MM/YYYY";
  String endDate = "DD/MM/YYYY";
  String fromDate = "";
  String toDate = "";
  String selectedStatuses = "";
  int? selectedRadio = 0;
  UserDataController userDataController = Get.find();
  TertiaryProductWiseDetails tertiaryProductWiseDetailsController = Get.find();
  TertiaryCustomerWiseProduct tertiaryCustomerWiseProductController =
      Get.find();
  String dateRange = "";
  String statusFilter = "";

  @override
  void initState() {
    super.initState();
    if (tertiaryProductWiseDetailsController
            .selectedDateStatusMap['dateSelected'] ==
        "MTD") {
      selectedRadio = 0;
    } else if (tertiaryProductWiseDetailsController
            .selectedDateStatusMap['dateSelected'] ==
        "QTD") {
      selectedRadio = 1;
    } else if (tertiaryProductWiseDetailsController
            .selectedDateStatusMap['dateSelected'] ==
        "Custom") {
      selectedRadio = 2;
      startDate = tertiaryProductWiseDetailsController
              .selectedDateStatusMap['fromDate'] ??
          "";
      endDate = tertiaryProductWiseDetailsController
              .selectedDateStatusMap['toDate'] ??
          "";
    } else
      selectedRadio = null;
    statusFilter =
        tertiaryProductWiseDetailsController.selectedDateStatusMap['status'] ??
            "";
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation(context).status,
          style: GoogleFonts.poppins(
            color: AppColors.darkText2,
            fontSize: 16 * f,
            fontWeight: FontWeight.w500,
          ),
        ),
        VerticalSpace(height: 8),
        buildStatusCheckbox(translation(context).accepted),
        buildStatusCheckbox(translation(context).pending),
        buildStatusCheckbox(translation(context).rejected),
        Text(
          translation(context).tertiaryDateRange,
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
            buildRadioButton(0, "MTD"),
            buildRadioButton(1, "QTD"),
            buildRadioButton(2, translation(context).custom),
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
                tertiaryProductWiseDetailsController.startDateController,
            endDateEditController:
                tertiaryProductWiseDetailsController.endDateController,
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
                fromDate = startDateVal;
                toDate = endDateVal;
                isStartDateSelected = true;
                isEndDateSelected = true;
                tertiaryProductWiseDetailsController
                    .selectedDateStatusMap['fromDate'] = fromDate;
                tertiaryProductWiseDetailsController
                    .selectedDateStatusMap['toDate'] = toDate;
              });
            },
          ),
        VerticalSpace(height: 12),
        Row(children: [
          Expanded(
            child: CommonButton(
              onPressed: () async{
                    selectedRadio = null;
                    statusFilter = "";
                    dateRange = "";
                    tertiaryProductWiseDetailsController
                        .selectedDateStatusMap['status'] = "";
                    tertiaryProductWiseDetailsController
                        .selectedDateStatusMap['dateSelected'] = "";
                    tertiaryProductWiseDetailsController
                        .selectedDateStatusMap['fromDate'] = "";
                    tertiaryProductWiseDetailsController
                        .selectedDateStatusMap['toDate'] = "";
                    widget.dateRangeSelected(dateRange);
                    await tertiaryProductWiseDetailsController
                        .fetchTertiaryCustomerWiseProductsSummary(widget.id,
                            disId: userDataController.sapId,
                            productType: widget.productTypesString,
                            status: tertiaryProductWiseDetailsController
                                    .selectedDateStatusMap['status'] ??
                                "",
                            fromDate: tertiaryProductWiseDetailsController
                                    .selectedDateStatusMap['fromDate'] ??
                                "",
                            toDate: tertiaryProductWiseDetailsController
                                    .selectedDateStatusMap['toDate'] ??
                                "");

                    Navigator.pop(context);
              },
              isEnabled: true,
              buttonText: translation(context).reset,
              containerBackgroundColor: AppColors.lightWhite1,
              containerHeight: 48 * h,
              withContainer: false,
              backGroundColor: AppColors.lightWhite1,
              textColor: selectedRadio != null || statusFilter != ""
                  ? AppColors.lumiBluePrimary
                  : AppColors.darkGreyText,
            ),
          ),
          HorizontalSpace(width: 8),
          Expanded(
            child: CommonButton(
              onPressed: () async {
                if (selectedRadio == 0) {
                  await setMTDDates();
                } else if (selectedRadio == 1) {
                  await setQTDDates();
                } else if (selectedRadio == 2) {
                  await setCustomDates();
                }
                tertiaryProductWiseDetailsController
                    .selectedDateStatusMap['status'] = statusFilter;
                widget.dateRangeSelected(dateRange);
                await tertiaryProductWiseDetailsController
                    .fetchTertiaryCustomerWiseProductsSummary(widget.id,
                        disId: userDataController.sapId,
                        productType: widget.productTypesString,
                        status: tertiaryProductWiseDetailsController
                                .selectedDateStatusMap['status'] ??
                            "",
                        fromDate: tertiaryProductWiseDetailsController
                                .selectedDateStatusMap['fromDate'] ??
                            "",
                        toDate: tertiaryProductWiseDetailsController
                                .selectedDateStatusMap['toDate'] ??
                            "");

                Navigator.pop(context);
              },
              isEnabled: selectedRadio != null || statusFilter != "",
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

  Future<void> setMTDDates() async {
    DateTime now = DateTime.now();
    fromDate =
        DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));
    toDate = DateFormat('dd/MM/yyyy').format(now);
    startDate = fromDate;
    endDate = toDate;
    dateRange = "MTD";
    tertiaryProductWiseDetailsController.selectedDateStatusMap['dateSelected'] =
        "MTD";
    tertiaryProductWiseDetailsController.selectedDateStatusMap['fromDate'] =
        fromDate;
    tertiaryProductWiseDetailsController.selectedDateStatusMap['toDate'] =
        toDate;
  }

  Future<void> setQTDDates() async {
    DateTime now = DateTime.now();
    int quarter = (now.month / 3).ceil();
    fromDate = DateFormat('dd/MM/yyyy')
        .format(DateTime(now.year, (quarter - 1) * 3 + 1, 1));
    toDate = DateFormat('dd/MM/yyyy').format(now);
    startDate = fromDate;
    endDate = toDate;
    dateRange = "QTD";
    tertiaryProductWiseDetailsController.selectedDateStatusMap['dateSelected'] =
        "QTD";
    tertiaryProductWiseDetailsController.selectedDateStatusMap['fromDate'] =
        fromDate;
    tertiaryProductWiseDetailsController.selectedDateStatusMap['toDate'] =
        toDate;
  }

  Future<void> setCustomDates() async {
    if (fromDate != "" && toDate != "") {
      dateRange = "$fromDate - $toDate";
    }
    tertiaryProductWiseDetailsController.selectedDateStatusMap['dateSelected'] =
        "Custom";
  }

  Widget buildStatusCheckbox(String status) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return GestureDetector(
      onTap: () {
        setState(() {
          bool value = !(statusFilter?.contains(status) ?? false);
          if (value) {
            statusFilter = (statusFilter ??
                    "") +
                (statusFilter?.isNotEmpty ??
                        false
                    ? ','
                    : '') +
                status;
          } else {
            statusFilter = statusFilter
                    ?.split(',')
                    ?.where((s) => s != status)
                    ?.join(',') ??
                "";
          }
        });
      },
      child: Row(
        children: [
          Checkbox(
            tristate: false,
            value: statusFilter?.contains(status) ?? false,
            onChanged: (bool? value) {
              setState(() {
                if (value != null) {
                  if (value) {
                    statusFilter = (statusFilter ??
                            "") +
                        (statusFilter
                                    ?.isNotEmpty ??
                                false
                            ? ','
                            : '') +
                        status;
                  } else {
                    statusFilter = statusFilter
                            ?.split(',')
                            ?.where((s) => s != status)
                            ?.join(',') ??
                        "";
                  }
                }
              });
            },
            activeColor: AppColors.lumiBluePrimary,
          ),
          Text(
            status,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 16 * f,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRadioButton(int value, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRadio = value;
        });
      },
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: selectedRadio,
            onChanged: (int? selected) {
              setState(() {
                selectedRadio = selected;
              });
            },
            activeColor: AppColors.lumiBluePrimary,
          ),
          Text(label),
        ],
      ),
    );
  }
}
