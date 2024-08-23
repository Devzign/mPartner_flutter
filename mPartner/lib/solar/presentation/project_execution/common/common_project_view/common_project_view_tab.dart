import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../presentation/screens/network_management/dealer_electrician/components/heading_dealer.dart';
import '../../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../../presentation/widgets/tab_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/ProjectExecutionRequestListController.dart';
import '../../../../utils/solar_app_constants.dart';
import '../../../common/heading_solar.dart';
import 'common_project_details_card.dart';
import 'common_request_tracking_page.dart';

class CommonProjectDetailTabView extends StatefulWidget {
  final String typeValue;
  final String projectId;
  final String isFrom;

  const CommonProjectDetailTabView(
      {super.key,
      required this.typeValue,
      required this.projectId,
      required this.isFrom});

  @override
  State<CommonProjectDetailTabView> createState() =>
      _CommonProjectDetailTabViewState();
}

class _CommonProjectDetailTabViewState extends State<CommonProjectDetailTabView>
    with TickerProviderStateMixin {
  final int initialIndex = 0;
  TabController? _tabController;

  bool isTabClickAction = false;

  TextEditingController searchController = TextEditingController();
  List<TabData> tabs = [];
  ProjectExecutionRequestListController projectExecutionRequestListController =
      Get.find();

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    projectExecutionRequestListController.selectedProjectTypeTab =
        SolarAppConstants.residentialCategory;
  }

  void callListAPI() async {
    if (projectExecutionRequestListController.selectedProjectTypeTab ==
        SolarAppConstants.commercialCategory) {
      projectExecutionRequestListController.clearPaginationListData();
      await projectExecutionRequestListController.fetchProjectRequestList(
          "Commercial",
          projectExecutionRequestListController.searchString.value,
          projectExecutionRequestListController.finalPEStatusString.value,
          projectExecutionRequestListController.finalSupportReasonString.value,
          widget.typeValue);
    } else {
      projectExecutionRequestListController.clearPaginationListData();
      await projectExecutionRequestListController.fetchProjectRequestList(
          "Residential",
          projectExecutionRequestListController.searchString.value,
          projectExecutionRequestListController.finalPEStatusString.value,
          projectExecutionRequestListController.finalSupportReasonString.value,
          widget.typeValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    tabs = [
      TabData(
          translation(context).details,
          CommonDetailedViewCard(
              projectId: widget.projectId,
              typePEValue: widget.typeValue,
              isFrom: widget.isFrom)),
      TabData(
          translation(context).requestTracking,
          CommonRequestTrackingPage(
            typeValue: widget.typeValue,
            projectId: widget.projectId,
            isFrom: SolarAppConstants.fromDashboard,
          )),
    ];
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
                heading: getTitle(widget.typeValue),
              ),
              UserProfileWidget(
                top: 8 * h,
              ),
              TabWidget(
                initialIndex: initialIndex,
                tabs: tabs,
                controller: _tabController,
              ),
            ],
          ),
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
}
