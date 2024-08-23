import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/get_dealer_list_model.dart';
import '../../services/services_locator.dart';

class DealerList extends GetxController {
  var dealerList = <Dealer>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var dealersSelected = ''.obs;


/*  Future<void> fetchDealerList() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getDealerList();
      print("result ::: $result");
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
          dealerList.addAll(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }*/

  clearDealerList() {
    dealerList.clear();
    dealersSelected.value = "";
    isLoading = false.obs;
    error = ''.obs;
  }
}
