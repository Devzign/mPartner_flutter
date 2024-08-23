import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../state/contoller/product_list_controller.dart';
import '../../../../../state/contoller/report_download_for_dealer_controller.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

class SelectDateStatusFilterWidget extends StatefulWidget {
  String name, id, address, totalProducts, productTypesString;
  Map<String, dynamic> productsList;
  final void Function(String) dateRangeSelected;

  SelectDateStatusFilterWidget(
      {Key? key,
      required this.id,
      required this.productTypesString,
      required this.productsList,
      required this.name,
      required this.address,
      required this.totalProducts,
      required this.dateRangeSelected});

  @override
  State<SelectDateStatusFilterWidget> createState() =>
      _SelectDateFilterWidgetState();
}

class _SelectDateFilterWidgetState extends State<SelectDateStatusFilterWidget> {
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;
  String startDate = "";
  String endDate = "";
  String fromDate = "";
  String toDate = "";
  String selectedStatuses = "";
  int? selectedRadio = 0;
  ProductListController productListController = Get.find();
  UserDataController userDataController = Get.find();
  String dateRange = "";
  SecondaryReportDealerDownloadController
      secondaryReportDealerDownloadController = Get.find();
  String statusFilter = "";

  @override
  void initState() {
    super.initState();
    if (productListController.selectedDateStatusMap['dateSelected'] == "MTD") {
      selectedRadio = 0;
    } else if (productListController.selectedDateStatusMap['dateSelected'] ==
        "QTD") {
      selectedRadio = 1;
    } else if (productListController.selectedDateStatusMap['dateSelected'] ==
        "Custom") {
      selectedRadio = 2;
      startDate = productListController.selectedDateStatusMap['fromDate'] ?? "";
      endDate = productListController.selectedDateStatusMap['toDate'] ?? "";
    } else
      selectedRadio = null;
    statusFilter = productListController.selectedDateStatusMap['status'] ?? "";
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
        const VerticalSpace(height: 8),
        buildStatusCheckbox(translation(context).accepted),
        buildStatusCheckbox(translation(context).pending),
        buildStatusCheckbox(translation(context).rejected),
        Text(
          translation(context).secondaryDateRange,
          style: GoogleFonts.poppins(
            color: AppColors.darkText2,
            fontSize: 16 * f,
            fontWeight: FontWeight.w500,
          ),
        ),
        const VerticalSpace(height: 8),
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
            icon: const Icon(
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
                secondaryReportDealerDownloadController.startDateController,
            endDateEditController:
                secondaryReportDealerDownloadController.endDateController,
            onDateSelected: (selectedDate) {
              print("view1 ${selectedDate}");
            },
            onDateRangeSelected: (startDateVal, endDateVal) {
              print("view2 ${startDateVal} - ${endDateVal}");
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
        const VerticalSpace(height: 12),
        Row(children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                setState(() {
                  selectedRadio = null;
                  productListController.selectedDateStatusMap['dateSelected'] =
                      "";
                  productListController.selectedDateStatusMap['status'] = "";
                  productListController.selectedDateStatusMap['fromDate'] = "";
                  productListController.selectedDateStatusMap['toDate'] = "";
                  widget.dateRangeSelected(dateRange);
                  secondaryReportDealerDownloadController
                      .fetchSecondaryReportForDealer(widget.id,
                          disID: userDataController.sapId,
                          products: widget.productTypesString,
                          status:
                              productListController
                                      .selectedDateStatusMap['status'] ??
                                  "",
                          fromDate: productListController
                                  .selectedDateStatusMap['fromDate'] ??
                              "",
                          toDate: productListController
                                  .selectedDateStatusMap['toDate'] ??
                              "");
                  productListController.fetchProductListDetails(widget.id,
                      distributorCode: userDataController.sapId,
                      productType: widget.productTypesString,
                      status: productListController
                              .selectedDateStatusMap['status'] ??
                          "",
                      fromDate: productListController
                              .selectedDateStatusMap['fromDate'] ??
                          "",
                      toDate: productListController
                              .selectedDateStatusMap['toDate'] ??
                          "");
                  Navigator.pop(context);
                });
              },
              backGroundColor: AppColors.lightWhite1,
              textColor: selectedRadio != null ||
                      productListController.selectedDateStatusMap['status'] !=
                          null ||
                      productListController.selectedDateStatusMap['status'] !=
                          ""
                  ? AppColors.lumiBluePrimary
                  : AppColors.grayText,
              isEnabled: true,
              buttonText: translation(context).reset,
              containerBackgroundColor: AppColors.lightWhite1,
              containerHeight: 48 * h,
              withContainer: false,
            ),
          ),
          const HorizontalSpace(width: 8),
          Expanded(
            child: CommonButton(
              onPressed: () {
                if (selectedRadio == 0) {
                  setMTDDates();
                } else if (selectedRadio == 1) {
                  setQTDDates();
                } else if (selectedRadio == 2) {
                  setCustomDates();
                }
                productListController.selectedDateStatusMap['status'] =
                    statusFilter;
                widget.dateRangeSelected(dateRange);
                secondaryReportDealerDownloadController
                    .fetchSecondaryReportForDealer(widget.id,
                        disID: userDataController.sapId,
                        products: widget.productTypesString,
                        status: productListController
                                .selectedDateStatusMap['status'] ??
                            "",
                        fromDate: productListController
                                .selectedDateStatusMap['fromDate'] ??
                            "",
                        toDate: productListController
                                .selectedDateStatusMap['toDate'] ??
                            "");
                productListController.fetchProductListDetails(widget.id,
                    distributorCode: userDataController.sapId,
                    productType: widget.productTypesString,
                    status:
                        productListController.selectedDateStatusMap['status'] ??
                            "",
                    fromDate: productListController
                            .selectedDateStatusMap['fromDate'] ??
                        "",
                    toDate:
                        productListController.selectedDateStatusMap['toDate'] ??
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
        const VerticalSpace(height: 12),
      ],
    );
  }

  void setMTDDates() {
    DateTime now = DateTime.now();
    fromDate =
        DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));
    toDate = DateFormat('dd/MM/yyyy').format(now);
    startDate = fromDate;
    endDate = toDate;
    dateRange = "MTD";
    productListController.selectedDateStatusMap['dateSelected'] = "MTD";
    productListController.selectedDateStatusMap['fromDate'] = fromDate;
    productListController.selectedDateStatusMap['toDate'] = toDate;
    secondaryReportDealerDownloadController.startDateController.text = "";
    secondaryReportDealerDownloadController.endDateController.text = "";
  }

  void setQTDDates() {
    DateTime now = DateTime.now();
    int quarter = (now.month / 3).ceil();
    fromDate = DateFormat('dd/MM/yyyy')
        .format(DateTime(now.year, (quarter - 1) * 3 + 1, 1));
    toDate = DateFormat('dd/MM/yyyy').format(now);
    startDate = fromDate;
    endDate = toDate;
    dateRange = "QTD";
    productListController.selectedDateStatusMap['dateSelected'] = "QTD";
    productListController.selectedDateStatusMap['fromDate'] = fromDate;
    productListController.selectedDateStatusMap['toDate'] = toDate;
    secondaryReportDealerDownloadController.startDateController.text = "";
    secondaryReportDealerDownloadController.endDateController.text = "";
  }

  void setCustomDates() {
    if (startDate != "" && endDate != "") {
      dateRange = "$startDate - $endDate";
      fromDate = startDate;
      toDate = endDate;
      productListController.selectedDateStatusMap['dateSelected'] = "Custom";
      productListController.selectedDateStatusMap['fromDate'] = startDate;
      productListController.selectedDateStatusMap['toDate'] = endDate;
    }
  }

  Widget buildStatusCheckbox(String status) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return GestureDetector(
      onTap: () {
        bool value = !(statusFilter?.contains(status) ?? false);
        setState(() {
          if (value) {
            statusFilter =
                (statusFilter ?? "") +
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
