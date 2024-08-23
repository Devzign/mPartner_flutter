import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../presentation/widgets/buttons/primary_button.dart';
import '../../../../presentation/widgets/common_white_button.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/utils.dart';
import '../../../state/controller/digital_request_by_project_id_controller.dart';
import '../../../state/controller/digital_survey_request_list_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/leads_list_detail_cards/detailed_summary_card.dart';
import '../../common/something_went_wrong_solar_screen.dart';
import 'reassign_request_sheet.dart';
import 'view_3d_model_webview.dart';

class DetailedViewCard extends StatefulWidget {
  final String projectId;
  final String categoryId;
  final bool isDigOrPhy;
  final String? isNavigatedFrom;

  const DetailedViewCard({
    super.key,
    required this.projectId,
    required this.categoryId,
    required this.isDigOrPhy,
    this.isNavigatedFrom,
  });

  @override
  State<DetailedViewCard> createState() => _DetailedViewCardState();
}

class _DetailedViewCardState extends State<DetailedViewCard> {
  DigitalRequestByProjectIdController digitalRequestByProjectIdController = Get.find();
  DigitalSurveyRequestListController digitalSurveyRequestListController = Get.find();
  String view3DUrl = "";
  String pdfUrl = "";
  String dateOfVisit = "";
  String requestDate = "";
  String lastUpdateDate = "-";
  String avgEnergyConsumption = "";
  String avgMonthlyBill = "";
  String primaryContactMobile = "";
  String secondaryContactMobile = "";
  bool isDataAvailable = true;

  @override
  void initState() {
    super.initState();
    fetchDigitalRequestsByProjectId();
  }

  Future<void> fetchDigitalRequestsByProjectId() async {
    await digitalRequestByProjectIdController.clearDigitalRequestByProjectId();
    await digitalRequestByProjectIdController.fetchDigitalRequestByProjectId(widget.projectId);
    logger.i(digitalRequestByProjectIdController.digitalRequestDataList);
    if (digitalRequestByProjectIdController.error.value.isNotEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder: (context) => SomethingWentWrongSolarScreen(
            previousRoute: widget.isDigOrPhy
              ? SolarAppConstants.digitalDesRouteName
              : SolarAppConstants.physicalDesRouteName,
            onPressed: (){
              Navigator.pop(context);
            },
          ))
      );
    } else if (!digitalRequestByProjectIdController.isLoading.value && digitalRequestByProjectIdController.digitalRequestDataList.isEmpty) {
      setState(() {
        isDataAvailable = false;
      });
    } else {
      setState(() {
        if (digitalRequestByProjectIdController.digitalRequestDataList.first.contactPersonMobileNo != null && digitalRequestByProjectIdController.digitalRequestDataList.first.contactPersonMobileNo!.isNotEmpty) {
          primaryContactMobile = digitalSurveyRequestListController.formatPhoneNumber(digitalRequestByProjectIdController.digitalRequestDataList.first.contactPersonMobileNo ?? "");
        }

        if (digitalRequestByProjectIdController.digitalRequestDataList.first.secondaryContactMobileNo != null && digitalRequestByProjectIdController.digitalRequestDataList.first.secondaryContactMobileNo!.isNotEmpty) {
          secondaryContactMobile = digitalSurveyRequestListController.formatPhoneNumber(digitalRequestByProjectIdController.digitalRequestDataList.first.secondaryContactMobileNo ?? "");
        }

        if (digitalRequestByProjectIdController.digitalRequestDataList.first.preferredDateOfVisit != null && digitalRequestByProjectIdController.digitalRequestDataList.first.preferredDateOfVisit!.isNotEmpty) {
          dateOfVisit = DateFormat('dd/MM/yyyy').format(DateTime.parse(digitalRequestByProjectIdController.digitalRequestDataList.first.preferredDateOfVisit ?? ""));
        }

        if (digitalRequestByProjectIdController.digitalRequestDataList.first.requestDate != null && digitalRequestByProjectIdController.digitalRequestDataList.first.requestDate!.isNotEmpty) {
          requestDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(digitalRequestByProjectIdController.digitalRequestDataList.first.requestDate ?? ""));
        }

        if (digitalRequestByProjectIdController.digitalRequestDataList.first.lastUpdateDate != null && digitalRequestByProjectIdController.digitalRequestDataList.first.lastUpdateDate!.isNotEmpty) {
          lastUpdateDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(digitalRequestByProjectIdController.digitalRequestDataList.first.lastUpdateDate ?? ""));
        }

        if (digitalRequestByProjectIdController.digitalRequestDataList.first.avgMonthlyBill != null) {
          avgMonthlyBill = digitalRequestByProjectIdController.digitalRequestDataList.first.avgMonthlyBill.toString();
        }

        if (digitalRequestByProjectIdController.digitalRequestDataList.first.avgEnergyConsumption != null) {
          avgEnergyConsumption = rupeeNoSign.format(digitalRequestByProjectIdController.digitalRequestDataList.first.avgEnergyConsumption).toString();
          avgEnergyConsumption = '${avgEnergyConsumption} kWh';
        }

        if (digitalRequestByProjectIdController.digitalRequestDataList.first.designIntegrations.isNotEmpty) {
          view3DUrl = digitalRequestByProjectIdController.digitalRequestDataList.first.designIntegrations.first.threeDModelLink ?? "";
          pdfUrl = digitalRequestByProjectIdController.digitalRequestDataList.first.designIntegrations.first.solarDesignPDF ?? "";
        }
      });
    }
  }

  Future<void> downloadPdf() async {
    if(pdfUrl.isNotEmpty){
      if (await canLaunchUrlString(pdfUrl)) {
        await launchUrlString(pdfUrl);
      } else {
        Utils().showToast(translation(context).unableToDownload, context);
      }
    }
    else{
      Utils().showToast(translation(context).unableToDownload, context);
    }
  }

  Future<void> sharePdf() async {
    if (pdfUrl.isNotEmpty) {
      Share.shareUri(Uri.parse(pdfUrl));
    } else {
      Utils().showToast(translation(context).unableToShare, context);
      throw 'Could not share Pdf $pdfUrl';
    }
  }

  void open3dModel(view3DUrl, BuildContext context) {
    if (view3DUrl.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                View3dModelWebView(url:view3DUrl)));
    } else {
      Utils().showToast(translation(context).unableToNavigate, context);
      // throw 'Could not launch 3d Model $view3DUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    return Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (digitalRequestByProjectIdController.isLoading.value)
                Container(
                    height: 420 * h,
                    child: Center(child: CircularProgressIndicator())
                ),
              if (!isDataAvailable)
                Column(
                  children: [
                    const VerticalSpace(height: 52),
                    Center(child: Text(translation(context).dataNotFound)),
                  ],
                ),
              if (!digitalRequestByProjectIdController.isLoading.value && digitalRequestByProjectIdController.digitalRequestDataList.isNotEmpty && isDataAvailable)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24 * w, vertical:  5 * h),
                          child: DetailedSummaryCard(
                            labelData: {
                              translation(context).uniqueId : {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.projectId ?? "", "type": "text"},
                              translation(context).projectType : {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.projectType ?? "", "type": "text"},
                              translation(context).firmName: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.companyName ?? "", "type": "text"},
                              translation(context).contactPersonName: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.contactPersonName ?? "", "type": "text"},
                              translation(context).contactPersonMobile: {"val": primaryContactMobile, "type": "text"},
                              translation(context).contactPersonEmailId: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.contactPersonEmailId ?? "", "type": "text"},
                              translation(context).secondaryContactName: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.secondaryContactName ?? "", "type": "text"},
                              translation(context).secondaryContactMobile: {"val": secondaryContactMobile, "type": "text"},
                              translation(context).secondaryContactEmailId: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.secondaryContactEmailId ?? "", "type": "text"},
                              translation(context).projectName: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.projectName ?? "", "type": "text"},
                              translation(context).projectAddress: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.projectAddress ?? "", "type": "text"},
                              translation(context).projectLandmark: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.projectLandmark ?? "", "type": "text"},
                              translation(context).projectCurrentLocation: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.projectCurrentLocation ?? "", "type": "text"},
                              translation(context).pincode: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.pincode ?? "", "type": "text"},
                              translation(context).state: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.state ?? "", "type": "text"},
                              translation(context).city: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.city ?? "", "type": "text"},
                              translation(context).solutionType: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.solutionType ?? "", "type": "text"},
                              translation(context).avgEnergyConsumption: {"val": avgEnergyConsumption, "type": "text"},
                              translation(context).averageMonthlyBill: {"val": avgMonthlyBill, "type": "rupee"},
                              translation(context).requestDate: {"val": requestDate ?? "", "type": "text"},
                              translation(context).lastUpdateDate: {"val": lastUpdateDate ?? "", "type": "text"},
                              translation(context).preferredDateOfVisit: {"val": dateOfVisit ?? "", "type": "text"},
                              translation(context).assignedISP: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.assignedISP ?? "", "type": "text"},
                              translation(context).designStatus: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.status ?? "", "type": "status"},
                              translation(context).reason: {"val": digitalRequestByProjectIdController.digitalRequestDataList.first.reason ?? "-", "type": "text"},
                            },
                            onTapDownload: (digitalRequestByProjectIdController.digitalRequestDataList.first.status != null && digitalRequestByProjectIdController.digitalRequestDataList.first.status?.toLowerCase() == "shared")
                                ? downloadPdf
                                : null,
                            onTapShare: (digitalRequestByProjectIdController.digitalRequestDataList.first.status != null && digitalRequestByProjectIdController.digitalRequestDataList.first.status?.toLowerCase() == "shared")
                                ? sharePdf
                                : null,
                            statusValue: digitalRequestByProjectIdController.digitalRequestDataList.first.status ?? "",
                          ),
                        ),
                        if (digitalRequestByProjectIdController.digitalRequestDataList.first.status != null && digitalRequestByProjectIdController.digitalRequestDataList.first.status?.toLowerCase() == "design shared" || digitalRequestByProjectIdController.digitalRequestDataList.first.status?.toLowerCase() == "shared")
                          Container(
                            padding: EdgeInsets.only(
                                bottom: 24.0 * h,
                                left: 24 * w,
                                right: 24 * w
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 165 * w,
                                  height: 48 * h,
                                  child: CommonWhiteButton(
                                    buttonText: translation(context).reassign,
                                    onPressed: (){
                                      showModalBottomSheet(
                                        context: context,
                                        isDismissible: false,
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return ReassignRequestSheet(
                                              projectId: widget.projectId,
                                              isDigOrPhy: widget.isDigOrPhy,
                                              isNavigatedFrom: widget.isNavigatedFrom
                                          );
                                        },
                                      );
                                    },
                                    backGroundColor: AppColors.white,
                                    isEnabled: digitalRequestByProjectIdController.digitalRequestDataList.first.enableIteration ?? false,
                                    isGreyColor: digitalRequestByProjectIdController.digitalRequestDataList.first.enableIteration ?? false,
                                  ),
                                ),
                                SizedBox(width: 12 * w,),
                                PrimaryButton(
                                  buttonText: translation(context).view3dModel,
                                  onPressed: () => {
                                    open3dModel(view3DUrl,context),
                                  },
                                  buttonHeight: 48 * h,
                                  isEnabled: true,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ]
        )
    );
  }
}
