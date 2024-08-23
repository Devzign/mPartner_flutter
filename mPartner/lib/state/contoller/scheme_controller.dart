import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../utils/app_constants.dart';

class SchemeController extends GetxController {
  List<SchemeData> schemeList = <SchemeData>[].obs;
  var isLoading = true.obs;
  var error = ''.obs;
  var isSchemeListEmpty = true.obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchSchemeList(String userType) async {
    try {
      final result =
          await mPartnerRemoteDataSource.postSchemeHomepage(userType);
      schemeList.clear();
      result.fold(
        (failure) {
          // Handle failure (Left)
          isLoading(false);
          error('Failed to fetch scheme: $failure');
        },
        (schemeHomepageData) async {
          isLoading(false);
          for (var option in schemeHomepageData) {
            if (option.props.every((value) => value == 'NA')) {
              error('No schemes available');
            } else {
              error('');
            }
            schemeList.add(SchemeData(
              customerType: option.customerType,
              mainImage: option.mainImage,
            ));
          }
          isSchemeListEmpty.value = schemeList.isEmpty;
          update(); 
        },
      );
    } catch (e) {
      logger.e("RA: Exception : ${e}");
      isLoading(false);
      error('Failed to fetch Scheme');
    } finally {
      isLoading(false);
    }
  }

  @override
  clearSchemeList(){
    schemeList.clear();
    isLoading(false);
    error('');
    update();
  }
}

class SchemeData {
  final String? customerType;
  final String? mainImage;

  SchemeData({this.customerType, this.mainImage});
}
