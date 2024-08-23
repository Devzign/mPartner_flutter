import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpartner/data/datasource/mpartner_remote_data_source.dart';
import 'package:mpartner/data/models/report_type_model.dart';

import '../../data/models/primary_report type_model.dart';

class PrimaryReportTypeController extends GetxController {
  List<String?> primaryReportTypes = [];

  var isLoading = false.obs;
  var error = ''.obs;

  var primaryReportTypeOptions = PrimaryReportTypeModel(primaryReportType: "").obs;
  TextEditingController startDateController=TextEditingController();
  TextEditingController endDateController=TextEditingController();
  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  void fetchPrimaryReportTypes() async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postPrimaryReportType();
      result.fold(
        (failure) {
          // Handle failure (Left)
          error(
              'Failed to fetch cash redemption options information: $failure');
        },
        (getPrimaryReportTypeOptionsData) async {
          for (var option in getPrimaryReportTypeOptionsData) {
            if (option.props.every((value) => value == 'NA')) {
              error('No primary report types available available.');
            } else {
              error('');
            }
            primaryReportTypes =
                getPrimaryReportTypeOptionsData.map((option) => option.primaryReportType).toList();
            primaryReportTypeOptions(option);
          }
        },
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  clearCashRedemptionOptionsState() {
    primaryReportTypes = [];

    isLoading = false.obs;
    error = ''.obs;

    primaryReportTypeOptions =
        PrimaryReportTypeModel(primaryReportType: "").obs;
  }
}
