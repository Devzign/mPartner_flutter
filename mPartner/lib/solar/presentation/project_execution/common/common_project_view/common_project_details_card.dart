import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../presentation/widgets/buttons/secondary_button.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/utils.dart';
import '../../../../state/controller/ProjectExecutionRequestListController.dart';
import '../../../../utils/solar_app_constants.dart';
import '../../../solar_design/existing_leads/view_3d_model_webview.dart';
import '../../model/project_execution_detail_model.dart';
import '../common_reschedule/common_reschedule_request_page.dart';
import 'common_detail_summary_card.dart';

class CommonDetailedViewCard extends StatefulWidget {
  final String projectId;
  final String typePEValue;
  final String isFrom;

  const CommonDetailedViewCard({
    super.key,
    required this.projectId,
    required this.typePEValue,
    required this.isFrom,
  });

  @override
  State<CommonDetailedViewCard> createState() => _CommonDetailedViewCardState();
}

class _CommonDetailedViewCardState extends State<CommonDetailedViewCard> {
  ProjectExecutionRequestListController projectExecutionRequestListController =
      Get.find();
  String view3DUrl = "";
  String pdfUrl = "";
  // String resolvedRemark = "";
  ProjectExecutionRequestDetail? peRequestDataList;
  var status = ["resolved", "in-progress", "rescheduled"];

  @override
  void initState() {
    super.initState();
    getProjectDetailsById();
  }

  void getProjectDetailsById() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      projectExecutionRequestListController.peRequestDataList.clear();
      await projectExecutionRequestListController
          .fetchPERequestDetailByProjectId(widget.projectId);
    });

  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(child: Obx(() {
                if (projectExecutionRequestListController
                    .peRequestDataList.isNotEmpty) {
                  if (projectExecutionRequestListController
                      .peRequestDataList[0].designIntegrations.isNotEmpty) {
                    view3DUrl = projectExecutionRequestListController
                            .peRequestDataList
                            .first
                            .designIntegrations
                            .first
                            .threeDModelLink ??
                        "";
                    pdfUrl = projectExecutionRequestListController
                            .peRequestDataList
                            .first
                            .designIntegrations
                            .first
                            .solarDesignPDF ??
                        "";
                    // resolvedRemark = projectExecutionRequestListController
                    //         .peRequestDataList
                    //         .first
                    //         .designIntegrations
                    //         .first
                    //         .remark ??
                    //     "";
                  }
                  peRequestDataList = projectExecutionRequestListController
                      .peRequestDataList[0];
                }

                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (projectExecutionRequestListController
                          .isDetailLoading.value)
                        SizedBox(
                            height: 420 * h,
                            child: const Center(child: CircularProgressIndicator())),
                      if (!projectExecutionRequestListController
                              .isDetailLoading.value &&
                          projectExecutionRequestListController
                                  .peRequestDataList !=
                              [])
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24 * w,
                          ),
                          child: CustomDetailedSummaryCard(
                            labelData: {
                              translation(context).uniqueId: {
                                "val": (peRequestDataList?.projectId! ?? "")
                                    .toUpperCase(),
                                "type": "text"
                              },
                              translation(context).projectType: {
                                "val": peRequestDataList?.projectType ?? "",
                                "type": "text"
                              },
                              translation(context).firmName: {
                                "val": peRequestDataList?.companyName ?? "",
                                "type": (peRequestDataList
                                            ?.companyName?.isNullOrBlank ==
                                        true)
                                    ? ""
                                    : "text"
                              },
                              translation(context).contactPersonName: {
                                "val":
                                    peRequestDataList?.contactPersonName ?? "",
                                "type": "text"
                              },
                              translation(context).contactPersonMobile: {
                                "val":
                                    "+91 - ${peRequestDataList?.contactPersonMobileNo ?? ""}",
                                "type": "text"
                              },
                              translation(context).contactPersonEmailId: {
                                "val":
                                    peRequestDataList?.contactPersonEmailId ??
                                        "",
                                "type": "text"
                              },
                              translation(context).secondaryContactName: {
                                "val":
                                    peRequestDataList?.secondaryContactName ??
                                        "",
                                "type": (peRequestDataList?.secondaryContactName
                                            ?.isNullOrBlank ==
                                        true)
                                    ? ""
                                    : "text"
                              },
                              translation(context).secondaryContactMobile: {
                                "val":
                                    "+91 - ${peRequestDataList?.secondaryContactMobileNo ?? ""}",
                                "type": (peRequestDataList
                                            ?.secondaryContactMobileNo
                                            ?.isNullOrBlank ==
                                        true)
                                    ? ""
                                    : "text"
                              },
                              translation(context).secondaryContactEmailId: {
                                "val": peRequestDataList
                                        ?.secondaryContactEmailId ??
                                    "",
                                "type": (peRequestDataList
                                            ?.secondaryContactEmailId
                                            ?.isNullOrBlank ==
                                        true)
                                    ? ""
                                    : "text"
                              },
                              translation(context).projectName: {
                                "val": peRequestDataList?.projectName ?? "",
                                "type": "text"
                              },
                              translation(context).projectAddress: {
                                "val": peRequestDataList?.projectAddress ?? "",
                                "type": "text"
                              },
                              translation(context).projectLandmark: {
                                "val": peRequestDataList?.projectLandmark ?? "",
                                "type": "text"
                              },
                              translation(context).projectCurrentLocation: {
                                "val":
                                    peRequestDataList?.projectCurrentLocation ??
                                        "",
                                "type": "text"
                              },
                              translation(context).pincode: {
                                "val": peRequestDataList?.pincode ?? "",
                                "type": "text"
                              },
                              translation(context).state: {
                                "val": peRequestDataList?.state ?? "",
                                "type": "text"
                              },
                              translation(context).city: {
                                "val": peRequestDataList?.city ?? "",
                                "type": "text"
                              },
                              translation(context).solutionType: {
                                "val": peRequestDataList?.solutionType ?? "",
                                "type": "text"
                              },
                              translation(context).reasonForSupport: {
                                "val": peRequestDataList?.supportReason ?? "",
                                "type": "text"
                              },
                              translation(context).subCategory: {
                                "val": peRequestDataList?.subCategory ?? "",
                                "type": "text"
                              },
                              (widget.typePEValue == SolarAppConstants.online)
                                  ? translation(context)
                                      .preferredDateOfConsultation
                                  : translation(context).preferredDateOfVisit: {
                                "val": peRequestDataList?.preferredDate ?? "",
                                "type": "text"
                              },
                              translation(context).requestDate: {
                                "val": peRequestDataList?.requestDate ?? "",
                                "type":
                                    (peRequestDataList?.requestDate?.isBlank !=
                                            true)
                                        ? "text"
                                        : ""
                              },
                              translation(context).lastUpdateDate: {
                                "val": peRequestDataList?.lastUpdateDate ?? "-",
                                "type": (peRequestDataList
                                            ?.lastUpdateDate?.isNullOrBlank !=
                                        true)
                                    ? "text"
                                    : ""
                              },
                              translation(context).reason: {
                                "val": peRequestDataList?.reason ?? "-",
                                "type": "text"
                              },
                              translation(context).assignedISP: {
                                "val": peRequestDataList?.assignedISP ?? "",
                                "type": (peRequestDataList
                                                ?.assignedISP?.isNullOrBlank !=
                                            true &&
                                        widget.typePEValue !=
                                            SolarAppConstants.online)
                                    ? "text"
                                    : ""
                              },
                              translation(context).supportStatus: {
                                "val": status[(peRequestDataList?.status ?? "")
                                            .toLowerCase()
                                            .contains("resolved")
                                        ? 0
                                        : (peRequestDataList?.status ?? "")
                                                .toLowerCase()
                                                .contains("progress")
                                            ? 1
                                            : 2] ??
                                    "",
                                "type": "status"
                              },
                            },
                            onTapDownload: downloadPdf,
                            onTapShare: sharePdf,
                            statusValue: projectExecutionRequestListController
                                    .peRequestDataList[0].status ??
                                "",
                          ),
                        ),
                      if (projectExecutionRequestListController
                          .peRequestDataList.isEmpty)
                        Container()
                      else if (projectExecutionRequestListController
                              .peRequestDataList.isNotEmpty &&
                          ((peRequestDataList?.status ?? "")
                                  .toLowerCase()
                                  .contains("progress") ||
                              (peRequestDataList?.status ?? "")
                                  .toLowerCase()
                                  .contains("resolved")))
                        Container(
                          padding: EdgeInsets.only(
                              bottom: 20.0 * h, left: 24 * w, right: 24 * w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if ((peRequestDataList?.status ?? "")
                                  .toLowerCase()
                                  .contains("progress"))
                                SecondaryButton(
                                  buttonText: translation(context).reschedule,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CommonRescheduleRequest(
                                                    onItemSelected: () {},
                                                    projectId: widget.projectId,
                                                    contentTiltle:
                                                        "Reschedule Request",
                                                    isFrom: widget.isFrom,
                                                    disableDate:
                                                        peRequestDataList
                                                            ?.preferredDate,
                                                  typePEValue: widget.typePEValue,)));
                                  },
                                  buttonHeight: 48 * h,
                                  isEnabled: true,
                                ),
                            ],
                          ),
                        ),
                    ]);
              })),
            ),
            SizedBox(
              height: h * 24,
            )
          ],
        ));
  }

  Future<void> downloadPdf() async {
    if (pdfUrl.isNotEmpty) {
      if (await canLaunchUrlString(pdfUrl)) {
        await launchUrlString(pdfUrl);
      } else {
        Utils().showToast(translation(context).unableToDownload, context);
      }
    } else {
      Utils().showToast(translation(context).unableToDownload, context);
    }
  }

  Future<void> sharePdf() async {
    if (pdfUrl.isNotEmpty) {
      Share.shareUri(Uri.parse(pdfUrl));
    } else {
      Utils().showToast(translation(context).unableToShare, context);
    }
  }

  void open3dModel(view3DUrl, BuildContext context) {
    if (view3DUrl.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => View3dModelWebView(url: view3DUrl)));
    } else {
      Utils().showToast(translation(context).unableToNavigate, context);
    }
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
