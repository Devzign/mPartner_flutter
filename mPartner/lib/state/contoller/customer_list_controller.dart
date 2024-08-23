import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/get_customer_list_model.dart';
import '../../services/services_locator.dart';

class CustomerList extends GetxController {
  var customerList = <Customer>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var customersSelected = ''.obs;


  fetchCustomerList() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getCustomerList();
      print("result ::: $result");
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
              customerList.addAll(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  clearCustomerList() {
    customerList.clear();
    customersSelected.value = '';
    isLoading = false.obs;
    error = ''.obs;
  }
}
