import 'package:get/get.dart';

import '../../../services/services_locator.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/get_units_model.dart';
import '../../data/models/save_customer_project_details_model.dart';

class SolarFinanceController extends GetxController {
  var isLoading = true.obs;
  var error = ''.obs;
  var unitData = <Unit>[].obs;
  var saveDetailsRes = <SaveCustomerProjectDetailsResponse>[].obs;

  @override
  void onInit() async {
    super.onInit();
  }

  fetchUnits() async {
    try {
      isLoading(true);
      BaseSolarRemoteDataSource baseSolarRemoteDataSource = s2<BaseSolarRemoteDataSource>();
      final result = await baseSolarRemoteDataSource.getUnits();

      result.fold(
            (l) => print("Error: $l"),
            (r) async {
          if (r.data.isNotEmpty && r.status == '200') {
            unitData.assignAll(r.data);
          }
        },
      );
    } catch (e) {
      error("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  saveProjectDetails(
    category,
    companyName,
    contactPerson,
    contactPersonMobileNo,
    contactPersonEmailId,
    secondaryContactName,
    secondaryContactMobileNo,
    secondaryContactEmailId,
    projectName,
    pincode,
    state,
    city,
    projectCapacity,
    unit,
    projectCost,
    preferredBankId,
    gstinNumber,
    panNumber) async {
      try {
        isLoading(true);
        BaseSolarRemoteDataSource baseSolarRemoteDataSource = s2<BaseSolarRemoteDataSource>();
        final result = await baseSolarRemoteDataSource.saveProjectDetails(
            category,
            companyName,
            contactPerson,
            contactPersonMobileNo,
            contactPersonEmailId,
            secondaryContactName,
            secondaryContactMobileNo,
            secondaryContactEmailId,
            projectName,
            pincode,
            state,
            city,
            projectCapacity,
            unit,
            projectCost,
            preferredBankId,
            gstinNumber,
            panNumber);

        result.fold(
              (l) => error("Error: $l"),
              (r) async {
            if (r.data !=null && r.status == '200') {
              saveDetailsRes.assign(r);
            }
          },
        );
      } catch (e) {
        error("Error: $e");
      } finally {
        isLoading(false);
      }
  }


  clearSolarFinanceController() {
    isLoading = true.obs;
    error = ''.obs;
    unitData = <Unit>[].obs;
    saveDetailsRes = <SaveCustomerProjectDetailsResponse>[].obs;
    update();
  }
}
