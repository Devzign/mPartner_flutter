import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../services/services_locator.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/cash_history_model.dart';
import '../../data/models/loginflow_banner_model.dart';
import '../../utils/app_constants.dart';

class CommonLoginBannerController extends GetxController {
  var isLoading = true.obs;
  var cardData = <CardDatum>[].obs;
  var bannerCardData = <BannercardDatum>[].obs;


  @override
  void onInit() async {
    super.onInit();
  }

  fetchLoginBanners() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
      sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getLoginFlowBanners();
      isLoading.value=false;
      result.fold(
            (l){
              logger.e("Error: $l");},
            (r) async {
              if (r.data.isNotEmpty) {
                for (var data in r.data) {
                  if (data.bannercardData != null &&
                      data.bannercardData!.isNotEmpty) {
                    bannerCardData.addAll(data.bannercardData!);
                  }
                  if (data.cardData != null && data.cardData!.isNotEmpty) {
                    cardData.addAll(data.cardData!);
                  }
                }
              }
        },
      );
    } catch (e) {
      logger.e("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  clearLoginFlowBannerContainer() {
    cardData = <CardDatum>[].obs;
    bannerCardData = <BannercardDatum>[].obs;
    update();
  }


}
