import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../state/contoller/primary_report_types_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/headers/back_button_header_widget.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../base_screen.dart';
import '../../../userprofile/user_profile_widget.dart';
import '../../widgets/common_bottom_modal.dart';
import '../../widgets/common_bottom_modal.dart';
import '../../widgets/date_picker_range.dart';
import '../../widgets/dropdown_button.dart';
import '../../widgets/primary_report_type.dart';
import '../select_report_type.dart';
import 'primary_report_submit.dart';

class PrimaryReportWidget extends StatefulWidget {
  String selectedReportType;
  bool isReportTypeSelected;

  PrimaryReportWidget(
      {super.key,
      this.selectedReportType = "Select Report",
      this.isReportTypeSelected = false});

  @override
  State<PrimaryReportWidget> createState() => _PrimaryReportWidgetState();
}

class _PrimaryReportWidgetState extends BaseScreenState<PrimaryReportWidget> {
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;
  String startDate = "DD/MM/YYYY";
  String endDate = "DD/MM/YYYY";
  PrimaryReportTypeController primaryReportTypeController = Get.find();
  @override
  void initState() {
    super.initState();
    primaryReportTypeController.startDateController.text="";
    primaryReportTypeController.endDateController.text="";
    primaryReportTypeController.fetchPrimaryReportTypes();
  }

  @override
  Widget baseBody(BuildContext context) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double h = DisplayMethods(context: context).getVariablePixelHeight();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidgetWithBackButton(
                heading: translation(context).primaryReport,
                onPressed: () {
                  Navigator.pop(context);
                }),
            UserProfileWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * w),
              child: DropDownButtonWidget(
                labelText: "Report type",
                placeholdertext: widget.selectedReportType,
                icon: Icons.keyboard_arrow_down_outlined,
                modalBody: CommonBottomModal(
                  modalLabelText: "Select Report Type",
                  body: PrimaryReportType(
                    onReportTypeSelected: (reportType) {
                      setState(() {
                        primaryReportTypeController.startDateController.text="";
                        primaryReportTypeController.endDateController.text="";
                        widget.selectedReportType = reportType;
                        widget.isReportTypeSelected = true;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                textColor: widget.isReportTypeSelected
                    ? AppColors.titleColor
                    : AppColors.hintColor,
              ),
            ),
            VerticalSpace(height: 14),
            Padding(
              padding: EdgeInsets.only(left: 24 * w, right: 24 * w,top: 14*h),
              child: Container(
                child: CustomCalendarView(
                  labelText:translation(context).startDate ,
                  hintText: translation(context).selectDateFormat,
                  icon: Icon(Icons.calendar_month_outlined,color: AppColors.grey,),
                  calendarType: AppConstants.rangeSelectionCalenderType,
                  dateFormat: "dd/MM/yyyy",
                  errorText: "",
                  daysRange:180,
                  calendarStartDate: DateTime(1950, 1,1) ,
                  calendarEndDate: DateTime.now(),
                  startDateEditController: primaryReportTypeController.startDateController,
                  endDateEditController: primaryReportTypeController.endDateController,
                  onDateSelected: (selectedDate){
                    print("view1 ${selectedDate}");
                  },
                  onDateRangeSelected: (startDateVal,endDateVal){
                    print("view2 ${startDateVal}- ${endDateVal}");
                    var inputFormat = DateFormat('dd/MM/yyyy');
                    var startDateObject = inputFormat.parse(startDateVal); // <-- dd/MM 24H format
                    var endDateObject = inputFormat.parse(endDateVal); // <-- dd/MM 24H format
      
                    setState(() {
                      startDate = startDateVal;
                      endDate = endDateVal;
                      isStartDateSelected = true;
                      isEndDateSelected = true;
                    });
      
                  },
                )
      
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        child: DropDownButtonWidget(
                      labelText: translation(context).startDate,
                      placeholdertext: startDate != "" ? startDate : "DD/MM/YYYY",
                      icon: Icons.calendar_month_outlined,
                      modalBody: DatePickerRangeWidget(
                          onDateRangeSelected: (value1, value2) {
                        setState(() {
                          startDate = DateFormat('dd/MM/yyyy').format(value1);
                          endDate = DateFormat('dd/MM/yyyy').format(value2);
                          isStartDateSelected = true;
                          isEndDateSelected = true;
                        });
                      }),
                      textColor: isStartDateSelected
                          ? AppColors.titleColor
                          : AppColors.hintColor,
                    )),
                    HorizontalSpace(width: 12),
                    Flexible(
                        child: DropDownButtonWidget(
                      labelText: translation(context).endDate,
                      placeholdertext: endDate != "" ? endDate : "DD/MM/YYYY",
                      icon: Icons.calendar_month_outlined,
                      modalBody: DatePickerRangeWidget(
                          onDateRangeSelected: (value1, value2) {
                        setState(() {
                          startDate = DateFormat('dd/MM/yyyy').format(value1);
                          endDate = DateFormat('dd/MM/yyyy').format(value2);
                          isStartDateSelected = true;
                          isEndDateSelected = true;
                        });
                      }),
                      textColor: isEndDateSelected
                          ? AppColors.titleColor
                          : AppColors.hintColor,
                    ))
                  ],
                )*/
              ),
            ),
            Spacer(),
            CommonButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrimaryReportSubmit(
                              reportType: widget.selectedReportType,
                              startDate: startDate,
                              endDate: endDate,
                            )));
              },
              isEnabled: widget.isReportTypeSelected &&
                  isEndDateSelected &&
                  isStartDateSelected,
              buttonText: translation(context).submit,
              containerBackgroundColor: AppColors.lightWhite1,
              containerHeight: 48 * h,
            )
          ],
        )),
      ),

    );
  }
}
