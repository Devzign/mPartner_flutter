import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../presentation/widgets/tab_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../state/controller/digital_survey_request_list_controller.dart';
import '../../../state/controller/solar_design_request_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/heading_solar.dart';
import '../design_request_form/design_request_form.dart';
import 'residential_view_page.dart';
import 'commercial_view_page.dart';
import 'solar_design_filter.dart';

class ExistingLeadTabView extends StatefulWidget {
  final bool isDigOrPhy;
  final bool naviagtedWithFilterApplied;

  const ExistingLeadTabView({
    Key? key,
    required this.isDigOrPhy,
    required this.naviagtedWithFilterApplied
  }) : super(key: key);

  @override
  State<ExistingLeadTabView> createState() => _ExistingLeadTabViewState();
}

class _ExistingLeadTabViewState extends State<ExistingLeadTabView> {
  final int initialIndex = 0;
  TextEditingController searchController = TextEditingController();
  List<TabData> tabs = [];
  DigitalSurveyRequestListController digitalSurveyRequestListController = Get.find();
  SolarDesignRequestController solarDesignRequestController = Get.find();

  @override
  void initState() {
    super.initState();
    if(solarDesignRequestController.solutionTypeListDesign.isEmpty){
        solarDesignRequestController.getSolutionTypes(SolutionTypes.SolarDesignSolutionType.name);
      }
    if (widget.naviagtedWithFilterApplied == false) {
      digitalSurveyRequestListController.searchString.value = searchController.text;
      digitalSurveyRequestListController.designSharedSelected.value = false;
      digitalSurveyRequestListController.designPendingSelected.value = false;
      digitalSurveyRequestListController.designReassignedSelected.value = false;
      digitalSurveyRequestListController.solutionTypeFilterList.clear();
      digitalSurveyRequestListController.designStatusList.clear();
      digitalSurveyRequestListController.isFilterButtonEnabled.value = false;
      digitalSurveyRequestListController.finalDesignStatusString.value = "";
      digitalSurveyRequestListController.finalSolutionTypeString.value = "";
    }
  }

  void updateFilterIcon (bool filterEnabled) {
    setState(() {
      digitalSurveyRequestListController.isFilterButtonEnabled.value = filterEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    tabs = [
      TabData(translation(context).residential, ResidentialViewPage(isDigOrPhy: widget.isDigOrPhy)),
      TabData(translation(context).commercial, CommercialViewPage(isDigOrPhy: widget.isDigOrPhy)),
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
                    DesignRequestForm(solarModuleType: widget.isDigOrPhy ? SolarModuleType.digital : SolarModuleType.physical,)));
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 110*w,right: 80*w,bottom: 30*h),
            height: 50 * h,
            decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.all(
                    Radius.circular(24 * r))),
            child: Text(translation(context).raiseDesignRequest,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 14 *f,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                )),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              HeadingSolar(
                heading: widget.isDigOrPhy ? translation(context).digitalDesigning : translation(context).physicalVisitAndDesigning,
              ),
              UserProfileWidget(
                top: 8 * h,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 24 * w,
                  right: 24 * w,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: w * 297,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.lightWhite1,
                          borderRadius: BorderRadius.circular(8 * r),
                          border: Border.all(
                            color: AppColors.lightGrey1,
                            width: 1 * w,
                          ),
                        ),
                        child: Row(
                          children: [
                            HorizontalSpace(width: 15),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(SolarAppConstants.NO_LEADING_SPACE_REGEX),
                                ],
                                maxLength: SolarAppConstants.existingLeadsSearchLength,
                                style: GoogleFonts.poppins(
                                  color: AppColors.darkGreyText,
                                  fontSize: 12 * f,
                                  fontWeight: FontWeight.w400,
                                ),
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                onChanged: (value) async {
                                  setState(() {
                                    digitalSurveyRequestListController.searchString.value = searchController.text;
                                  });
                                  if (digitalSurveyRequestListController.searchString.value.isEmpty) {
                                    digitalSurveyRequestListController.resetPagination();
                                    await digitalSurveyRequestListController.addAndRemoveValuesToList();
                                    await digitalSurveyRequestListController.fetchDigitalSurveyRequestList(
                                        SolarAppConstants.residentialCategory,
                                        digitalSurveyRequestListController.searchString.value,
                                        digitalSurveyRequestListController.finalDesignStatusString.value,
                                        digitalSurveyRequestListController.finalSolutionTypeString.value,
                                        widget.isDigOrPhy
                                    );
                                    await digitalSurveyRequestListController.fetchDigitalSurveyRequestList(
                                        SolarAppConstants.commercialCategory,
                                        digitalSurveyRequestListController.searchString.value,
                                        digitalSurveyRequestListController.finalDesignStatusString.value,
                                        digitalSurveyRequestListController.finalSolutionTypeString.value,
                                        widget.isDigOrPhy
                                    );
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: translation(context).search,
                                  hintStyle: GoogleFonts.poppins(
                                    color: AppColors.lightGreyBorder,
                                    fontSize: f * 12,
                                    fontWeight: FontWeight.w400,
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
                                width: 1 * w,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                digitalSurveyRequestListController.resetPagination();
                                await digitalSurveyRequestListController.addAndRemoveValuesToList();
                                await digitalSurveyRequestListController.fetchDigitalSurveyRequestList(
                                    SolarAppConstants.residentialCategory,
                                    digitalSurveyRequestListController.searchString.value,
                                    digitalSurveyRequestListController.finalDesignStatusString.value,
                                    digitalSurveyRequestListController.finalSolutionTypeString.value,
                                    widget.isDigOrPhy
                                );
                                await digitalSurveyRequestListController.fetchDigitalSurveyRequestList(
                                    SolarAppConstants.commercialCategory,
                                    digitalSurveyRequestListController.searchString.value,
                                    digitalSurveyRequestListController.finalDesignStatusString.value,
                                    digitalSurveyRequestListController.finalSolutionTypeString.value,
                                    widget.isDigOrPhy
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8 * w,
                                    right: 8 * w,
                                    top: 0),
                                child: Icon(
                                  Icons.search,
                                  size: 20 * r,
                                  color: searchController.text.isNotEmpty
                                      ? AppColors.lumiBluePrimary
                                      : AppColors.grayText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SolarDesignFilter(
                                  updateFilterIcon: updateFilterIcon,
                                  currentTabIndex: digitalSurveyRequestListController.insideResiOrComm.value ? 0 : 1,
                                  isDigOrPhy: widget.isDigOrPhy,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            width: w * 41,
                            decoration: BoxDecoration(
                              color: AppColors.lightWhite1,
                              borderRadius: BorderRadius.circular(
                                  8 * r),
                              border: Border.all(
                                color: AppColors.lightGrey1,
                                width: 1 * w,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                digitalSurveyRequestListController.isFilterButtonEnabled.value
                                    ? Icons.filter_alt
                                    : Icons.filter_alt_outlined,
                                size: 24 * r,
                                color: digitalSurveyRequestListController.isFilterButtonEnabled.value
                                    ? AppColors.lumiBluePrimary
                                    : AppColors.blackText,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10 * h,
              ),
              TabWidget(
                initialIndex: initialIndex,
                tabs: tabs,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
