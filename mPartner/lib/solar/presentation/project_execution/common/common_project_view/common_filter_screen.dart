import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../../utils/app_colors.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../presentation/screens/base_screen.dart';
import '../../../../../presentation/screens/network_management/dealer_electrician/components/heading_dealer.dart';
import '../../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../../presentation/widgets/common_button.dart';
import '../../../../../presentation/widgets/common_white_button.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../state/controller/ProjectExecutionFormController.dart';
import '../../../../state/controller/ProjectExecutionRequestListController.dart';
import '../../../../utils/solar_app_constants.dart';
import '../../../common/heading_solar.dart';

class ProjectExecutionCommonFilter extends StatefulWidget {
  final String typeValue;

  const ProjectExecutionCommonFilter(
    this.typeValue, {
    super.key,
  });

  @override
  State<ProjectExecutionCommonFilter> createState() =>
      _ProjectExecutionCommonFilterState();
}

class _ProjectExecutionCommonFilterState
    extends BaseScreenState<ProjectExecutionCommonFilter> {
  bool isFilterButtonEnabled = false;
  bool resolvedCheckBox = false;
  bool inProgressCheckBox = false;
  bool rescheduledCheckBox = false;
  List<Widget> widgets = [];
  List<String> supportReason = [];
  List<bool> isSupportReasonSelected = [];

  ProjectExecutionFormController projectExecutionFormController = Get.find();
  ProjectExecutionRequestListController projectExecutionRequestListController =
      Get.find();

  @override
  void initState() {
    super.initState();
    projectExecutionFormController.supportReasonList.forEach((element) {
      supportReason.add(element.reason);
      isSupportReasonSelected.add(false);
    });
    if(projectExecutionRequestListController.isFilterButtonEnabled.value){
      isFilterButtonEnabled=true;
      List<String> selectedSupportreasonList=projectExecutionRequestListController.finalSupportReasonString.split(",");
      if(selectedSupportreasonList.isNotEmpty){
        int i=0;
        supportReason.forEach((element) {
          selectedSupportreasonList.forEach((selected) {
            if(element==selected){
              isSupportReasonSelected[i]=true;
            }
          });
          i+=1;
        });

      }
      if(projectExecutionRequestListController.finalPEStatusString.toLowerCase().contains("resolved")){
        resolvedCheckBox=true;
      }
      if(projectExecutionRequestListController.finalPEStatusString.toLowerCase().contains("in progress")){
        inProgressCheckBox=true;
      }
      if(projectExecutionRequestListController.finalPEStatusString.toLowerCase().contains("rescheduled")){
        rescheduledCheckBox=true;
      }
    }
  }
  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      bottomNavigationBar:   Container(
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
                      clearChecks();
                    });
                    projectExecutionRequestListController.clearPaginationListData();
                    projectExecutionRequestListController
                        .finalPEStatusString.value = "";
                    projectExecutionRequestListController
                        .finalSupportReasonString.value = "";
                    projectExecutionRequestListController.isFilterButtonEnabled.value=false;
                    Navigator.of(context).pop();
                    if(projectExecutionRequestListController.selectedProjectTypeTab==SolarAppConstants.commercialCategory) {
                      projectExecutionRequestListController
                          .clearPaginationListData();
                      await projectExecutionRequestListController
                          .fetchProjectRequestList(
                          "Commercial",
                          projectExecutionRequestListController
                              .searchString.value,
                          projectExecutionRequestListController
                              .finalPEStatusString.value,
                          projectExecutionRequestListController
                              .finalSupportReasonString.value,
                          widget.typeValue);
                    }else {
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
                  isEnabled: isFilterButtonEnabled,
                  buttonText: translation(context).reset,
                  backGroundColor: AppColors.lightWhite1,
                  textColor: AppColors.blackText,
                  isGreyColor: isFilterButtonEnabled,
                ),
              ),
              Container(
                  width: 165 * w,
                  height: 50 * h,
                  child: CommonButton(
                    onPressed: () async {
                      String status = getSelectedstatus();
                      String supportReason = getSupportReason();
                      projectExecutionRequestListController
                          .finalPEStatusString.value = status;
                      projectExecutionRequestListController
                          .finalSupportReasonString.value = supportReason;
                      projectExecutionRequestListController.isFilterButtonEnabled.value=true;
                      Navigator.of(context).pop();
                      if(projectExecutionRequestListController.selectedProjectTypeTab==SolarAppConstants.commercialCategory) {
                        projectExecutionRequestListController
                            .clearPaginationListData();
                        await projectExecutionRequestListController
                            .fetchProjectRequestList(
                            "Commercial",
                            projectExecutionRequestListController
                                .searchString
                                .value,
                            projectExecutionRequestListController
                                .finalPEStatusString.value,
                            projectExecutionRequestListController
                                .finalSupportReasonString.value,
                            widget.typeValue);
                      }
                      else {
                        projectExecutionRequestListController
                            .clearPaginationListData();
                        await projectExecutionRequestListController
                            .fetchProjectRequestList(
                            "Residential",
                            projectExecutionRequestListController
                                .searchString
                                .value,
                            projectExecutionRequestListController
                                .finalPEStatusString.value,
                            projectExecutionRequestListController
                                .finalSupportReasonString.value,
                            widget.typeValue);
                      }
                    },
                    isEnabled: isFilterButtonEnabled,
                    buttonText: translation(context).apply,
                    withContainer: false,
                  ))
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                HeadingSolar(
                  heading: translation(context).filter,
                ),
                UserProfileWidget(
                  top: 8 * h,
                ),
              ],
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
                        translation(context).supportStatus,
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
                                      resolvedCheckBox = !resolvedCheckBox;
                                      checkFilterButtonEnable();
                                    });
                                  },
                                  child: Container(
                                    height: h * 40,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: resolvedCheckBox,
                                          activeColor:
                                              AppColors.lumiBluePrimary,
                                          onChanged: (value) {
                                            setState(() {
                                              resolvedCheckBox =
                                                  !resolvedCheckBox;
                                              checkFilterButtonEnable();
                                            });
                                          },
                                        ),
                                        Text(
                                          translation(context).resolved,
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
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      inProgressCheckBox = !inProgressCheckBox;
                                      checkFilterButtonEnable();
                                    });
                                  },
                                  child: Container(
                                    height: h * 40,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          activeColor:
                                              AppColors.lumiBluePrimary,
                                          value: inProgressCheckBox,
                                          onChanged: (value) {
                                            setState(() {
                                              inProgressCheckBox =
                                                  !inProgressCheckBox;
                                              checkFilterButtonEnable();
                                            });
                                          },
                                        ),
                                        Text(
                                          translation(context).inProgress,
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
                                      rescheduledCheckBox =
                                          !rescheduledCheckBox;
                                      checkFilterButtonEnable();
                                    });
                                  },
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: rescheduledCheckBox,
                                              activeColor:
                                                  AppColors.lumiBluePrimary,
                                              onChanged: (value) {
                                                setState(() {
                                                  rescheduledCheckBox =
                                                      !rescheduledCheckBox;
                                                  checkFilterButtonEnable();
                                                });
                                              },
                                            ),
                                            Text(
                                              translation(context).rescheduled,
                                              style: GoogleFonts.poppins(
                                                color: AppColors.darkGrey,
                                                fontSize: 16 * f,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.50,
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
                        translation(context).reasonForSupport,
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
                              itemCount: supportReason.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isSupportReasonSelected[index] =
                                          !isSupportReasonSelected[index];
                                      checkFilterButtonEnable();
                                    });
                                  },
                                  child: Container(
                                    height: h * 40,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isSupportReasonSelected[index],
                                          activeColor:
                                              AppColors.lumiBluePrimary,
                                          onChanged: (value) {
                                            setState(() {
                                              isSupportReasonSelected[index] =
                                                  !isSupportReasonSelected[
                                                      index];
                                              checkFilterButtonEnable();
                                            });
                                          },
                                        ),
                                        Text(
                                          supportReason[index],
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
            )),
        
          ],
        ),
      ),
    );
  }

  void checkFilterButtonEnable() {
    var isSupportChecked = false;
    isSupportReasonSelected.forEach((element) {
      if (element) {
        isSupportChecked = true;
      }
    });
    if (resolvedCheckBox ||
        inProgressCheckBox ||
        rescheduledCheckBox ||
        isSupportChecked) {
      isFilterButtonEnabled = true;
    } else {
      isFilterButtonEnabled = false;
    }
  }

  void clearChecks() {
    resolvedCheckBox = false;
    inProgressCheckBox = false;
    rescheduledCheckBox = false;
    isSupportReasonSelected.clear();
    supportReason.forEach((element) {
      isSupportReasonSelected.add(false);
    });
   setState(() {
     isFilterButtonEnabled=false;
   });
  }

  String getSelectedstatus() {
    String selectedStatus = "";
    if (resolvedCheckBox == true) {
      selectedStatus = "${selectedStatus}Resolved,";
    }
    if (inProgressCheckBox == true) {
      selectedStatus = "${selectedStatus}In Progress,";
    }
    if (rescheduledCheckBox == true) {
      selectedStatus = "${selectedStatus}Rescheduled,";
    }
    if (selectedStatus.isNotEmpty) {
      selectedStatus = selectedStatus.substring(0, selectedStatus.length - 1);
    }
    
    return selectedStatus;
  }

  String getSupportReason() {
    String supportReasonString = "";
    int i = 0;
    isSupportReasonSelected.forEach((element) {
      if (element) {
        if (supportReasonString.isEmpty) {
          supportReasonString = supportReason[i];
        } else {
          supportReasonString = supportReasonString+"," + supportReason[i];
        }
      }
      i += 1;
    });

    return supportReasonString;
  }
}
