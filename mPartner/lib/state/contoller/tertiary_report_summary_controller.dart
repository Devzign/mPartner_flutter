import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/secondary_report_distributor_model.dart';
import '../../data/models/tertiary_report_model.dart';
import '../../utils/app_constants.dart';

class TertiaryReportSummaryController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;

  var tertiaryReportSummary =
      TertiaryReport(message: "", status: "", token: "", data: [], data1: "")
          .obs;
  TextEditingController startDateController=TextEditingController();
  TextEditingController endDateController=TextEditingController();
  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  /* Future<void> fetchTertiaryReportSummary(userId,
      {String productType = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      String toDate = AppConstants.TO_DATE,
      String customerPhone = ""}) async {
    try {
      isLoading(true);
      tertiaryReportSummaryList.clear();
      final result = await mPartnerRemoteDataSource.postTertiaryReport(userId,
          productType: productType,
          status: status,
          fromDate: fromDate,
          toDate: toDate,
          customerPhone: customerPhone);
      result.fold(
        (failure) {
          // Handle failure (Left)
          error(
              'Failed to fetch tertiary report information: $failure');
        },
        (tertiaryReportSummary) async {
          for (CustomerWiseData option in tertiaryReportSummary.data) {
            if (option.props.every((value) => value == 'NA')) {
              error('No tertiary report summary available.');
            } else {
              error('');
            }
            tertiaryReportSummaryList.add(option.toJson());
            reportUrl.value = tertiaryReportSummary.data1;
          }
        },
      );
    } finally {
      isLoading(false);
    }
  } */

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  clearTertiaryReportState() {
  //  tertiaryReportSummaryList.clear();
    startDateController.text = "";
    endDateController.text = "";
  //  reportUrl = "" as RxString;
    isLoading = false.obs;
    error = ''.obs;
  }
}
