import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/product_wise_detail_model.dart';
// Import your Failure class

class PrimaryBillingReportController extends GetxController {
  RxString pdfUrl = "".obs;
  RxString thumbnailUrl = "".obs;
  var isLoading = false.obs;
  var error = ''.obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchPrimaryBillingReport({String fromDate = "", String toDate = ""}) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postPrimaryBillingReport(fromDate: fromDate, toDate: toDate);
      result.fold(
        (failure) {
          error('Failed to fetch PDF URL: $failure');
        },
        (primaryBillingReport) {
          pdfUrl.value = primaryBillingReport.data;
          print("URLLLL ${pdfUrl.value}");
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

  clearPrimaryBillingReport() {
    pdfUrl("");
    thumbnailUrl("");
    isLoading(false);
    error("");
  }
}
