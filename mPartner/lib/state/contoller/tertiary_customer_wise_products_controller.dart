import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/tertiary_customer_wise_detail_model.dart';
import '../../data/models/tertiary_report_model.dart';
import '../../utils/app_constants.dart';

class TertiaryCustomerWiseProduct extends GetxController {
  var tertiaryCustomerWiseProductsList = <Map<String, dynamic>>[].obs;
  var reportUrl = "".obs;
  var isLoading = false.obs;
  var error = ''.obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchTertiaryCustomerWiseProductsSummary(userId,
      {String productType = "",
      String disId = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      String toDate = AppConstants.TO_DATE}) async {
    try {
      isLoading(true);
      tertiaryCustomerWiseProductsList.clear();
      final result = await mPartnerRemoteDataSource.postTertiaryCustomerWiseDetails(userId,
      disId: disId,
          productType: productType,
          status: status,
          fromDate: fromDate,
          toDate: toDate);
      result.fold(
        (failure) {
          // Handle failure (Left)
          error(
              'Failed to fetch tertiary report information: $failure');
        },
        (tertiaryCustomerDetails) async {
          for (TertiaryCustomerDetails option in tertiaryCustomerDetails.data) {
            if (option.props.every((value) => value == 'NA')) {
              error('No tertiary report summary available.');
            } else {
              error('');
            }
            tertiaryCustomerWiseProductsList.add(option.toJson());
            reportUrl.value = tertiaryCustomerDetails.data1;
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

  clearTertiaryReportState() {
    tertiaryCustomerWiseProductsList.clear();
    reportUrl = "" as RxString;
    isLoading = false.obs;
    error = ''.obs;
  }
}
