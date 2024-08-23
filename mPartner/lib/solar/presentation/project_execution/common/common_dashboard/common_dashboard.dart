import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../presentation/screens/base_screen.dart';
import '../../../../../presentation/screens/network_management/dealer_electrician/components/heading_dealer.dart';
import '../../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/ProjectExecutionFormController.dart';
import '../../../../state/controller/ProjectExecutionRequestListController.dart';
import '../../../../state/controller/project_execution_dashboard_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/solar_app_constants.dart';
import '../../../common/dashboard/dashboard.dart';
import '../../../common/heading_solar.dart';
import '../../../common/help_support_widget.dart';
import '../common_project_view/common_existing_lead_tab.dart';
import '../common_raise_request_form/common_raise_request_form.dart';

class ProjectExecutionCommonDashboardPage extends StatefulWidget {
  final String typeName;
  final String typeValue;

  const ProjectExecutionCommonDashboardPage(
      {super.key, required this.typeName, required this.typeValue});

  @override
  State<ProjectExecutionCommonDashboardPage> createState() =>
      _ProjectExecutionCommonDashboardPageState();
}

class _ProjectExecutionCommonDashboardPageState
    extends BaseScreenState<ProjectExecutionCommonDashboardPage> {
  ProjectExecutionDashboardController projectExecutionDashboardController =
      ProjectExecutionDashboardController();
  ProjectExecutionFormController projectExecutionFormController = Get.find();
  String typeName = "";
  String typeValue = "";
  String routeName = "";

  @override
  void initState() {
    super.initState();
    if(widget.typeName.isEmpty && widget.typeValue.isEmpty){
      typeName = projectExecutionFormController.typeName.value;
      typeValue = projectExecutionFormController.typeValue.value;
    }
    else{
      typeName=widget.typeName;
      typeValue=widget.typeValue;
      projectExecutionFormController.typeName.value = widget.typeName;
      projectExecutionFormController.typeValue.value = widget.typeValue;
    }
    projectExecutionDashboardController
        .fetchProjectExecutionDashboardData(typeValue);
    _getRouteName();
  }

  void _getRouteName() {
    if (typeValue == SolarAppConstants.online) {
      routeName = SolarAppConstants.peOnlineRouteName;
    } else if (typeValue == SolarAppConstants.onsite) {
      routeName = SolarAppConstants.peOnsiteRouteName;
    } else if (typeValue == SolarAppConstants.endToEnd) {
      routeName = SolarAppConstants.peEndToEndRouteName;
    }
  }

  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeadingSolar(
                heading: translation(context).installationText,
              ),
              UserProfileWidget(
                top: 8 * h,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 24 * w, right: 24 * w, top: 4 * h, bottom: 10 * h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      typeName,
                      style: GoogleFonts.poppins(
                        color: AppColors.blackText,
                        fontSize: 16 * f,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        goToExistingLeadScreen("");
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(
                            left: 8.0 * w, top: 8 * h, bottom: 4 * h),
                        child: Icon(
                          Icons.chevron_right,
                          size: 28 * r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () {
                  if (projectExecutionDashboardController.isLoading.value) {
                    return CircularProgressIndicator();
                  } else if (projectExecutionDashboardController
                      .error.isNotEmpty) {
                    return Container();
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(left: 20.0 * w,right: 20.0 * w, bottom: 20.0 * h, top: 10.0 * h),
                      child: SolarDashboard(
                        oneByThreePeice: DashboardDataPeice(
                            integerColor: AppColors.solarTotalCount,
                            value: projectExecutionDashboardController
                                .totalRequestCount.value,
                            label: translation(context).totalRequests,
                            onCardClick: () {
                              goToExistingLeadScreen("");
                            }),
                        firstOneByOnePeice: DashboardDataPeice(
                            integerColor: AppColors.solarDesignSharedCount,
                            value: projectExecutionDashboardController
                                .resolvedCount.value,
                            label: translation(context).resolved,
                            onCardClick: () {
                              goToExistingLeadScreen("Resolved");
                            }),
                        secondOneByOnePeice: DashboardDataPeice(
                            integerColor: AppColors.solarDesignPendingCount,
                            value: projectExecutionDashboardController
                                .inProgressCount.value,
                            label: translation(context).inProgress,
                            onCardClick: () {
                              goToExistingLeadScreen("In Progress");
                            }),
                        thirdOneByOnePeice: DashboardDataPeice(
                            integerColor: AppColors.solarDesignReassignedCount,
                            value: projectExecutionDashboardController
                                .rescheduledCount.value,
                            label: translation(context).rescheduled,
                            onCardClick: () {
                              goToExistingLeadScreen("Rescheduled");
                            }),
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 20 * h,
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CommonRaiseRequestForm(typeValue: typeValue)));
                  projectExecutionDashboardController
                      .fetchProjectExecutionDashboardData(typeValue);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 56 * h,
                  width: 247 * w,
                  decoration: BoxDecoration(
                      color: AppColors.darkBlue,
                      borderRadius: BorderRadius.all(Radius.circular(24 * r))),
                  child: Text(translation(context).raiseRequest,
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 14 * f,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      )),
                ),
              ),
              Spacer(),
              HelpSupportWidget(previousRoute: routeName),
              VerticalSpace(height: 32)
            ],
          ),
        ),
      ),
    );
  }

  void goToExistingLeadScreen(String selectedCardStatus) async {
    ProjectExecutionRequestListController projectExecutionRequestListController =  Get.find();
    projectExecutionRequestListController.finalSupportReasonString.value = "";
    projectExecutionRequestListController.isFilterButtonEnabled.value = false;
    projectExecutionRequestListController.searchString.value ="";
    projectExecutionRequestListController.finalPEStatusString.value = selectedCardStatus;
    projectExecutionRequestListController.clearPaginationListData();
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CommonExistingLeadTabView(typeValue: typeValue)));
    projectExecutionDashboardController
        .fetchProjectExecutionDashboardData(typeValue);
  }
}
