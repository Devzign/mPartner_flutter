import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/ProjectExecutionFormController.dart';
import '../../../../state/controller/ProjectExecutionRequestListController.dart';
import '../../../../utils/solar_app_constants.dart';
import '../../components/custom_existing_leads_card_item_widget.dart';
import '../../model/request_list_response.dart';
import '../common_raise_request_form/common_raise_request_form.dart';
import 'common_project_details_card.dart';
import 'common_project_view_tab.dart';

class CommonResidentialViewPage extends StatefulWidget {
  final String typeValue;

  const CommonResidentialViewPage({super.key, required this.typeValue});

  @override
  State<CommonResidentialViewPage> createState() =>
      _CommonResidentialViewPageState();
}

class _CommonResidentialViewPageState extends State<CommonResidentialViewPage> {
  var status = ["resolved", "in-progress", "rescheduled"];
  ProjectExecutionRequestListController projectExecutionRequestListController =
      Get.find();
  ProjectExecutionFormController projectExecutionFormController = Get.find();
  final ScrollController _scrollController = ScrollController();
  int length = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    if(projectExecutionRequestListController.selectedProjectTypeTab==SolarAppConstants.residentialCategory) {
      fetchRequests();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !projectExecutionRequestListController.isLoadingResidential.value) {
      if (projectExecutionRequestListController.totalListCount > projectExecutionRequestListController.requestResListData.length) {
        fetchPeListRequest();
      }
    }
  }

  Future<void> fetchRequests() async {
    fetchPeListRequest();
    await projectExecutionFormController.getReasonForSupport(
        widget.typeValue, Category.residential);
  }

  Future<void> fetchPeListRequest() async {
    await projectExecutionRequestListController.fetchProjectRequestList(
        "Residential",
        projectExecutionRequestListController.searchString.value,
        projectExecutionRequestListController.finalPEStatusString.value,
        projectExecutionRequestListController.finalSupportReasonString.value,
        widget.typeValue);
    projectExecutionRequestListController.isLoadingResidential.value = false;
  }

  @override
  Widget build(BuildContext context) {
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    return Obx(() => Column(
          children: [
            Expanded(
              child: projectExecutionRequestListController
                          .isLoadingResidential.value &&
                      projectExecutionRequestListController
                          .requestResListData.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (projectExecutionRequestListController
                          .requestResListData.isEmpty)
                      ? Center(child: Text(translation(context).dataNotFound))
                      : Container(
                          padding: EdgeInsets.only(
                              bottom: projectExecutionRequestListController
                                      .isLoadingResidential.value
                                  ? 80.0 * h
                                  : 0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Visibility(
                                visible: projectExecutionRequestListController
                                    .isLoadingResidential.value,
                                child: const Positioned(
                                    bottom: 0,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    )),
                              ),
                              ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.zero,
                                itemCount: projectExecutionRequestListController
                                    .requestResListData.length,
                                itemBuilder: (context, index) {
                                  RequestlistData request =
                                      projectExecutionRequestListController
                                          .requestResListData[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: (index ==
                                                (projectExecutionRequestListController
                                                        .requestResListData
                                                        .length -
                                                    1))
                                            ? projectExecutionRequestListController
                                                    .isLoadingResidential.value
                                                ? 120
                                                : 80.0 * h
                                            : 0),
                                    child: CustomExistingLeadsCardWidget(
                                      onItemSelected: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommonProjectDetailTabView(
                                                      projectId: request.projectId,
                                                      typeValue: widget.typeValue,
                                                      isFrom: SolarAppConstants.fromDashboard,
                                                    )));
                                      },
                                      id: request.projectId,
                                      label1: translation(context)
                                          .contactPersonName,
                                      label2: translation(context)
                                          .contactPersonMobile,
                                      label3: translation(context).projectName,
                                      label4:
                                          translation(context).reasonForSupport,
                                      value1: request.contactPersonName,
                                      value2:
                                          "+91 - ${request.contactPersonMobileNo}",
                                      value3: request.projectName,
                                      value4: request.supportReason,
                                      status: status[request.status
                                              .toLowerCase()
                                              .contains("resolved")
                                          ? 0
                                          : request.status
                                                  .toLowerCase()
                                                  .toLowerCase()
                                                  .contains("progress")
                                              ? 1
                                              : 2],
                                      statusText: status[
                                          request.status.contains("resolved")
                                              ? 0
                                              : request.status
                                                      .toLowerCase()
                                                      .contains("progress")
                                                  ? 1
                                                  : 2],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ));
  }
}
