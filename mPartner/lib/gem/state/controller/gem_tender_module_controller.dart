import 'package:get/get.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';

import '../../../services/services_locator.dart';
import '../../data/datasource/gem_remote_data_source.dart';
import '../../data/models/gem_tender_statedata_model.dart';
import '../../data/models/gem_tender_statelist_model.dart';

class GemTenderModuleController extends GetxController {
  //var isLoading = true.obs;
  var isLoading = false.obs;
  var error = RxString('');
  var gemTenderManagementStateList = <GemTenderStateListModel>[].obs;
  var gemTenderStateWiseDataList = <GemTenderStateDataModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
  }



  fetchGemStateManagementStateList() async {
    try {
      isLoading(true);
      BaseGemRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseGemRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getTenderStateList();
      print("gem tender management state list:: ${result}");
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
          gemTenderManagementStateList.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

   fetchStateWiseDataList(String state) async {
    try {
      isLoading(true);
       print("state:: ${state}");
      BaseGemRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseGemRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getTenderStateWiseData(state);
      print("tender statewise data list:: ${result}");
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
          gemTenderStateWiseDataList.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
      error(e.toString());
    } finally {
      isLoading(false);
      error('');
    }
  }

  clearGemTenderModuleController() {
    isLoading = true.obs;
    gemTenderManagementStateList = <GemTenderStateListModel>[].obs;
    gemTenderStateWiseDataList = <GemTenderStateDataModel>[].obs;
    update();
  }
}
