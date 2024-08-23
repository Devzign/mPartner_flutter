import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/product_wise_detail_model.dart';
import '../../utils/app_constants.dart';

class SecondaryReportDealerDownloadController extends GetxController {
  RxString pdfUrl = "".obs;
  var isLoading = false.obs;
  var error = ''.obs;
  TextEditingController startDateController=TextEditingController();
  TextEditingController endDateController=TextEditingController();
  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchSecondaryReportForDealer(String dealerId, {String disID = "", String fromDate =AppConstants.FROM_DATE, toDate=AppConstants.TO_DATE, String status = "", String products =""}) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postSecondaryReportDownloadDealer(dealerId,disID: disID,fromDate: fromDate,toDate: toDate, status : status, productTypes: products);
      result.fold(
        (failure) {
          error('Failed to fetch PDF URL: $failure');
        },
        (secondaryReportDealer) {
          pdfUrl.value = secondaryReportDealer.data;
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

  clearSecondaryReportPdfDistributorState() {
    pdfUrl("");
    isLoading(false);
    error("");
  }
}
