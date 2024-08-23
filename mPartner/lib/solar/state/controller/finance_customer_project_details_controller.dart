import 'package:get/get.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/finance_customer_project_details_model.dart';

class FinanceCustomerProjectDetailsController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;

  SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();

  var customerProjectDetails = CustomerProjectDetailsModel(
          projectId: "",
          categoryName: "",
          contactPersonName: "",
          contactPersonMobileNo: "",
          contactPersonEmailId: "",
          projectName: "",
          pincode: "",
          state: "",
          city: "",
          solutionType: "",
          projectCapacity: "",
          projectCost: 0,
          preferredBankName: "",
          panNumber: "",
          status: "",
          remarks: "",
          firmName: '',
          firmGSTINNumber: '',
          approvedBank: '',
          secondaryContactName: '',
          secondaryContactMobileNo: '',
          secondaryContactEmailId: '', 
          requestDate: '', 
          lastUpdateDate: '',
          reason: '')
      .obs;

  Future<void> fetchProjectDetailsById(String projectId) async {
    try {
      isLoading(true);

      final result = await solarRemoteDataSource
          .postFinanceCustomerProjectDetails(projectId);
      result.fold(
        (failure) {
          error('Failed to fetch project details: $failure');
        },
        (response) {
          if (response.data != null) {
            customerProjectDetails.value = response.data[0];
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

  clearCustomerProjectDetails() {
    isLoading(false);
    error("");
  }
}
