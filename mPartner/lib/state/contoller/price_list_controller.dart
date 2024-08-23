import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/pricelist_model.dart';
import '../../utils/app_constants.dart';

class PriceListController extends GetxController {
  List<PricelistData> pricelistUrls = <PricelistData>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var isPriceListEmpty = true.obs;

  var pricelist = Pricelist(
    customertype: "",
    name: "",
    className: "",
    cardAction: "",
    backgroundImage: "",
    imageHeight: "",
    imageWidth: "",
    mainImage: "",
    title: "",
    subTitle: "",
    subtitleColor: "",
    cardData: "",
    bannercardData: "",
    action1Color: "",
    action1Text: "",
    subcategory: "",
    currentPage: "",
    productFooter: "",
    productUpper: "",
    productMain: "",
    bMHRData: "",
    dlrCode: "",
    dlrName: "",
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchPriceList(String userType) async {
    try {
      isLoading(true);
      final result = await mPartnerRemoteDataSource.postPricelist(userType, true);
      pricelistUrls.clear();
      result.fold(
        (failure) {
          // Handle failure (Left)
          error('Failed to fetch pricelist: $failure');
          isLoading(false);
        },
        (priceListData) async {
          isLoading(false);
          for (var option in priceListData) {
            if (option.props.every((value) => value == 'NA')) {
              error('No pricelist available');
            } else {
              error('');
            }
              pricelistUrls.add(PricelistData(
              customerType: option.customertype,
              mainImage: option.mainImage,
            ));
          }
          if(pricelistUrls.isNotEmpty){
            isPriceListEmpty.value = false;
          }
        },
      );
    } catch (e) {
      isLoading(false);
      error('Failed to fetch Pricelist');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  @override 
  clearPriceList(){
    pricelistUrls.clear();
    isLoading = false.obs;
    error = ''.obs;
    update();
  }
}

class PricelistData {
  final String? customerType;
  final String? mainImage;

  PricelistData({this.customerType, this.mainImage});
}
