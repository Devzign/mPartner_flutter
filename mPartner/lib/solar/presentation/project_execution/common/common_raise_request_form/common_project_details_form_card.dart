import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../presentation/screens/base_screen.dart';
import '../../../../../presentation/screens/network_management/dealer_electrician/components/heading_dealer.dart';
import '../../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../../presentation/widgets/common_button.dart';
import '../../../../../presentation/widgets/common_divider.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../services/services_locator.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/utils.dart';
import '../../../../data/datasource/solar_remote_data_source.dart';
import '../../../../data/models/solar_design_form_submit_response.dart';
import '../../../../state/controller/go_solar_count_details_controller.dart';
import '../../../../state/controller/terms_and_condition_controller.dart';
import '../../../../utils/solar_app_constants.dart';
import '../../../common/heading_solar.dart';
import '../../../common/leads_list_detail_cards/detailed_summary_card.dart';
import '../../../common/something_went_wrong_solar_screen.dart';
import '../../../solar_finance/solar_finance_request/components/terms_and_conditions_bottom_sheet.dart';
import '../../model/form_model.dart';
import 'common_form_submit_success_bottomsheet.dart';

class ProjectDetailsFormCard extends StatefulWidget {
  const ProjectDetailsFormCard(
      {required this.formDetails, required this.typeValue, super.key});

  final FormModel formDetails;
  final String typeValue;

  @override
  State<ProjectDetailsFormCard> createState() {
    return _ProjectDetailsFormCard();
  }
}

class _ProjectDetailsFormCard extends BaseScreenState<ProjectDetailsFormCard> {
  GoSolarCountDetailsController goSolarCountDetailsController = Get.find();
  String companyNameLabel = "";
  String companyNameValue = "";
  String secondaryNameLabel = "";
  String secondaryNameValue = "";
  String secondaryEmailLabel = "";
  String secondaryEmailValue = "";
  String secondaryNumberLabel = "";
  String secondaryNumberValue = "";
  bool isLoading = false;
  int retryCount = 0;
  TermsAndConditionController termsAndConditionController = Get.find();
  bool isChecked = false;
  String routeName = "";
  bool hasScrolledTerms = false;

  @override
  void initState() {
    super.initState();
    var termsAndConditionKey="";
    termsAndConditionController.clearTermsAndConditionController();
    if (widget.typeValue == SolarAppConstants.onsite) {
      termsAndConditionKey = TermsNConditionsType.SolarProjectExe.name;
    }
    else if (widget.typeValue == SolarAppConstants.online){
      termsAndConditionKey = TermsNConditionsType.SolarPrjExeOnline.name;
    }
    else {
      termsAndConditionKey = TermsNConditionsType.SolarPrjExeE2E.name;
    }

    termsAndConditionController.fetchTermsAndCondition(termsAndConditionKey);

    companyNameLabel =
        (widget.formDetails.companyName == null) ? "" : "Firm Name";
    companyNameValue = (widget.formDetails.companyName == null)
        ? ""
        : widget.formDetails.companyName!;
    secondaryNameLabel = (widget.formDetails.secondaryName == null)
        ? ""
        : "Secondary Contact Person Name";
    secondaryNameValue = (widget.formDetails.secondaryName == null)
        ? ""
        : widget.formDetails.secondaryName!;
    secondaryEmailLabel = (widget.formDetails.secondaryEmail == null)
        ? ""
        : "Secondary Contact Person Email";
    secondaryEmailValue = (widget.formDetails.secondaryEmail == null)
        ? ""
        : widget.formDetails.secondaryEmail!;
    secondaryNumberLabel = (widget.formDetails.secondaryNumber == null)
        ? ""
        : "Secondary Contact Person Number";
    secondaryNumberValue = (widget.formDetails.secondaryNumber == null)
        ? ""
        : widget.formDetails.secondaryNumber!;
    _getRouteName();
  }

  void _getRouteName() {
    if (widget.typeValue == SolarAppConstants.online) {
      routeName = SolarAppConstants.peOnlineRouteName;
    } else if (widget.typeValue == SolarAppConstants.onsite) {
      routeName = SolarAppConstants.peOnsiteRouteName;
    } else if (widget.typeValue == SolarAppConstants.endToEnd) {
      routeName = SolarAppConstants.peEndToEndRouteName;
    }
  }

  void openTermsAndConditionsBottomSheet() {
    showTermsAndConditionsBottomSheet(context, (bool isScrolled) {
      setState(() {
        hasScrolledTerms = isScrolled;
      });
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSolar(
              heading: getTitle(widget.typeValue),
            ),
            UserProfileWidget(
              top: 8 * h,
              bottom: 28 * h,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24 * w, vertical: 5 * h),
                      child: DetailedSummaryCard(labelData: {
                        translation(context).projectType: {
                          "val": widget.formDetails.category,
                          "type": "text"
                        },
                        translation(context).firmName: {
                          "val": companyNameValue,
                          "type": "text"
                        },
                        translation(context).contactPersonName: {
                          "val": widget.formDetails.contactPersonName,
                          "type": "text"
                        },
                        translation(context).contactPersonMobile: {
                          "val": "+91 - ${widget.formDetails.contactPersonNumber}",
                          "type": "text"
                        },
                      translation(context).contactPersonEmailId: {
                          "val": widget.formDetails.contactPersonEmailId,
                          "type": "text"
                        },
                      translation(context).secondaryContactName: {
                          "val": secondaryNameValue,
                          "type": "text"
                        },
                      translation(context).secondaryContactMobile: {
                          "val": secondaryNumberValue.isEmpty?secondaryNumberValue:"+91 - $secondaryNumberValue",
                          "type": "text"
                        },
                      translation(context).secondaryContactEmailId: {
                          "val": secondaryEmailValue,
                          "type": "text"
                        },
                      translation(context).projectName: {
                          "val": widget.formDetails.projectName,
                          "type": "text"
                        },
                      translation(context).projectAddress: {
                          "val": widget.formDetails.projectAddress,
                          "type": "text"
                        },
                      translation(context).projectLandmark: {
                          "val": widget.formDetails.projectLandmark,
                          "type": "text"
                        },
                      translation(context).projectCurrentLocation: {
                          "val": widget.formDetails.projectLocation,
                          "type": "text"
                        },
                      translation(context).pincode: {
                          "val": widget.formDetails.projectPincode,
                          "type": "text"
                        },
                      translation(context).state: {
                          "val": widget.formDetails.state,
                          "type": "text"
                        },
                      translation(context).city: {
                          "val": widget.formDetails.city,
                          "type": "text"
                        },
                      translation(context).solutionType: {
                          "val": widget.formDetails.solutionType,
                          "type": "text"
                        },
                      translation(context).reasonForSupport: {
                          "val": widget.formDetails.supportReason,
                          "type": "text"
                        },
                      translation(context).subCategory: {
                          "val": widget.formDetails.subCategory,
                          "type": "text"
                        },
                        (widget.typeValue == "online")
                            ? translation(context).preferredDateOfConsultation
                            : translation(context).preferredDateOfVisit: {
                          "val": widget.formDetails.preferredDate,
                          "type": "text"
                        },
                      })),
                  const VerticalSpace(height: 24),
                  Padding(
                    padding: EdgeInsets.only(left: 24 * w, right: 24 * w),
                    child: Text(
                      translation(context).termsAndConditions,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 14 * f,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12 * w, right: 24 * w),
                    child: GestureDetector(
                      onTap: openTermsAndConditionsBottomSheet,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            activeColor: AppColors.lumiBluePrimary,
                            side: MaterialStateBorderSide.resolveWith(
                                  (states) => BorderSide(width: isChecked ? 0.0 : 2.0, color: AppColors.dividerColor),
                            ),
                            onChanged: (bool? value) {
                              if (hasScrolledTerms) {
                                setState(() {
                                  isChecked = value!;
                                });
                              } else {
                                openTermsAndConditionsBottomSheet();
                              }
                            },
                          ),
                          Text(
                            translation(context).acceptTermsConditions,
                            style: GoogleFonts.poppins(
                              color: AppColors.lumiBluePrimary,
                              fontSize: 14 * f,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: CommonButton(
                          withContainer: true,
                          onPressed: () => {
                            Navigator.of(context).pop(),
                          },
                          isEnabled: true,
                          buttonText: translation(context).back,
                          containerHeight: 48 * h,
                          leftPadding: 24 * w,
                          rightPadding: 8 * w,
                          textColor: AppColors.lumiBluePrimary,
                          backGroundColor: Colors.white,
                          containerBackgroundColor: AppColors.white,
                          defaultButton: false,
                        ),
                      ),
                      Expanded(
                        child: CommonButton(
                          withContainer: true,
                          showLoader: isLoading,
                          onPressed: () async {
                            await submitDetails(
                                widget.formDetails, context, h, w, r, f);
                          },
                          isEnabled:  isChecked && !isLoading,
                          containerHeight: 48 * h,
                          buttonText: translation(context).submit,
                          leftPadding: 8 * w,
                          rightPadding: 24 * w,
                          textColor: AppColors.white,
                          backGroundColor:  isChecked ? AppColors.lumiBluePrimary : AppColors.primaryButtonDisabled,
                          containerBackgroundColor: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getTitle(String typeValue) {
    if (typeValue == SolarAppConstants.online) {
      return translation(context).onlineGuidance;
    } else if (typeValue == SolarAppConstants.onsite) {
      return translation(context).onsiteGuidance;
    } else {
      return translation(context).endToEndDeployment;
    }
  }

  submitDetails(FormModel formModel, BuildContext context, double h, double w,
      double r, double f) async {
    setState(() {
      isLoading = true;
    });
    try {
      var solarRemoteDataSource = s2<BaseSolarRemoteDataSource>();
      final result = await solarRemoteDataSource
          .saveProjectExecutionProjectDetails(formModel);
      result.fold(
        (l) {
          retryCount++;
          print(retryCount);
          logger.e(l);
          if (retryCount <= 2) {
            Utils().showToast(
                translation(context).somethingWentWrongPleaseRetry, context);
          } else {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
                context,
                (MaterialPageRoute(
                    builder: (context) => SomethingWentWrongSolarScreen(
                          previousRoute: routeName,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ))));
          }
        },
        (right) {
          if (right.status == '200') {
            goSolarCountDetailsController.fetchGoSolarCountDetails();
            commonSubmitSuccessBottomsheet(
                context, translation(context).submittedSuccessfully, right.data['requestId'],widget.typeValue);
          } else {
            retryCount++;
            print(retryCount);
            if (retryCount <= 2) {
              Utils().showToast(
                  translation(context).somethingWentWrongPleaseRetry, context);
            } else {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  (MaterialPageRoute(
                      builder: (context) => SomethingWentWrongSolarScreen(
                            previousRoute: routeName,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ))));
            }
          }
        },
      );
    } catch (e) {
      logger.e('Error $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

void showSubmitSuccessfullyBottomSheet(BuildContext context, double h, double w,
    double r, double f, SolarDesignFormSubmitResponse response) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * r),
      ),
    ),
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8 * w, 8 * h, 8 * w, 8 * h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 36 * h,
                    child: Center(
                      child: Opacity(
                        opacity: 0.40,
                        child: Container(
                          width: 32,
                          height: 4,
                          decoration: ShapeDecoration(
                            color: Color(0xFF79747E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16 * w, top: 16 * h),
                    child: Text(
                      translation(context).submittedSuccessfully,
                      style: GoogleFonts.poppins(
                        color: AppColors.titleColor,
                        fontSize: 20 * f,
                        fontWeight: FontWeight.w600,
                        height: 24 / 20,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 16 * r),
                    child: const CustomDivider(color: AppColors.dividerColor),
                  ),
                  const VerticalSpace(height: 16),
                  Padding(
                    padding: EdgeInsets.only(right: 24 * w, left: 16 * w),
                    child: RichText(
                      text: TextSpan(
                        text: "${translation(context).theRequest} ",
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGrey,
                          fontSize: 16 * f,
                          fontWeight: FontWeight.w400,
                          height: 24 / 16,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'SR2402DN100000',
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 16 * f,
                              fontWeight: FontWeight.w700,
                              height: 24 / 16,
                            ),
                          ),
                          TextSpan(
                            text: " ${translation(context).hasBeenSentForDesignAndProposal}",
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 16 * f,
                              fontWeight: FontWeight.w400,
                              height: 24 / 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 24),
                  CommonButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    isEnabled: true,
                    buttonText: translation(context).done,
                    leftPadding: 8 * w,
                    rightPadding: 24 * w,
                    textColor: AppColors.white,
                    backGroundColor: AppColors.lumiBluePrimary,
                    containerHeight: 48 * h,
                    containerBackgroundColor: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
