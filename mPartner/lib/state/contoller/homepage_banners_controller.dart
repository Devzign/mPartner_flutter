import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/homepage_banners_model.dart';
import '../../utils/app_constants.dart';
import '../../utils/localdata/shared_preferences_util.dart';

class HomepageBannersController extends GetxController {
  List<String> bannerURLs = [];
  List<String> solarUrls = [];



  var isLoading = false.obs;
  var error = ''.obs;

  var homepageBanners = HomepageBanners(
    title: "",
    background_image: "",
    main_image: '',
    card_action: '',
    image_height: '',
    image_width: '',
    product_id: '',
    product_name: '',
  ).obs;

  var solar = HomepageBanners(
    title: "",
    background_image: "",
    main_image: '',
    card_action: '',
    image_height: '',
    image_width: '',
    product_id: '',
    product_name: '',
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchHomepageBanners(String type) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postHomepageBanners(type);
      result.fold(
        (failure) {
          // Handle failure (Left)
          error('Failed to fetch HomepageBanners: $failure');
        },
        (homepageBannersData) async {
          print("banner_url::::  ");

          if(type==AppConstants.mPartner){
            for (var option in homepageBannersData) {
              print("OPTION ${option}");
              if (option.props.every((value) => value == 'NA')) {
                error('No banners available');
              } else {
                error('');
              }
              bannerURLs = homepageBannersData
                  .map((option) => option.background_image)
                  .toList();
              homepageBanners(option);

            }
            updateBannerUrls(bannerURLs,type);
          }
          if(type==AppConstants.solar){

            for (var option in homepageBannersData) {
              print("OPTION SOLAR ${option}");
              if (option.props.every((value) => value == 'NA')) {
                error('No banners available');
              } else {
                error('');
              }

              solarUrls = homepageBannersData
                  .map((option) => option.background_image)
                  .toList();
              solar(option);

            }

            updateSolarUrls(solarUrls,type);

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

  updateBannerUrls(List<String> urls, String type) async {
    await SharedPreferencesUtil.saveHomepageBanners(urls);
    bannerURLs = urls;
    update();
  }
  updateSolarUrls(List<String> urls, String type) async {
    await SharedPreferencesUtil.saveHomepageBanners(urls);
    solarUrls = urls;

    update();
  }
}
