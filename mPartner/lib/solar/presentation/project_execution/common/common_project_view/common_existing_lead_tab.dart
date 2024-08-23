import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../presentation/screens/network_management/dealer_electrician/components/heading_dealer.dart';
import '../../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../../presentation/widgets/tab_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/ProjectExecutionRequestListController.dart';
import '../../../../utils/solar_app_constants.dart';
import '../../../common/heading_solar.dart';
import '../../../solar_design/existing_leads/solar_design_filter.dart';
import '../common_raise_request_form/common_raise_request_form.dart';
import 'common_commercial_view_page.dart';
import 'common_filter_screen.dart';
import 'common_residential_view_page.dart';

class CommonExistingLeadTabView extends StatefulWidget {
  final String typeValue;

  const CommonExistingLeadTabView({super.key, required this.typeValue});

  @override
  State<CommonExistingLeadTabView> createState() => _ExistingLeadTabViewState();
}

class _ExistingLeadTabViewState extends State<CommonExistingLeadTabView> with TickerProviderStateMixin {
  final int initialIndex = 0;
  TabController? _tabController ;
  bool isTabClickAction=false;

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
    projectExecutionRequestListController.selectedProjectTypeTab=SolarAppConstants.residentialCategory;
    _tabController?.addListener(() {
      if(_tabController?.index==0){
        projectExecutionRequestListController.selectedProjectTypeTab=SolarAppConstants.residentialCategory;
      }
      else{
        projectExecutionRequestListController.selectedProjectTypeTab=SolarAppConstants.commercialCategory;
      }
      logger.d("*****Tab index changed ${_tabController?.index} .....  Prev index ${_tabController?.previousIndex}");
      if (_tabController?.indexIsChanging == true) {
        // Tab Changed tapping on new tab
        isTabClickAction=true; //control the twice time API hit
        logger.d("*****Tab controller index changed");
        projectExecutionRequestListController.clearPaginationListData();

      } else if (_tabController?.index != _tabController?.previousIndex) {
        // Tab Changed swiping to a new tab
        logger.d(
            "*****Tab controller current index and previous index both are not same");
        if(!isTabClickAction) {
          callListAPI();
        }
        else{
          isTabClickAction=false;
        }
      } else {
        logger.d("*****Tab current index and previous index both are same");
      }
    });

    if(projectExecutionRequestListController.finalPEStatusString.value.isNotEmpty) {
      projectExecutionRequestListController.isFilterButtonEnabled.value=true;
    }

  }


  void callListAPI() async{
    if(projectExecutionRequestListController.selectedProjectTypeTab==SolarAppConstants.commercialCategory){
      projectExecutionRequestListController.clearPaginationListData();
      await projectExecutionRequestListController.fetchProjectRequestList(
          "Commercial",
          projectExecutionRequestListController.searchString.value,
          projectExecutionRequestListController.finalPEStatusString.value,
          projectExecutionRequestListController.finalSupportReasonString.value,
          widget.typeValue);
    }
    else {
      projectExecutionRequestListController
          .clearPaginationListData();
      await projectExecutionRequestListController
          .fetchProjectRequestList(
          "Residential",
          projectExecutionRequestListController
              .searchString.value,
          projectExecutionRequestListController
              .finalPEStatusString.value,
          projectExecutionRequestListController
              .finalSupportReasonString.value,
          widget.typeValue);
    }
  }

  void updateFilterIcon(bool filterEnabled) {
    setState(() {
      projectExecutionRequestListController.isFilterButtonEnabled.value =
          filterEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    tabs = [
      TabData(translation(context).residential,
          CommonResidentialViewPage(typeValue: widget.typeValue)),
      TabData(
          translation(context).commercial, CommonCommercialViewPage(typeValue: widget.typeValue)),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CommonRaiseRequestForm(typeValue: widget.typeValue)));
          },
          child: Container(
            alignment: Alignment.center,
            margin:
                EdgeInsets.only(left: 120 * w, right: 80 * w, bottom: 30 * h),
            height: 50 * h,
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
        body: SafeArea(
          child: Column(
            children: [
              HeadingSolar(
                heading: getTitle(widget.typeValue),
              ),
              UserProfileWidget(
                top: 8 * h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * w),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          width: w * 297,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.lightWhite1,
                            borderRadius: BorderRadius.circular(8 * r),
                            border: Border.all(
                              color: AppColors.white_234,
                              width: 1 * w,
                            ),
                          ),
                          child: Row(
                            children: [
                              HorizontalSpace(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  textInputAction: TextInputAction.search,
                                  maxLength: SolarAppConstants.existingLeadsSearchLength,
                                  maxLines: 1,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9a-zA-Z ]")),
                                  ],
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGreyText,
                                    fontSize: 11 * f,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  onChanged: (value) {
                                    projectExecutionRequestListController.searchString.value = searchController.text;
                                  },
                                  enabled: true,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: translation(context).search,
                                    hintStyle: GoogleFonts.poppins(
                                      color: AppColors.lightGreyBorder,
                                      fontSize: f * 11,
                                      fontWeight: FontWeight.w400,
                                      height: 20 / 11,
                                      letterSpacing: 0.50,
                                    ),
                                    counterText: "",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5 * h,
                                    bottom: 5 * h),
                                child: VerticalDivider(
                                  color: AppColors.lightGrey1,
                                  width: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8 * h,
                                    right: 8 * h,
                                    top: 0),
                                child: GestureDetector(
                                  onTap: () async{
                                    FocusScope.of(context).unfocus();
                                    if(projectExecutionRequestListController.selectedProjectTypeTab==SolarAppConstants.commercialCategory){
                                      projectExecutionRequestListController.clearPaginationListData();
                                      await projectExecutionRequestListController.fetchProjectRequestList(
                                          "Commercial",
                                          projectExecutionRequestListController.searchString.value,
                                          projectExecutionRequestListController.finalPEStatusString.value,
                                          projectExecutionRequestListController.finalSupportReasonString.value,
                                          widget.typeValue);
                                    }
                                    else {
                                      projectExecutionRequestListController
                                          .clearPaginationListData();
                                      await projectExecutionRequestListController
                                          .fetchProjectRequestList(
                                          "Residential",
                                          projectExecutionRequestListController
                                              .searchString.value,
                                          projectExecutionRequestListController
                                              .finalPEStatusString.value,
                                          projectExecutionRequestListController
                                              .finalSupportReasonString.value,
                                          widget.typeValue);
                                    }
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 8 * w,
                                          right: 8 * w,
                                          top: 0),
                                      child: Icon(
                                        Icons.search,
                                        size: 20 * r,
                                        color: searchController.text.isNotEmpty ? AppColors.lumiBluePrimary : AppColors.grayText,
                                      ),
                                ),),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8 * w),
                      Obx(() =>  Container(
                        padding: EdgeInsets.only(top: 8 * h,bottom: 8*h),
                        width: 40 * w,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1 * w,
                                color: projectExecutionRequestListController.isFilterButtonEnabled.value
                                    ? AppColors.lumiBluePrimary
                                    : AppColors.white_234),
                            borderRadius: BorderRadius.circular(8 * r),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProjectExecutionCommonFilter(widget.typeValue)));
                          },
                          child: Center(
                              child: Icon(
                                projectExecutionRequestListController.isFilterButtonEnabled.value
                                    ? Icons.filter_alt
                                    : Icons.filter_alt_outlined,
                                color: projectExecutionRequestListController.isFilterButtonEnabled.value
                                    ? AppColors.lumiBluePrimary
                                    : AppColors.blackText,
                              )),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15 * h,
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
