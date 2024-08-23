import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../presentation/screens/base_screen.dart';
import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/common_button.dart';
import '../../../../presentation/widgets/common_white_button.dart';
import '../../../state/controller/digital_survey_request_list_controller.dart';
import '../../../state/controller/solar_design_request_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/heading_solar.dart';

class SolarDesignFilter extends StatefulWidget {
  final Function(bool filterEnabled) updateFilterIcon;
  final int currentTabIndex;
  final bool isDigOrPhy;

  const SolarDesignFilter({
    Key? key,
    required this.updateFilterIcon,
    required this.currentTabIndex,
    required this.isDigOrPhy
  }) : super(key: key);

  @override
  State<SolarDesignFilter> createState() => _SolarDesignFilterState();
}

class _SolarDesignFilterState extends BaseScreenState<SolarDesignFilter> {
  DigitalSurveyRequestListController digitalSurveyRequestListController = Get.find();
  SolarDesignRequestController solarDesignRequestController = Get.find();
  List solutionCheckbox = [];
  bool sharedCheckbox = false;
  bool pendingCheckbox = false;
  bool reassignedCheckbox = false;
  bool applyButtonEnable = false;

  @override
  void initState() {
    super.initState();
    initalizeData();
  }

  void initalizeData() {
    setState(() {
      sharedCheckbox = digitalSurveyRequestListController.designSharedSelected.value;
      pendingCheckbox = digitalSurveyRequestListController.designPendingSelected.value;
      reassignedCheckbox = digitalSurveyRequestListController.designReassignedSelected.value;
      solutionCheckbox.clear();
      digitalSurveyRequestListController.solutionTypeFilterList.forEach((element) {
        solutionCheckbox.add(element);
      });
      applyButtonEnable = digitalSurveyRequestListController.isFilterButtonEnabled.value;
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                HeadingSolar(
                  heading: translation(context).filter,
                ),
                UserProfileWidget(
                  top: 8 * h,
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.centerLeft,
                          initiallyExpanded: true,
                          title: Padding(
                            padding: EdgeInsets.fromLTRB(14 * w, 0, 14 * w, 0),
                            child: Text(
                              translation(context).designStatus,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkText2,
                                fontSize: 16 * f,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(14 * w, 0, 14 * w, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            sharedCheckbox = !sharedCheckbox;
                                            checkFilterButtonEnable();
                                          });
                                        },
                                        child: Container(
                                          height: h * 40,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: sharedCheckbox,
                                                activeColor: AppColors.lumiBluePrimary,
                                                onChanged: (value) {
                                                  setState(() {
                                                    sharedCheckbox = !sharedCheckbox;
                                                    checkFilterButtonEnable();
                                                  });
                                                },
                                              ),
                                              Expanded(
                                                child: Text(
                                                  translation(context).designShared,
                                                  maxLines: 10,
                                                  softWrap: true,
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.darkGrey,
                                                    fontSize: 16 * f,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.50,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            pendingCheckbox = !pendingCheckbox;
                                            checkFilterButtonEnable();
                                          });
                                        },
                                        child: Container(
                                          height: h * 40,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                activeColor: AppColors.lumiBluePrimary,
                                                value: pendingCheckbox,
                                                onChanged: (value) {
                                                  setState(() {
                                                    pendingCheckbox = !pendingCheckbox;
                                                    checkFilterButtonEnable();
                                                  });
                                                },
                                              ),
                                              Expanded(
                                                child: Text(
                                                  translation(context).designPending,
                                                  maxLines: 10,
                                                  softWrap: true,
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.darkGrey,
                                                    fontSize: 16 * f,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.50,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(14 * w, 0, 14 * w, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            reassignedCheckbox = !reassignedCheckbox;
                                            checkFilterButtonEnable();
                                          });
                                        },
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: reassignedCheckbox,
                                                    activeColor: AppColors.lumiBluePrimary,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        reassignedCheckbox = !reassignedCheckbox;
                                                        checkFilterButtonEnable();
                                                      });
                                                    },
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      translation(context).designReassigned,
                                                      maxLines: 10,
                                                      softWrap: true,
                                                      style: GoogleFonts.poppins(
                                                        color: AppColors.darkGrey,
                                                        fontSize: 16 * f,
                                                        fontWeight: FontWeight.w400,
                                                        letterSpacing: 0.50,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.centerLeft,
                          initiallyExpanded: true,
                          title: Padding(
                            padding: EdgeInsets.fromLTRB(14 * w, 0, 14 * w, 0),
                            child: Text(
                              translation(context).solutionType,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkText2,
                                fontSize: 16 * f,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(14 * w, 0, 14 * w, 0),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: solarDesignRequestController.solutionTypeListDesign.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      String solution = solarDesignRequestController.solutionTypeListDesign[index].name;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (!solutionCheckbox.contains(solution)) {
                                              solutionCheckbox.add(solution);
                                            } else {
                                              solutionCheckbox.remove(solution);
                                            }
                                            checkFilterButtonEnable();
                                          });
                                        },
                                        child: Container(
                                          height: h * 40,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value:  solutionCheckbox.contains(solution),
                                                activeColor: AppColors.lumiBluePrimary,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (!solutionCheckbox.contains(solution)) {
                                                      solutionCheckbox.add(solution);
                                                    } else {
                                                      solutionCheckbox.remove(solution);
                                                    }
                                                    checkFilterButtonEnable();
                                                  });
                                                },
                                              ),
                                              Text(
                                                solution,
                                                style: GoogleFonts.poppins(
                                                  color: AppColors.darkGrey,
                                                  fontSize: 16 * f,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.50,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: AppColors.lightWhite1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24 * w, 14 * h, 24 * w, 24 * h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 165 * w,
                        height: 50 * h,
                        child: CommonWhiteButton(
                          onPressed: () async {
                            setState(() {
                              resetFilter();
                            });
                            Navigator.of(context).pop();
                            digitalSurveyRequestListController.resetPagination();
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
                          buttonText: translation(context).reset,
                          backGroundColor: AppColors.lightWhite1,
                          textColor: AppColors.blackText,
                          isEnabled: applyButtonEnable || digitalSurveyRequestListController.isFilterButtonEnabled.value,
                          isGreyColor: applyButtonEnable || digitalSurveyRequestListController.isFilterButtonEnabled.value
                        ),
                      ),
                      Container(
                          width: 165 * w,
                          height: 50 * h,
                          child: CommonButton(
                            onPressed: () async {
                              setState(() {
                                applyFilter();
                              });
                              Navigator.of(context).pop();
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
                            isEnabled: applyButtonEnable,
                            buttonText: translation(context).apply,
                            withContainer: false,
                          )
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkFilterButtonEnable() {
    if (sharedCheckbox ||
        pendingCheckbox ||
        reassignedCheckbox ||
        solutionCheckbox.isNotEmpty) {
      applyButtonEnable = true;
    } else {
      applyButtonEnable = false;
    }
  }

  void resetFilter() {
    solutionCheckbox.clear();
    sharedCheckbox = false;
    pendingCheckbox = false;
    reassignedCheckbox = false;
    digitalSurveyRequestListController.isFilterButtonEnabled.value = false;
    digitalSurveyRequestListController.designSharedSelected.value = false;
    digitalSurveyRequestListController.designPendingSelected.value = false;
    digitalSurveyRequestListController.designReassignedSelected.value = false;
    digitalSurveyRequestListController.solutionTypeFilterList.clear();
    digitalSurveyRequestListController.designStatusList.clear();
    digitalSurveyRequestListController.finalSolutionTypeString.value = '';
    digitalSurveyRequestListController.finalDesignStatusString.value = '';
    checkFilterButtonEnable();
    widget.updateFilterIcon(digitalSurveyRequestListController.isFilterButtonEnabled.value);
  }

  void applyFilter() {
    digitalSurveyRequestListController.designSharedSelected.value = sharedCheckbox;
    digitalSurveyRequestListController.designPendingSelected.value = pendingCheckbox;
    digitalSurveyRequestListController.designReassignedSelected.value = reassignedCheckbox;
    digitalSurveyRequestListController.solutionTypeFilterList.value = solutionCheckbox;
    digitalSurveyRequestListController.isFilterButtonEnabled.value = applyButtonEnable;
    widget.updateFilterIcon(digitalSurveyRequestListController.isFilterButtonEnabled.value);
  }
}
