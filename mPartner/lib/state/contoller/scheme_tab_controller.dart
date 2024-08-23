import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/scheme_model.dart';
import '../../presentation/screens/our_products/tab_scheme/components/Functions/constants/userType.dart';
import '../../utils/app_constants.dart';

class SchemeTabController extends GetxController {
  var userType = LuminuousUserType.ALL.obs;
  var currMonth =
      'All'
          .obs;

  var isLoadingScheme = false.obs;
  var error = ''.obs;
  List<Scheme> fetchedSchemes = [];

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchScheme() async {
    try {
      isLoadingScheme(true);
      final result = await mPartnerRemoteDataSource
          .postScheme(userType.toString().split(".")[1]);
      result.fold((failure) {}, (result) async {
        fetchedSchemes = result;
      });
    } catch (e) {
      logger.e("RA: Exception : ${e}");
      isLoadingScheme(false);
    } finally {
      isLoadingScheme(false);
    }
  }

  
  resetState() {
    userType = LuminuousUserType.ALL.obs;
    currMonth = 'All'.obs;
  }  


  
  changeUserType(LuminuousUserType newUserType) {
    userType.value = newUserType;
  }
}
