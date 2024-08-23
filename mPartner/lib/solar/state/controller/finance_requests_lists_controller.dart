import 'package:get/get.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/solar_finance_requests_list_model.dart';
import '../../utils/solar_app_constants.dart';

class FinanceRequestsListController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;

  SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();

  RxList<SolarFinanceRequests> residentialRequestsList = <SolarFinanceRequests>[].obs;
  RxString financeStatusSelected = "".obs;
  RxString searchStringFinance = "".obs;
  var totalCountResidential = 0;
  int pageNumberResidential = 1;

  Future<void> fetchFinanceRequestsList(String category, int pageNumber, int pageSize, {String filterStatus = "", String searchString = ""}) async {
    try {
      isLoading(true);
      final result = await solarRemoteDataSource.getFinanceRequestsList(
          category, pageNumber, pageSize, filterStatus: filterStatus, searchString: searchString);
      result.fold(
        (failure) {
          error('Failed to fetch financing requests list: $failure');
        },
        (response) {
          Map<String, dynamic> jsonResponse = response.toJson();
          SolarFinanceExistingLeads financeLeads = SolarFinanceExistingLeads.fromJson(jsonResponse);
          residentialRequestsList.addAll(financeLeads.data.data);
          totalCountResidential = financeLeads.data.totalCount;
          this.pageNumberResidential += 1;
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
    financeStatusSelected.value = "";
    residentialRequestsList.value = [];
    searchStringFinance.value = "";
    totalCountResidential = 0;
    pageNumberResidential = 1;
  }

  resetFilter() {
    isLoading(false);
    error("");
    financeStatusSelected.value = "";
    residentialRequestsList.value = [];
    totalCountResidential = 0;
    pageNumberResidential = 1;
  }
}
