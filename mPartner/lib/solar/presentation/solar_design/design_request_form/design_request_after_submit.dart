import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../presentation/screens/base_screen.dart';
import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/common_button.dart';
import '../../../../presentation/widgets/common_divider.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../services/services_locator.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/utils.dart';
import '../../../data/datasource/solar_remote_data_source.dart';
import '../../../data/models/design_request_model.dart';
import '../../../data/models/solar_design_form_submit_response.dart';
import '../../../state/controller/digital_survey_request_list_controller.dart';
import '../../../state/controller/go_solar_count_details_controller.dart';
import '../../../state/controller/solar_design_count_details_controller.dart';
import '../../../state/controller/terms_and_condition_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/heading_solar.dart';
import '../../common/leads_list_detail_cards/detailed_summary_card.dart';
import '../../common/something_went_wrong_solar_screen.dart';
import '../../solar_finance/solar_finance_request/components/terms_and_conditions_bottom_sheet.dart';
import 'design_request_form.dart';

class DesignRequestAfterSubmit extends StatefulWidget {
  const DesignRequestAfterSubmit(
      {required this.designFormDetails,
      required this.solarModuleType,
      super.key});

  final DesignFormModel designFormDetails;
  final SolarModuleType solarModuleType;

  @override
  State<DesignRequestAfterSubmit> createState() {
    return _DesignRequestAfterSubmit();
  }
}

class _DesignRequestAfterSubmit
    extends BaseScreenState<DesignRequestAfterSubmit> {
  BaseSolarRemoteDataSource solarRemoteDataSource =
      s2<BaseSolarRemoteDataSource>();
  DigitalSurveyRequestListController digitalSurveyRequestListController =
      Get.find();
  GoSolarCountDetailsController goSolarCountDetailsController = Get.find();
  SolarDesignCountDetailsController solarDesignCountDetailsController =
      Get.find();
  String companyNameLabel = "";
  String secondaryNameLabel = "";
  String secondaryEmailLabel = "";
  String secondaryNumberLabel = "";
  String preferredDateOVisitLabel = "";
  bool isLoading = false;
  SolarDesignFormSubmitResponse response =
      SolarDesignFormSubmitResponse.empty();
  int retryCount = 0;
  bool isChecked = false;
  bool hasScrolledTerms = false;
  TermsAndConditionController termsAndConditionController = Get.find();

  @override
  void initState() {
    super.initState();
    termsAndConditionController.clearTermsAndConditionController();
    termsAndConditionController.fetchTermsAndCondition(
        widget.solarModuleType == SolarModuleType.digital
            ? TermsNConditionsType.SolarDigDesign.name
            : TermsNConditionsType.SolarPhyDesign.name);
  }

  submitDetails(DesignFormModel designFormDetails, double h, double w, double r,
      double f) async {
    setState(() {
      isLoading = true;
    });
    try {
      final result =
          await solarRemoteDataSource.saveDigitalSurveyCustomerDetails(
              designFormDetails, designFormDetails.imagePath);
      result.fold(
        (l) {
          retryCount++;
          print(retryCount);
          logger.e(l);
          if (retryCount <= 2) {
            Utils().showToast(
                translation(context).somethingWentWrongPleaseRetry, context);
          } else {
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
            Navigator.push(
                context,
                (MaterialPageRoute(
                    builder: (context) => SomethingWentWrongSolarScreen(
                          previousRoute:
                              widget.solarModuleType == SolarModuleType.digital
                                  ? SolarAppConstants.digitalDesRouteName
                                  : SolarAppConstants.physicalDesRouteName,
                          onPressed: () {
                            if (widget.solarModuleType ==
                                SolarModuleType.digital) {
                              Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                      AppRoutes.solarDigDesignDashboard));
                            } else {
                              Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                      AppRoutes.solarDigDesignDashboard));
                            }
                          },
                        ))));
          }
        },
        (right) async {
          setState(() {
            response = right;
          });
          if (response.status == '200') {
            solarDesignCountDetailsController.fetchSolarDesignCountDetails(
                widget.solarModuleType == SolarModuleType.digital
                    ? true
                    : false);
            goSolarCountDetailsController.fetchGoSolarCountDetails();
            digitalSurveyRequestListController.resetPagination();
            await digitalSurveyRequestListController.addAndRemoveValuesToList();
            digitalSurveyRequestListController.fetchDigitalSurveyRequestList(
                (digitalSurveyRequestListController.insideResiOrComm.value)
                    ? SolarAppConstants.residentialCategory
                    : SolarAppConstants.commercialCategory,
                digitalSurveyRequestListController.searchString.value,
                digitalSurveyRequestListController
                    .finalDesignStatusString.value,
                digitalSurveyRequestListController
                    .finalSolutionTypeString.value,
                (widget.solarModuleType == SolarModuleType.digital)
                    ? true
                    : false);
            showSubmitSuccessfullyBottomSheet(
                widget.solarModuleType, context, h, w, r, f, response);
          } else {
            retryCount++;
            print(retryCount);
            if (retryCount <= 2) {
              Utils().showToast(
                  translation(context).somethingWentWrongPleaseRetry, context);
            } else {
              // Navigator.of(context).pop();
              // Navigator.of(context).pop();
              Navigator.push(
                  context,
                  (MaterialPageRoute(
                      builder: (context) => SomethingWentWrongSolarScreen(
                            previousRoute: widget.solarModuleType ==
                                    SolarModuleType.digital
                                ? SolarAppConstants.digitalDesRouteName
                                : SolarAppConstants.physicalDesRouteName,
                            onPressed: () {
                              // Navigator.pop(context);
                              if (widget.solarModuleType ==
                                  SolarModuleType.digital) {
                                Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(
                                        AppRoutes.solarDigDesignDashboard));
                              } else {
                                Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(
                                        AppRoutes.solarPhyDesignDashboard));
                              }
                            },
                          ))));
            }
          }
        },
      );
    } catch (e) {
      retryCount++;
      logger.d(retryCount);
      if (retryCount <= 2) {
        Utils().showToast(
            translation(context).somethingWentWrongPleaseRetry, context);
      } else {
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        Navigator.push(
            context,
            (MaterialPageRoute(
                builder: (context) => SomethingWentWrongSolarScreen(
                      previousRoute:
                          widget.solarModuleType == SolarModuleType.digital
                              ? SolarAppConstants.digitalDesRouteName
                              : SolarAppConstants.physicalDesRouteName,
                      onPressed: () {
                        if (widget.solarModuleType == SolarModuleType.digital) {
                          Navigator.popUntil(
                              context,
                              ModalRoute.withName(
                                  AppRoutes.solarDigDesignDashboard));
                        } else {
                          Navigator.popUntil(
                              context,
                              ModalRoute.withName(
                                  AppRoutes.solarPhyDesignDashboard));
                        }
                        // Navigator.pop(context);
                      },
                    ))));
      }
      logger.e('Error $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
    companyNameLabel = (widget.designFormDetails.companyName.isEmpty)
        ? ""
        : translation(context).firmName;
    secondaryNameLabel = (widget.designFormDetails.secondaryName.isEmpty)
        ? ""
        : translation(context).secondaryContactName;

    secondaryEmailLabel = (widget.designFormDetails.secondaryEmail.isEmpty)
        ? ""
        : translation(context).secondaryContactEmailId;
    secondaryNumberLabel = (widget.designFormDetails.secondaryNumber.isEmpty)
        ? ""
        : translation(context).secondaryContactMobile;
    preferredDateOVisitLabel =
        (widget.designFormDetails.preferredDateOfVisit.isEmpty)
            ? ""
            : translation(context).preferredDateOfVisit;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSolar(
              heading: (widget.solarModuleType == SolarModuleType.physical)
                  ? translation(context).physicalVisitAndDesigning
                  : translation(context).digitalDesigning,
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
                          "val": widget
                              .designFormDetails.category.capitalizeFirst!,
                          "type": "text"
                        },
                        companyNameLabel: {
                          "val": widget.designFormDetails.companyName,
                          "type": "text"
                        },
                        translation(context).contactPersonName: {
                          "val": widget.designFormDetails.contactPersonName,
                          "type": "text"
                        },
                        translation(context).contactPersonMobile: {
                          "val":
                              '+91 - ${widget.designFormDetails.contactPersonNumber}',
                          "type": "text"
                        },
                        translation(context).contactPersonEmailId: {
                          "val": widget.designFormDetails.contactPersonEmailId,
                          "type": "text"
                        },
                        secondaryNameLabel: {
                          "val": widget.designFormDetails.secondaryName,
                          "type": "text"
                        },
                        secondaryNumberLabel: {
                          "val": (widget
                                  .designFormDetails.secondaryNumber.isNotEmpty)
                              ? '+91 - ${widget.designFormDetails.secondaryNumber}'
                              : "",
                          "type": "text"
                        },
                        secondaryEmailLabel: {
                          "val": widget.designFormDetails.secondaryEmail,
                          "type": "text"
                        },
                        translation(context).projectName: {
                          "val": widget.designFormDetails.projectName,
                          "type": "text"
                        },
                        translation(context).projectAddress: {
                          "val": widget.designFormDetails.projectAddress,
                          "type": "text"
                        },
                        translation(context).projectLandmark: {
                          "val": widget.designFormDetails.projectLandmark,
                          "type": "text"
                        },
                        translation(context).projectCurrentLocation: {
                          "val": widget.designFormDetails.projectLocation,
                          "type": "text"
                        },
                        translation(context).pincode: {
                          "val": widget.designFormDetails.projectPincode,
                          "type": "text"
                        },
                        translation(context).state: {
                          "val": widget.designFormDetails.state,
                          "type": "text"
                        },
                        translation(context).city: {
                          "val": widget.designFormDetails.city,
                          "type": "text"
                        },
                        translation(context).solutionType: {
                          "val": widget.designFormDetails.solutionType,
                          "type": "text"
                        },
                        translation(context).avgEnergyConsumption: {
                          "val":
                              "${widget.designFormDetails.averageEnergy} kWh",
                          "type": "text"
                        },
                        translation(context).averageMonthlyBill: {
                          "val":
                              "\u{20B9} ${widget.designFormDetails.monthlyBill}",
                          "type": "text"
                        },
                        preferredDateOVisitLabel: {
                          "val": widget.designFormDetails.preferredDateOfVisit,
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
                              (states) => BorderSide(
                                  width: isChecked ? 0.0 : 2.0,
                                  color: AppColors.dividerColor),
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
                                widget.designFormDetails, h, w, r, f);
                          },
                          isEnabled: isChecked && !isLoading,
                          containerHeight: 48 * h,
                          buttonText: translation(context).submit,
                          leftPadding: 8 * w,
                          rightPadding: 24 * w,
                          textColor: AppColors.white,
                          backGroundColor: isChecked
                              ? AppColors.lumiBluePrimary
                              : AppColors.primaryButtonDisabled,
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
}

void showSubmitSuccessfullyBottomSheet(
    SolarModuleType solarModuleType,
    BuildContext context,
    double h,
    double w,
    double r,
    double f,
    SolarDesignFormSubmitResponse response,
    {FocusNode? amountFocusNode,
    String? maxAmountLimitMessage}) {
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
                        text: '${translation(context).theRequest} ',
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGrey,
                          fontSize: 16 * f,
                          fontWeight: FontWeight.w400,
                          height: 24 / 16,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: response.data["requestId"],
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 16 * f,
                              fontWeight: FontWeight.w700,
                              height: 24 / 16,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' ${translation(context).hasBeenSentForDesignAndProposal}',
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
                      // Navigator.pop(context);
                      // Navigator.pop(context);
                      // Navigator.pop(context);
                      if (solarModuleType == SolarModuleType.digital) {
                        Navigator.popUntil(
                            context,
                            ModalRoute.withName(
                                AppRoutes.solarDigDesignDashboard));
                      } else {
                        Navigator.popUntil(
                            context,
                            ModalRoute.withName(
                                AppRoutes.solarPhyDesignDashboard));
                      }
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
