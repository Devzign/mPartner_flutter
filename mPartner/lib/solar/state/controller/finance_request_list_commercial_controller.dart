import 'package:get/get.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/solar_finance_requests_list_model.dart';
import '../../utils/solar_app_constants.dart';

class FinanceRequestsListCommercialController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;

  SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();

  RxList<SolarFinanceRequests> commercialRequestsList = <SolarFinanceRequests>[].obs;
  int pageNumberCommercial = 1;
  int totalCountCommercial = 0;

  Future<void> fetchFinanceRequestsList(String category, int pageNumber, int pageSize, {String filterStatus = "", String searchString = ""}) async {
    try {
      isLoading(true);
      final result =
          await solarRemoteDataSource.getFinanceRequestsList(category, pageNumber, pageSize, filterStatus: filterStatus, searchString: searchString);
      result.fold(
        (failure) {
          error('Failed to fetch financing requests list: $failure');
        },
        (response) {
          Map<String, dynamic> jsonResponse = response.toJson();
          SolarFinanceExistingLeads financeLeads =
              SolarFinanceExistingLeads.fromJson(jsonResponse);
            commercialRequestsList.addAll(financeLeads.data.data);
          totalCountCommercial = financeLeads.data.totalCount;
          this.pageNumberCommercial += 1;
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

  clearFinanceRequestList() {
    isLoading(false);
    error("");
    commercialRequestsList.value = [];
    totalCountCommercial = 0;
    pageNumberCommercial = 1;
  }
}
