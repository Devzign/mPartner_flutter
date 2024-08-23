import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class CommonCommercialViewPage extends StatefulWidget {
  final String typeValue;

  const CommonCommercialViewPage({super.key, required this.typeValue});

  @override
  State<CommonCommercialViewPage> createState() =>
      _CommonCommercialViewPageState();
}

class _CommonCommercialViewPageState extends State<CommonCommercialViewPage> {
  var status = ["resolved", "in-progress", "rescheduled"];

  ProjectExecutionRequestListController projectExecutionRequestListController =
      Get.find();
  ProjectExecutionFormController projectExecutionFormController = Get.find();
  int length = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    if(projectExecutionRequestListController.selectedProjectTypeTab==SolarAppConstants.commercialCategory) {
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
        _scrollController.position.maxScrollExtent && !projectExecutionRequestListController.isLoadingCommercial.value) {
      if(projectExecutionRequestListController.totalListCount > projectExecutionRequestListController.requestComListData.length) {
        fetchPeListRequest();
      }
    }
  }

  Future<void> fetchRequests() async {
   fetchPeListRequest();
    await projectExecutionFormController.getReasonForSupport(
        widget.typeValue, Category.commercial);
  }
  
  Future<void> fetchPeListRequest ()async{
  await projectExecutionRequestListController.fetchProjectRequestList(
  "Commercial",
  projectExecutionRequestListController.searchString.value,
  projectExecutionRequestListController.finalPEStatusString.value,
  projectExecutionRequestListController.finalSupportReasonString.value,
  widget.typeValue);
  projectExecutionRequestListController.isLoadingCommercial.value = false;
}

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    return Obx(() => Column(
          children: [
            Expanded(
              child: projectExecutionRequestListController
                      .isLoadingCommercial.value&&projectExecutionRequestListController.requestComListData.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (projectExecutionRequestListController
                          .requestComListData.isEmpty)
                      ? Center(child: Text(translation(context).dataNotFound))
                      : Container(
                padding: EdgeInsets.only(
                    bottom:projectExecutionRequestListController
                        .isLoadingCommercial.value
                        ? 80.0 * h
                        : 0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                             Visibility(
                               visible:projectExecutionRequestListController
                                   .isLoadingCommercial.value,
                               child: const Positioned(
                                bottom: 0,
                                  child: Center(
                                child: CircularProgressIndicator(),)),
                             ),
                            ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.zero,
                                itemCount: projectExecutionRequestListController
                                    .requestComListData.length,
                                itemBuilder: (context, index) {
                                  RequestlistData request =
                                      projectExecutionRequestListController
                                          .requestComListData[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: (index ==
                                                (projectExecutionRequestListController
                                                        .requestComListData.length -
                                                    1))
                                            ? projectExecutionRequestListController
                                            .isLoadingCommercial.value?120:80.0 * h
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
                                                )
                                        ));
                                      },
                                      id: request.projectId,
                                      label1: translation(context).contactPersonName,
                                      label2: translation(context).contactPersonMobile,
                                      label3: translation(context).projectName,
                                      label4: translation(context).reasonForSupport,
                                      value1: request.contactPersonName,
                                      value2: "+91 - ${request.contactPersonMobileNo}",
                                      value3: request.projectName,
                                      value4: request.supportReason,
                                      status: status[request.status
                                              .toLowerCase()
                                              .contains("resolved")
                                          ? 0
                                          : request.status
                                                  .toLowerCase()
                                                  .contains("progress")
                                              ? 1
                                              : 2],
                                      statusText: status[request.status
                                              .toLowerCase()
                                              .contains("resolved")
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

