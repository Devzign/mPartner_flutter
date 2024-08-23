import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/product_wise_detail_model.dart';
import '../../utils/app_constants.dart';

class ProductListController extends GetxController {
  var productDetailsList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var selectedDateStatusMap = <String, String>{
    'dateSelected' : '',
    'fromDate': '',
    'toDate': '',
    'status': '',
  }.obs;

  var productWiseDetails = ProductWiseDetails(
          productModel: "",
          productSerialNumber: "",
          systemStatus: "",
          systemRemark: "",
          primaryDate: "",
          secondaryDate: "",
          tertiaryDate: "",
          battery: 0,
          gti: 0,
          regalia: 0,
          cruze: 0,
          solarPanel: 0,
          autoBattery: 0,
          pcu: 0,
          hkva: 0,
          hups: 0,
          nxg: 0,
          solarBattery: 0,
          totalProduct: 0,
          totalBatteryProduct: 0,
          totalGTIProduct: 0,
          totalAutoBatteryProduct: 0,
          totalRegaliaProduct: 0,
          totalSolarPanelProduct: 0,
          totalPCUProduct: 0,
          totalCRUZEProduct: 0,
          totalHkvaProduct: 0,
          totalHupsProduct: 0,
          totalNxgProduct: 0,
          totalSolarBatteryProduct: 0,
          totalProducts: 0)
      .obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchProductListDetails(String dealerCode,
      {String productType = "",
      String distributorCode = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      toDate = AppConstants.TO_DATE}) async {
    try {
      isLoading(true);

      productDetailsList.clear();

      final result = await mPartnerRemoteDataSource.getProductWiseDetails(
          dealerCode,
          distributorCode: distributorCode,
          productType: productType,
          status: status,
          fromDate: fromDate,
          toDate: toDate);
      result.fold(
        (failure) {
          error('Failed to fetch product wise details: $failure');
        },
        (productDetails) async {
          for (ProductWiseDetails option in productDetails) {
            if (option.props.every((value) => value == 'NA')) {
              error('No product details available.');
            } else {
              error('');
            }
            productDetailsList.add(option.toJson());
            productWiseDetails(option);
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

  clearProductDetailsState() async {
    productDetailsList.clear();
    selectedDateStatusMap.clear();
    isLoading = false.obs;
    error = ''.obs;
  }
}
