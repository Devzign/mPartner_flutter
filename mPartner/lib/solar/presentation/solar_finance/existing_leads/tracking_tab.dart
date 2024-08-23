import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../data/models/request_tracking_model.dart';
import '../../../state/controller/finance_request_tracking_controller.dart';
import '../../common/leads_list_detail_cards/request_tracking_widget.dart';
import '../solar_finance_utils.dart';

class TrackingTab extends StatefulWidget {
  final String projectId;

  const TrackingTab({Key? key, required this.projectId}) : super(key: key);

  @override
  State<TrackingTab> createState() => _TrackingTabState();
}

class _TrackingTabState extends State<TrackingTab> {
  final FinanceRequestTrackingController financeRequestTrackingController = Get.find();

  @override
  void initState() {
    super.initState();
    financeRequestTrackingController.fetchRequestTrackingStatus(widget.projectId);
  }
  
  Map<String, Map<String, LabelValue>> _mapRequestTrackingDetails(List<RequestTrackingDetails> details) {
    Map<String, Map<String, LabelValue>> groupedData = {};

    details.forEach((detail) {
      String monthAndYear = DateFormat('MMMM yyyy').format(DateTime.parse(detail.createdOn));

      if (!groupedData.containsKey(monthAndYear)) {
        groupedData[monthAndYear] = {};
      }

      groupedData[monthAndYear]![detail.createdOn] = LabelValue(
        action: detail.reason!.isNotEmpty ? detail.reason : "-",
        status: detail.status,
        statusColor: getStatusColor(detail.status.toLowerCase())
      );
    });

    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: Obx(() {
        if (financeRequestTrackingController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (financeRequestTrackingController.error.isNotEmpty) {
          return Container();
        }
        var labelData = _mapRequestTrackingDetails(financeRequestTrackingController.requestTrackingDetails);
        if(labelData.isEmpty){
          return Center(child:Text(translation(context).dataNotFound));
        }
        return ListView.builder(
          itemCount: labelData.length,
          itemBuilder: (context, index) {
            String monthAndYear = labelData.keys.elementAt(index);
            Map<String, LabelValue> dataForMonth = labelData[monthAndYear]!;

            return RequestTrackingWidget(
              labelData: dataForMonth,
              monthAndYear: monthAndYear,
            );
          },
        );
      }),
    );
  }
}
