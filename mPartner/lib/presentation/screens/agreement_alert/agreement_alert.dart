import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../widgets/common_button.dart';
import '../../../state/contoller/fse_agreement_controller.dart';
import '../../../state/contoller/alert_notification_controller.dart';
import '../../../state/contoller/survey_question_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../widgets/verifySaleOTP/common_verify_otp.dart';
import '../../../state/contoller/fse_agreement_create_otp_controller.dart';
import '../../../state/contoller/fse_agreement_verify_otp_controller.dart';
import 'components/agreement_verify_otp.dart';

class AgreementAlert extends StatefulWidget {
  final void Function() checkToShowPopUpAlert;
  final void Function() checkToShowSurveyForm;

  AgreementAlert({
    required this.checkToShowPopUpAlert,
    required this.checkToShowSurveyForm,
  });

  @override
  State<AgreementAlert> createState() =>
      _AgreementAlertState();
}

class _AgreementAlertState extends State<AgreementAlert> {
  UserDataController controller = Get.find();
  FseAgreementController fseAgreementController = Get.find();
  AlertNotificationController alertNotificationController = Get.find();
  SurveyQuestionsController surveyQuestionsController = Get.find();
  FseAgreementCreateOtpController fseAgreementCreateOtpController = Get.find();
  FseAgreementVerifyOtpController fseAgreementVerifyOtpController = Get.find();
  bool isAgreementAccepted = false;
  bool shouldLoaderDisplay = false;
  String agreement = "";
  String annexure = "";

  @override
  void initState() {
    super.initState();
    if (fseAgreementController.fseAgreement?.agreement != null) {
      agreement = fseAgreementController.fseAgreement?.agreement ?? "";
      annexure = fseAgreementController.fseAgreement?.annexure ?? "";
    }
  }

  Future<void> _launchUrl() async {
    var googleDocsUrl = 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeQueryComponent(annexure)}';
    final Uri uri = Uri.parse(googleDocsUrl);
    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $annexure');
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 740 * h,
            decoration: BoxDecoration(
              color: AppColors.lightWhite1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30 * r),
                topRight: Radius.circular(30 * r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
                24 * w,
                18 * h,
                24 * w,
                5 * h
            ),
            child: Column(
              children: [
                Opacity(
                  opacity: 0,
                  child: Container(
                    width: 32 * w,
                    height: 4 * h,
                    margin: EdgeInsets.symmetric(
                        vertical: 10 * h
                    ),
                    decoration: ShapeDecoration(
                      color: AppColors.lightGrey3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100 * r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3 * h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translation(context).agreement,
                        style: GoogleFonts.poppins(
                          color: AppColors.titleColor,
                          fontSize: 20 * f,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8 * h),
                Container(
                  height: 1 * h,
                  color: AppColors.dividerGreyColor,
                  margin: EdgeInsets.symmetric(vertical: 8 * h),
                ),
                SizedBox(height: 12 * h),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: HtmlWidget(agreement),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 24 * h,
                      bottom: 24 * h
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              _launchUrl();
                            },
                            child: Text(
                              translation(context).clickToViewAnnexure,
                              style: GoogleFonts.poppins(
                                color: AppColors.lumiBluePrimary,
                                fontSize: 14 * f,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.10,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 16 * h,
                            bottom: 16 * h
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isAgreementAccepted,
                              onChanged: (bool? value) {
                                setState(() {
                                  isAgreementAccepted = value ?? false;
                                });
                              },
                              checkColor: AppColors.white,
                              activeColor: AppColors.lumiBluePrimary,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  padding: EdgeInsets.only(left: 8.0 * w),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isAgreementAccepted = !isAgreementAccepted;
                                      });
                                    },
                                    child: Text(
                                      translation(context).acceptAllTheTermsAndConditionsOfLuminousFSEAgreement,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGreyText,
                                        fontSize: 12 * f,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.10,
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: CommonButton(
                          onPressed: () async {
                            setState(() {
                              shouldLoaderDisplay = true;
                            });
                            controller.updateIsFseAgreementAppearedOnlyController(true);
                            // create OTP
                            await fseAgreementCreateOtpController.fetchFseAgreementCreateOtp();
                            setState(() {
                              shouldLoaderDisplay = false;
                            });
                            Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0 * r),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return AgreementVerifyOtpWidget(
                                    checkToShowPopUpAlert: widget.checkToShowPopUpAlert,
                                    checkToShowSurveyForm: widget.checkToShowSurveyForm
                                );
                              },
                            );
                            // if (alertNotificationController.showAlerts == true) {
                            //   widget.checkToShowPopUpAlert();
                            // } else if (surveyQuestionsController.showSurveyForm == true) {
                            //   widget.checkToShowSurveyForm();
                            // }
                          },
                          isEnabled: isAgreementAccepted ? true : false,
                          buttonText: translation(context).continueButtonText,
                          backGroundColor: AppColors.lumiBluePrimary,
                          textColor: AppColors.lightWhite1,
                          defaultButton: true,
                          containerBackgroundColor: AppColors.white,
                          horizontalPadding : 0,
                          bottomPadding: 0,
                          topPadding: 0,
                          showLoader: shouldLoaderDisplay,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}

