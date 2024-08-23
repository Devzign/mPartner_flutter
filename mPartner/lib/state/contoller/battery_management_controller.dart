import 'package:get/get.dart';

import '../../../services/services_locator.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/battery_management_address_model.dart';
import '../../data/models/battery_management_city_list.dart';
import '../../data/models/battery_management_state_list_model.dart';

class BatteryManagementController extends GetxController {
  var isLoading = true.obs;
  var batteryManagementStateList = <BatteryManagementStateListModel>[].obs;
  var batteryManagementCityList = <BatteryManagementCityListModel>[].obs;
  var batteryManagementAddressList = <BatteryManagementAddressModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
  }

  fetchBatteryManagementStateList() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getBatteryMgmtStateList();
      print("battery management state list:: ${result}");
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
          batteryManagementStateList.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  fetchBatteryManagementCityList(String state) async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getBatteryMgmtCityList(state);
      print("battery management city list:: ${result}");
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
          batteryManagementCityList.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  fetchBatteryManagementAddressList(String state, String city) async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getBatteryMgmtAddressList(state, city);
      print("battery management address list:: ${result}");
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
          batteryManagementAddressList.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  clearBatteryManagementController() {
    isLoading = true.obs;
    batteryManagementStateList = <BatteryManagementStateListModel>[].obs;
    batteryManagementCityList = <BatteryManagementCityListModel>[].obs;
    batteryManagementAddressList = <BatteryManagementAddressModel>[].obs;
    update();
  }
}
