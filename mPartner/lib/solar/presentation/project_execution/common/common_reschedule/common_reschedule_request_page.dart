import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../presentation/screens/network_management/dealer_electrician/components/heading_dealer.dart';
import '../../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../../presentation/widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../../presentation/widgets/common_button.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../state/contoller/app_setting_value_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/ProjectExecutionRequestListController.dart';
import 'common_reschedule_success_bottom_sheet.dart';

class CommonRescheduleRequest extends StatefulWidget {
  final Function() onItemSelected;
  final String? contentTiltle;
  final String? typePEValue;
  final String? projectId;
  final String? isFrom;
  final String? disableDate;

  const CommonRescheduleRequest(
      {required this.onItemSelected,
      this.typePEValue,
      this.contentTiltle,
      this.projectId,
      this.isFrom,
      this.disableDate,
      Key? key})
      : super(key: key);

  @override
  State<CommonRescheduleRequest> createState() =>
      _CommonRescheduleRequestState();
}

class _CommonRescheduleRequestState extends State<CommonRescheduleRequest> {
  //HelpAndSupportController helpAndSupportController = Get.find();
  double variablePixelHeight = 0.0;
  double variablePixelWidth = 0.0;
  double pixelMultiplier = 0.0;
  double textFontMultiplier = 0.0;
  bool isButtonEnabled = false;
  TextEditingController msgController = TextEditingController();
  bool showLoader = false;
  Map<String, dynamic> contactDetail = {};
  TextEditingController preferredDateController = TextEditingController();
  ProjectExecutionRequestListController projectExecutionRequestListController =
      Get.find();
  DateTime? selectedDateObject=null;
  AppSettingValueController appSettingValueController = Get.find();

  @override
  void initState() {
    super.initState();
    // helpAndSupportController.clearHelpAndSupportController();
    //getCompanyDetails();
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    this.variablePixelHeight = variablePixelHeight;
    this.variablePixelWidth = variablePixelWidth;
    this.textFontMultiplier = textFontMultiplier;
    this.pixelMultiplier = pixelMultiplier;
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: CommonButton(
          containerHeight: 52 * variablePixelHeight,
          onPressed: () async {
            setState(() {
              showLoader=true;
            });
            await projectExecutionRequestListController.postPERescheduling(
                widget.projectId!,
                msgController.text.trim(),
                preferredDateController.text.trim());
            var responseMessage=projectExecutionRequestListController.responseMessage;
            projectExecutionRequestListController.responseMessage="";
            setState(() {
              showLoader=false;
            });
            if (responseMessage
                .contains("success")) {
              commonRescheduleSubmitSuccessBottomsheet(
                context,
                translation(context).submittedSuccessfully,
                "",
                widget.isFrom,
                widget.typePEValue!
              );
            } else {
              commonRescheduleSubmitSuccessBottomsheet(
                  context,
                  translation(context).tryAgain,
                  responseMessage,widget.isFrom,
                  widget.typePEValue!);
            }
          },
          isEnabled: isButtonEnabled,
          showLoader: showLoader,
          containerBackgroundColor: AppColors.white,
          buttonText: translation(context).submit),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            //width: variablePixelWidth * 392,
            height: variablePixelHeight *
                (MediaQuery.of(context).size.height +
                    MediaQuery.of(context).viewInsets.bottom),
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 24 * variablePixelWidth,
                      right: 24 * variablePixelWidth,
                      top: 48 * variablePixelHeight),
                  child: HeadingDealer(
                    heading: translation(context).reschedule,
                  ),
                ),
                UserProfileWidget(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 24 * variablePixelWidth,
                        right: 24 * variablePixelWidth),
                    child: Column(
                      children: [
                        VerticalSpace(height: 16 * variablePixelHeight),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            translation(context).provideRescheduleDate,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 16 * textFontMultiplier,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50 * variablePixelWidth,
                            ),
                          ),
                        ),
                        Container(
                          height: 52 * variablePixelHeight,
                          margin: EdgeInsets.only(top: 28 * variablePixelHeight),
                          child: CustomCalendarView(
                            labelText: translation(context).preferredDateOfRevisit,
                            hintText: "DD/MM/YYYY",
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.grey,
                            ),
                            calendarType:
                                AppConstants.singleSelectionCalenderType,
                            dateFormat: "dd/MM/yyyy",
                            errorText: "",
                            disableDate:DateFormat("dd/MM/yyyy").parse(widget.disableDate!),
                            initialDateSelection: selectedDateObject ?? DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day + getInitialDateSelection()),
                            calendarStartDate: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit),
                            calendarEndDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestEndDateLimit),
                            singleDateEditController: preferredDateController,
                            onDateSelected: (selectedDate) {
                              print("view1 ${selectedDate}");
                              preferredDateController.text = selectedDate;
                               selectedDateObject =
                                  DateFormat("dd/MM/yyyy").parse(selectedDate);
                              //  initialSelectedDate = selectedDateObject;
                              // checkTextFieldStatus();
                              setState(() {
                                if (preferredDateController.text.isNotEmpty &&
                                    msgController.text.isNotEmpty) {
                                  isButtonEnabled = true;
                                } else {
                                  isButtonEnabled = false;
                                }
                              });
                            },
                            onDateRangeSelected: (startDate, endDate) {
                              print("view2 ${startDate}- ${endDate}");
                            },
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: 24 * variablePixelHeight),
                                child: TextFormField(
                                  controller: msgController,
                                  onChanged: (value) {
                                    setState(() {
                                      if (msgController.text.isNotEmpty &&
                                          preferredDateController
                                              .text.isNotEmpty) {
                                        isButtonEnabled = true;
                                      } else {
                                        isButtonEnabled = false;
                                      }
                                    });
                                  },
                                  minLines: 6,
                                  maxLines: null,
                                  maxLength: 600,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 12 * variablePixelWidth,
                                        right: 12 * variablePixelWidth,
                                        top: 12 * variablePixelHeight,
                                        bottom: 12 * variablePixelHeight),
                                    border: const OutlineInputBorder(),
                                    hintText: translation(context).writeYourReasonHere,
                                    hintStyle: GoogleFonts.poppins(
                                      color: AppColors.dividerColor,
                                      fontSize: 12 * textFontMultiplier,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.50 * variablePixelWidth,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6 * pixelMultiplier)),
                                      borderSide: BorderSide(
                                        color: AppColors.white_234,
                                        width: 1.0 * variablePixelWidth,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6 * pixelMultiplier)),
                                      borderSide: BorderSide(
                                        color: AppColors.white_234,
                                        width: 1.0 * variablePixelWidth,
                                      ),
                                    ),
                                    counterText: "",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 24 * variablePixelWidth,
                                    top: 12 * variablePixelHeight),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "${msgController.text.length}/600",
                                    style: GoogleFonts.poppins(
                                      color: AppColors.dividerColor,
                                      fontSize: 12 * textFontMultiplier,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.50 * variablePixelWidth,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int getInitialDateSelection() {
    DateTime disableDate= DateFormat("dd/MM/yyyy").parse(widget.disableDate!);
    DateTime initialDate= DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day+appSettingValueController.solarRaiseRequestStartDateLimit);
    if(disableDate==initialDate){
      return appSettingValueController.solarRaiseRequestStartDateLimit+1;
    }
    return appSettingValueController.solarRaiseRequestStartDateLimit;
  }
}
