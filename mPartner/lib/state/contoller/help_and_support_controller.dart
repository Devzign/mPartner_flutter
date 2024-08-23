import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/company_info_model.dart';
import '../../data/models/help_support_send_suggestion_model.dart';
import '../../services/services_locator.dart';

class HelpAndSupportController extends GetxController {
  var isLoading = true.obs;
  var contactUsDetails = <CompanyInfoModel>[].obs;
  var postSuggestion = <SendSuggestion>[].obs;

  @override
  void onInit() async {
    super.onInit();
  }

  fetchCompanyInfo() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getCompanyInfoDetails();
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
              contactUsDetails.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  postSuggestionsHelpAndSupport(String msg, List<String> imagePaths, String? previousRoute) async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.postSuggestion(msg, imagePaths, previousRoute);
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
          postSuggestion.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }


  clearHelpAndSupportController() {
    isLoading = true.obs;
    contactUsDetails = <CompanyInfoModel>[].obs;
    postSuggestion = <SendSuggestion>[].obs;
    update();
  }
}
