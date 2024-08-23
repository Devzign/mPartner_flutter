import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';

class DistributorLedgerController extends GetxController {
  RxString pdfUrl = "".obs;
  RxString thumbnailUrl = "".obs;
  var isLoading = false.obs;
  var error = ''.obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchDistributorLedgerReport({String fromDate = "", String toDate = ""}) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postDistributorLedger(fromDate: fromDate, toDate: toDate);
      result.fold(
        (failure) {
          error('Failed to fetch PDF URL: $failure');
        },
        (distributorLedgerReport) {
          pdfUrl.value = distributorLedgerReport.data;
          thumbnailUrl.value = distributorLedgerReport.data1;
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

  clearDistributorLedger() {
    pdfUrl("");
    thumbnailUrl("");
    isLoading(false);
    error("");
  }
}
