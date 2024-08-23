import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../presentation/widgets/common_button.dart';
import '../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../state/controller/digital_survey_request_list_controller.dart';
import '../../state/controller/solar_design_count_details_controller.dart';
import '../../utils/solar_app_constants.dart';
import '../common/dashboard/dashboard.dart';
import '../common/heading_solar.dart';
import '../common/help_support_widget.dart';
import 'design_request_form/design_request_form.dart';
import 'existing_leads/existing_lead_tab_view.dart';

class DigitalSurveyDashboardPage extends StatefulWidget {
  const DigitalSurveyDashboardPage({required this.isDigOrPhy,super.key});
  final bool isDigOrPhy;

  @override
  State<DigitalSurveyDashboardPage> createState() =>
      _DigitalSurveyDashboardPageState();
}

class _DigitalSurveyDashboardPageState extends BaseScreenState<DigitalSurveyDashboardPage> {
  SolarDesignCountDetailsController solarDesignCountDetailsController = Get.find();
  DigitalSurveyRequestListController digitalSurveyRequestListController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      solarDesignCountDetailsController.clearSolarDesignCountDetailsController();
      solarDesignCountDetailsController.fetchSolarDesignCountDetails(widget.isDigOrPhy);
    });
  }


  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeadingSolar(
                heading: translation(context).solutionDesigning,
              ),
              UserProfileWidget(
                top: 8 * h,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 24 * w,
                  right: 24 * w,
                  bottom:  5 * h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        (widget.isDigOrPhy)
                            ? translation(context).digitalDesigning
                            : translation(context).physicalVisitAndDesigning,
                        maxLines: 10,
                        softWrap: true,
                        style: GoogleFonts.poppins(
                          color: AppColors.blackText,
                          fontSize: 16 * f,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                              ExistingLeadTabView(
                                isDigOrPhy: widget.isDigOrPhy,
                                naviagtedWithFilterApplied: false,
                              )
                          )
                        );
                      },
                      child: Container(
                        height: 24 * h,
                        width: 24 * w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.chevron_right,size: 24*r,),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (solarDesignCountDetailsController.isLoading.value) {
                  return Container(
                     height: 420 * h,
                      child: Center(child: CircularProgressIndicator())
                  );
                } else if (solarDesignCountDetailsController.error.isNotEmpty) {
                  return Container();
                } else {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20 * w,
                          right: 20 * w,
                          top: 8 * h,
                          bottom: 8 * h
                        ),
                        child: SolarDashboard(
                          oneByThreePeice: DashboardDataPeice(
                              integerColor: AppColors.solarTotalCount,
                              value: solarDesignCountDetailsController.totalDesignRequestsCount.value,
                              label: translation(context).totalDesignRequests,
                              onCardClick: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                      ExistingLeadTabView(
                                        isDigOrPhy: widget.isDigOrPhy,
                                        naviagtedWithFilterApplied: false,
                                      )
                                  )
                                );
                              }),
                          firstOneByOnePeice: DashboardDataPeice(
                              integerColor: AppColors.solarDesignSharedCount,
                              value: solarDesignCountDetailsController.designsSharedCount.value,
                              label: translation(context).designsShared,
                              onCardClick: () async {
                                digitalSurveyRequestListController.designSharedSelected.value = true;
                                digitalSurveyRequestListController.isFilterButtonEnabled.value = true;
          
                                digitalSurveyRequestListController.searchString.value = "";
                                digitalSurveyRequestListController.designPendingSelected.value = false;
                                digitalSurveyRequestListController.designReassignedSelected.value = false;
                                digitalSurveyRequestListController.solutionTypeFilterList.clear();
                                digitalSurveyRequestListController.designStatusList.clear();
                                digitalSurveyRequestListController.finalDesignStatusString.value = "";
                                digitalSurveyRequestListController.finalSolutionTypeString.value = "";
          
                                await digitalSurveyRequestListController.addAndRemoveValuesToList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                      ExistingLeadTabView(
                                        isDigOrPhy: widget.isDigOrPhy,
                                        naviagtedWithFilterApplied: true,
                                      )
                                  )
                                );
                              }),
                          secondOneByOnePeice: DashboardDataPeice(
                              integerColor: AppColors.solarDesignPendingCount,
                              value: solarDesignCountDetailsController.designsPendingCount.value,
                              label: translation(context).designsPending,
                              onCardClick: () async {
                                digitalSurveyRequestListController.designPendingSelected.value = true;
                                digitalSurveyRequestListController.isFilterButtonEnabled.value = true;
          
                                digitalSurveyRequestListController.searchString.value = "";
                                digitalSurveyRequestListController.designSharedSelected.value = false;
                                digitalSurveyRequestListController.designReassignedSelected.value = false;
                                digitalSurveyRequestListController.solutionTypeFilterList.clear();
                                digitalSurveyRequestListController.designStatusList.clear();
                                digitalSurveyRequestListController.finalDesignStatusString.value = "";
                                digitalSurveyRequestListController.finalSolutionTypeString.value = "";
          
                                await digitalSurveyRequestListController.addAndRemoveValuesToList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                      ExistingLeadTabView(
                                        isDigOrPhy: widget.isDigOrPhy,
                                        naviagtedWithFilterApplied: true,
                                      )
                                  )
                                );
                              }),
                          thirdOneByOnePeice: DashboardDataPeice(
                              integerColor: AppColors.solarDesignReassignedCount,
                              value: solarDesignCountDetailsController.designReassignedCount.value,
                              label: translation(context).designsReassigned,
                              onCardClick: () async {
                                digitalSurveyRequestListController.designReassignedSelected.value = true;
                                digitalSurveyRequestListController.isFilterButtonEnabled.value = true;
          
                                digitalSurveyRequestListController.searchString.value = "";
                                digitalSurveyRequestListController.designSharedSelected.value = false;
                                digitalSurveyRequestListController.designPendingSelected.value = false;
                                digitalSurveyRequestListController.solutionTypeFilterList.clear();
                                digitalSurveyRequestListController.designStatusList.clear();
                                digitalSurveyRequestListController.finalDesignStatusString.value = "";
                                digitalSurveyRequestListController.finalSolutionTypeString.value = "";
          
                                await digitalSurveyRequestListController.addAndRemoveValuesToList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                      ExistingLeadTabView(
                                        isDigOrPhy: widget.isDigOrPhy,
                                        naviagtedWithFilterApplied: true,
                                      )
                                  )
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20 * h,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 24 * w, right: 24 * w),
                        // margin: EdgeInsets.only(left: 18 * w, right: 18 * w),
                        child: CommonButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DesignRequestForm(solarModuleType: (widget.isDigOrPhy==true)?SolarModuleType.digital: SolarModuleType.physical,)));
                            },
                            isEnabled: true,
                            containerBackgroundColor: AppColors.white,
                            buttonText: (widget.isDigOrPhy) ? translation(context).raiseDigitalDesignRequest : translation(context).raisePhysicalDesignRequest
                        ),
                      ),
                    ],
                  );
                }
              }),
              Spacer(),
              HelpSupportWidget(previousRoute: (widget.isDigOrPhy) ? SolarAppConstants.digitalDesRouteName : SolarAppConstants.physicalDesRouteName),
              VerticalSpace(height: 32)
              /* GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: 45 * PixelValues.pixHeight,
                  width: 220 * PixelValues.pixWidth,
                  decoration: BoxDecoration(
                      color: AppColors.darkBlue,
                      borderRadius: BorderRadius.all(
                          Radius.circular(24 * PixelValues.pixRadius))),
                  child: Text("Raise Design Request",
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 14 * PixelValues.pixFontSize,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      )),
                ),
              ),*/
          
            ],
          ),
        ),
      ),
    );
  }
}
