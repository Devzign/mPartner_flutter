import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../state/contoller/credit_debit_note_controller.dart';
import '../../../../../state/contoller/distributor_ledger_controller.dart';
import '../../../../../state/contoller/primary_billing_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/CommonCards/card_with_download_and_share.dart';
import '../../../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../widgets/headers/back_button_header_widget.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../base_screen.dart';
import '../../../userprofile/user_profile_widget.dart';
import '../../report_management_utils/report_management_utils.dart';
import '../../widgets/common_bottom_modal.dart';
import '../../widgets/date_picker_range.dart';
import '../../widgets/dropdown_button.dart';
import '../../widgets/primary_report_type.dart';
import '../../screens/primary_report/primary_report_screen.dart';
import '../../widgets/report_card.dart';

class PrimaryReportSubmit extends StatefulWidget {
  String reportType;
  String startDate;
  String endDate;
  PrimaryReportSubmit(
      {super.key,
      required this.reportType,
      required this.startDate,
      required this.endDate});

  @override
  State<PrimaryReportSubmit> createState() => _PrimaryReportSubmitState();
}

class _PrimaryReportSubmitState extends BaseScreenState<PrimaryReportSubmit> {
  get selectedReportType => null;
  PrimaryBillingReportController primaryBillingReportController = Get.find();
  DistributorLedgerController distributorLedgerController = Get.find();
  CreditDebitNoteController creditDebitNoteController = Get.find();
  TextEditingController startDateController=TextEditingController();
  TextEditingController endDateController=TextEditingController();
  void fetchData(PrimaryReportTypes type) {
    if (type == PrimaryReportTypes.primaryBillingReport) {
      primaryBillingReportController.fetchPrimaryBillingReport(
          fromDate: widget.startDate, toDate: widget.endDate);
    } else if (type == PrimaryReportTypes.customerLedgerReport) {
      distributorLedgerController.fetchDistributorLedgerReport(
          fromDate: widget.startDate, toDate: widget.endDate);
    } else if (type == PrimaryReportTypes.creditDebitNoteReport) {
      creditDebitNoteController.fetchCreditDebitNoteReport(
          fromDate: widget.startDate, toDate: widget.endDate);
    }
  }

  @override
  void initState() {
    super.initState();
    PrimaryReportTypes type = getReportTypeEnum(widget.reportType);
    startDateController.text=widget.startDate;
    endDateController.text=widget.endDate;
    fetchData(type);
  }

  Widget baseBody(BuildContext context) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return WillPopScope(
      onWillPop: () async {
        primaryBillingReportController.clearPrimaryBillingReport();
        distributorLedgerController.clearDistributorLedger();
        creditDebitNoteController.clearCreditDebitNote();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
            child: Column(
          children: [
            HeaderWidgetWithBackButton(
              heading:  translation(context).primaryReport,
              onPressed: () {
                primaryBillingReportController.clearPrimaryBillingReport();
                distributorLedgerController.clearDistributorLedger();
                creditDebitNoteController.clearCreditDebitNote();
                Navigator.pop(context);
              },
              icon: Icons.close,
            ),
            UserProfileWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * w),
              child: DropDownButtonWidget(
                labelText: translation(context).reportType,
                placeholdertext: widget.reportType,
                icon: Icons.keyboard_arrow_down_outlined,
                modalBody: CommonBottomModal(
                  modalLabelText: translation(context).selectReportType,
                  body: PrimaryReportType(
                    onReportTypeSelected: (reportType) {
                      // Navigator.of(context).pop();
                      _navigateToPrimaryReportWidget(reportType);
                    },
                  ),
                ),
                textColor: AppColors.titleColor,
              ),
            ),
            VerticalSpace(height: 14),
            Padding(
              padding: EdgeInsets.only(left: 24 * w, right: 24 * w),
              child: Container(
                child:  CustomCalendarView(
                  labelText:translation(context).startDate ,
                  hintText: translation(context).selectDateFormat,
                  icon: Icon(Icons.calendar_month_outlined,color: AppColors.grey,),
                  calendarType: AppConstants.rangeSelectionCalenderType,
                  dateFormat: "dd/MM/yyyy",
                  errorText: "",
                  daysRange:180,
                  calendarStartDate: DateTime(1950, 1,1) ,
                  calendarEndDate: DateTime.now(),
                  startDateEditController: startDateController,
                  endDateEditController: endDateController,
                  onDateSelected: (selectedDate){
                    print("view1 ${selectedDate}");
                  },
                  onDateRangeSelected: (startDateVal,endDateVal){
                    print("view2 ${startDateVal}- ${endDateVal}");
                    var inputFormat = DateFormat('dd/MM/yyyy');
                    var startDateObject = inputFormat.parse(startDateVal); // <-- dd/MM 24H format
                    var endDateObject = inputFormat.parse(endDateVal); // <-- dd/MM 24H format

                    setState(() {
                      widget.startDate =startDateVal;
                      widget.endDate =endDateVal;
                      PrimaryReportTypes type = getReportTypeEnum(widget.reportType);
                      fetchData(type);

                    });

                  },
                )/*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        child: DropDownButtonWidget(
                      labelText: translation(context).startDate,
                      placeholdertext: widget.startDate,
                      icon: Icons.calendar_month_outlined,
                      modalBody: DatePickerRangeWidget(
                          onDateRangeSelected: (value1, value2) {
                        setState(() {
                          widget.startDate =
                              DateFormat('dd/MM/yyyy').format(value1);
                          widget.endDate =
                              DateFormat('dd/MM/yyyy').format(value2);
                          PrimaryReportTypes type = getReportTypeEnum(widget.reportType);
                          fetchData(type);
                        });
                      }),
                      textColor: AppColors.titleColor,
                    )),
                    HorizontalSpace(width: 12),
                    Flexible(
                        child: DropDownButtonWidget(
                      labelText: translation(context).endDate,
                      placeholdertext: widget.endDate,
                      icon: Icons.calendar_month_outlined,
                      modalBody: DatePickerRangeWidget(
                          onDateRangeSelected: (value1, value2) {
                        setState(() {
                          widget.startDate =
                              DateFormat('dd/MM/yyyy').format(value1);
                          widget.endDate =
                              DateFormat('dd/MM/yyyy').format(value2);
                        });
                      }),
                      textColor: AppColors.titleColor,
                    ))
                  ],
                )*/
              ),
            ),
            VerticalSpace(height: 24),
            if (getReportTypeEnum(widget.reportType) ==
                PrimaryReportTypes.primaryBillingReport)
              Obx(() {
                if (primaryBillingReportController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (primaryBillingReportController.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Error: ${primaryBillingReportController.error.value}',
                      style: TextStyle(color: AppColors.errorRed),
                    ),
                  );
                } else {
                  final bool isDataEmpty =
                      primaryBillingReportController.pdfUrl.isEmpty;
                  if (isDataEmpty) {
                    return Container(child: Center(child: Text(translation(context).dataNotFound, style: GoogleFonts.poppins(
                      fontSize: 14 * f,
                      fontWeight: FontWeight.w500
                    ),)),);
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24 * w),
                      child: PrimaryReportCardWidget(
                          Uri: primaryBillingReportController.thumbnailUrl
                              .toString(),
                          title: widget.reportType,
                          subtitle:
                          "From ${formatPrimarReportDate(widget.startDate)} to ${formatPrimarReportDate(widget.endDate)}",
                          pdfUri:
                              primaryBillingReportController.pdfUrl.toString()),
                    );
                  }
                }
              }),
            if(getReportTypeEnum(widget.reportType) == PrimaryReportTypes.customerLedgerReport)
            Obx(() {
              if (distributorLedgerController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (distributorLedgerController.error.isNotEmpty) {
                return Center(
                  child: Text(
                    'Error: ${distributorLedgerController.error.value}',
                    style: TextStyle(color: AppColors.errorRed),
                  ),
                );
              } else {
                final bool isDataEmpty =
                    distributorLedgerController.pdfUrl.isEmpty;
                if (isDataEmpty) {
                  return Container(child: Center(child: Text(translation(context).dataNotFound, style: GoogleFonts.poppins(
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500
                  ),)),);
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24 * w),
                    child: PrimaryReportCardWidget(
                        Uri: distributorLedgerController.thumbnailUrl
                            .toString(),
                        title: widget.reportType,
                        subtitle:"From ${formatPrimarReportDate(widget.startDate)} to ${formatPrimarReportDate(widget.endDate)}",
                        pdfUri: distributorLedgerController.pdfUrl.toString()),
                  );
                }
              }
            }),
            if(getReportTypeEnum(widget.reportType) == PrimaryReportTypes.creditDebitNoteReport)
            Obx(() {
              if (creditDebitNoteController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (creditDebitNoteController.error.isNotEmpty) {
                return Center(
                  child: Text(
                    'Error: ${creditDebitNoteController.error.value}',
                    style: TextStyle(color: AppColors.errorRed),
                  ),
                );
              } else {
                final bool isDataEmpty =
                    creditDebitNoteController.pdfUrl.isEmpty;
                if (isDataEmpty) {
                  return Container(child: Center(child: Text(translation(context).dataNotFound, style: GoogleFonts.poppins(
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500
                  ),)),);
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24 * w),
                    child: PrimaryReportCardWidget(
                        Uri: creditDebitNoteController.thumbnailUrl
                            .toString(),
                        title: widget.reportType,
                        subtitle: "From ${formatPrimarReportDate(widget.startDate)} to ${formatPrimarReportDate(widget.endDate)}",
                        pdfUri: creditDebitNoteController.pdfUrl.toString()),
                  );
                }
              }
            }),
          ],
        )),
      ),
    );
  }

  String formatPrimarReportDate(String date){
    return DateFormat(AppConstants.appDateFormat).format(DateFormat('dd/MM/yyyy').parse(date));
  }


  void _navigateToPrimaryReportWidget(String reportType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrimaryReportWidget(
          selectedReportType: reportType,
          isReportTypeSelected: true,
        ),
      ),
    );
  }
}
