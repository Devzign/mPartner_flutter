import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/ProjectExecutionRequestListController.dart';
import '../../../common/leads_list_detail_cards/request_tracking_widget.dart';

class CommonRequestTrackingPage extends StatefulWidget {
  final String typeValue;
  final String projectId;
  final String isFrom;

  const CommonRequestTrackingPage(
      {super.key,
      required this.typeValue,
      required this.projectId,
      required this.isFrom});

  @override
  State<CommonRequestTrackingPage> createState() =>
      _CommonRequestTrackingPagePageState();
}

class _CommonRequestTrackingPagePageState
    extends State<CommonRequestTrackingPage> {
  var status = ["resolved", "in-progress", "rescheduled"];

  ProjectExecutionRequestListController projectExecutionRequestListController =
      Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await projectExecutionRequestListController
          .fetchRequestTrackingList(widget.projectId);
    });
  }

  @override
  void dispose() {
    projectExecutionRequestListController.solarRequestTrackingList.value = [];
    projectExecutionRequestListController.requestTrackingMap.value = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    return Obx(() => Column(
          children: [
            Expanded(
              child: projectExecutionRequestListController
                          .isDetailLoading.value &&
                      projectExecutionRequestListController
                          .solarRequestTrackingList.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (projectExecutionRequestListController
                          .solarRequestTrackingList.isEmpty)
                      ? Center(child: Text(translation(context).dataNotFound))
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var entry
                                  in projectExecutionRequestListController
                                      .requestTrackingMap.entries)
                                RequestTrackingWidget(
                                  labelData: {
                                    for (var detail in entry.value)
                                      detail.createdOn: LabelValue(
                                        action: detail.reason ?? "",
                                        status: detail.status ?? "",
                                        statusColor: checkForStatusColor(
                                            detail.status ?? ""),
                                      ),
                                  },
                                  monthAndYear: entry.key,
                                ),
                            ],
                          ),
                        ),
            ),
          ],
        ));
  }

  Color checkForStatusColor(String status) {
    if (status.toLowerCase() == "resolved") {
      return AppColors.successGreen;
    } else if (status.toLowerCase() == "in-progress") {
      return AppColors.yellowStar;
    } else if (status.toLowerCase() == "rescheduled") {
      return AppColors.orange;
    } else {
      return AppColors.yellowStar;
    }
  }
}
