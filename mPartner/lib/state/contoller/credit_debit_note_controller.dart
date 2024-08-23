import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';

class CreditDebitNoteController extends GetxController {
  RxString pdfUrl = "".obs;
  RxString thumbnailUrl = "".obs;
  var isLoading = false.obs;
  var error = ''.obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchCreditDebitNoteReport({String fromDate = "", String toDate = ""}) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postCreditDebitNote(fromDate: fromDate, toDate: toDate);
      result.fold(
        (failure) {
          error('Failed to fetch PDF URL: $failure');
        },
        (creditDebitNoteReport) {
          pdfUrl.value = creditDebitNoteReport.data;
          thumbnailUrl.value = creditDebitNoteReport.data1;
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

  clearCreditDebitNote() {
    pdfUrl("");
    thumbnailUrl("");
    isLoading(false);
    error("");
  }
}
