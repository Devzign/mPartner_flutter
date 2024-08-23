import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/customer_wise_list_model.dart';
import '../../data/models/tertiary_report_model.dart';
import '../../utils/app_constants.dart';
import '../../utils/utils.dart';
import 'user_data_controller.dart';

class CustomerNameMap {
  String customerName;
  int totalProducts;
  String customerAddress;
  Map<String, int> products;

  CustomerNameMap({
    required this.customerName,
    required this.customerAddress,
    required this.totalProducts,
    required this.products
  });
}

class CustomerWiseListController extends GetxController {
  var tertiarySaleList = <Map<String, dynamic>>[].obs;
  var customerWiseList = <CustomerwiseListItem>[].obs;
  var customerWiseListBeforeFilter = <CustomerwiseListItem>[].obs;
  RxMap<String, int> totalProductsStats = {
    "totalProducts": 0
  }.obs;
  var totalProducts = 0.obs;
  var reportUrl = "".obs;
  var isLoading = false.obs;
  var error = ''.obs;
  RxString selectedDateFilter = ''.obs;
  
  var dataFromMilli = 0.obs;
  var dataToMilli = 0.obs;
  final UserDataController _userDataController = Get.find();

  RxString from = ''.obs;
  RxString to = ''.obs;
  RxString products = ''.obs;
  RxString customers = ''.obs;
  String searchStr = "";
  RxBool isHistoricSearchRequest = false.obs;


  var customerWiseListSummary =
      TertiaryReport(message: "", status: "", token: "", data: [], data1: "")
          .obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchTertiaryReportSummary(userId,
      {String productType = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      String toDate = AppConstants.TO_DATE,
      String customerPhone = ""}) async {
    try {
      isLoading(true);
      tertiarySaleList.clear();
      customerWiseList.clear();
      customerWiseListBeforeFilter.clear();
      totalProductsStats.clear();
      totalProducts.value = 0;
      reportUrl.value = "";
      if (isHistoricSearchRequest.isTrue) {
        to.value = "";
        from.value = "";
        products.value = '';
        customers.value = '';
      }
      if(fromDate == "" && toDate == "") {
        DateTime now = DateTime.now();
        int nowMilliseconds = now.millisecondsSinceEpoch;
        int sixMonthsInMilli = 6 * 30 * 24 * 3600 * 1000;
        dataFromMilli.value = nowMilliseconds - sixMonthsInMilli;
        dataToMilli.value = nowMilliseconds;
      } else {
        String fromFullDate = convertDateFormat(fromDate);
        int fromDateMilli = getDateFromFullDate(fromFullDate);
        String toFullDate = convertDateFormat(toDate);
        int toDateMilli = getDateFromFullDate(toFullDate);
        dataFromMilli.value = fromDateMilli;
        dataToMilli.value = toDateMilli;
      }

      List<String> productsList = products.split(',').where((i) => i != "").toList();
      List<String> customersList = customers.split(',').where((i) => i != "").toList();

      List<Map<String, dynamic>> temp = [];
      List<CustomerwiseListItem> customerWiseListTemp = [];
      Map<String, CustomerNameMap> customerNameMap = {};
      Map<String, int> totalCountTempObject = {};

      final result = await mPartnerRemoteDataSource.postTertiaryReport(userId,
          productType: productType,
          status: status,
          fromDate: fromDate,
          toDate: toDate,
          customerPhone: customerPhone,
          search: searchStr,
          showHistoricData: isHistoricSearchRequest.isTrue);
      result.fold(
        (failure) {
          // Handle failure (Left)
          error(
              'Failed to fetch tertiary report information: $failure');
        },
        (tertiaryReportSummary) async {
          for (TertiaryReportListData option in tertiaryReportSummary.data) {
            if (option.props.every((value) => value == 'NA')) {
              error('No tertiary report summary available.');
            } else {
              error('');
            }
            var val = option.toJson();
            temp.add(val);

            // We are calculating the totals in the function below
            totalCountTempObject = updateTotalCounts(option, totalCountTempObject);

            if (productsList.isNotEmpty && !productsList.contains(option.productType)) {
              continue;
            }

            // Filter based on customers
            if (customersList.isNotEmpty && !customersList.contains(option.customerPhone)) {
              continue;
            }

            // filter based on search
            if (searchStr.isNotEmpty && !(option.customerName
                    .toLowerCase()
                    .contains(searchStr.toLowerCase()) ||
                option.customerPhone.toString().contains(searchStr) ||
                option.customerAddress.toString().contains(searchStr))) {
              continue;
            }

            // Below we are traversing all the tertiary sales and
            // processing the counts of the product type based on the sale made.
            if (customerNameMap.containsKey(option.customerPhone)) {
              customerNameMap[option.customerPhone]!.totalProducts += 1;

              if (customerNameMap[option.customerPhone]!.products.containsKey(option.productType)) {
                final productCount = customerNameMap[option.customerPhone]!.products[option.productType];
                if (productCount != null) {
                  customerNameMap[option.customerPhone]!.products[option.productType] = productCount + 1;
                }
              } else {
                customerNameMap[option.customerPhone]!.products[option.productType] = 1;
              }
            } else {
              customerNameMap[option.customerPhone] = CustomerNameMap(customerName: option.customerName, customerAddress: option.customerAddress, totalProducts: 0, products: {});
              customerNameMap[option.customerPhone]!.totalProducts = 1;
              if (customerNameMap[option.customerPhone]!.products.containsKey(option.productType)) {
                final productCount =   customerNameMap[option.customerPhone]!.products[option.productType];
                if(productCount != null) {
                  customerNameMap[option.customerPhone]!.products[option.productType] = productCount + 1;
                } 
              } else {
                customerNameMap[option.customerPhone]!.products[option.productType] = 1;
              }
            }
          }
          for (String customerNumber in customerNameMap.keys) {
            CustomerwiseListItem custWiseListItemItrator = CustomerwiseListItem(
              customerName: customerNameMap[customerNumber]!.customerName,
              customerPhone: customerNumber,
              customerAddress: customerNameMap[customerNumber]!.customerAddress,
              totalProducts: customerNameMap[customerNumber]!.totalProducts,
              products: customerNameMap[customerNumber]!.products);
            customerWiseListTemp.add(custWiseListItemItrator);
          }
          customerWiseListTemp.printInfo();
          customerWiseListTemp.sort((a,b) => a.totalProducts > b.totalProducts ? -1 : 1);
          customerWiseList.value = customerWiseListTemp;
          customerWiseListBeforeFilter.value = customerWiseListTemp;
          tertiarySaleList.value = temp;
          reportUrl.value = tertiaryReportSummary.data1;
          totalProductsStats.value = totalCountTempObject;
          _getPdfLink();
        },
      );
    } finally {
      isLoading(false);
    }
  }

  applyFilter() {
    List<CustomerwiseListItem> customerWiseListTemp = [];
    Map<String, CustomerNameMap> customerNameMap = {};
    bool isDateFilter = false;
    int fromDateMilli = 0;
    int toDateMilli = 0;

    _getPdfLink();

    isLoading(true);
    customerWiseList.clear();
    
    Map<String, int> totalCountTempObject = {};

    if(to.value.isNotEmpty && from.value.isNotEmpty) {
      String fromDateFull = convertDateFormat(from.value);
      String toDateFull = convertDateFormat(to.value);

      fromDateMilli = getDateFromFullDate(fromDateFull);
      // Adding the amount of milliseconds in a day to suffice the whole day which we missed in the calculation
      //We have also reduced a second from the calculation so that the date doesn't go to the next day
      toDateMilli = getDateFromFullDate(toDateFull) + 86399000; 
      isDateFilter = true;
      totalProducts.value = 0;
    }

    List<String> productsList = products.split(',').where((i) => i != "").toList();
    List<String> customersList = customers.split(',').where((i) => i != "").toList();

    for (int i = 0; i < tertiarySaleList.length; i++) {
      TertiaryReportListData option = TertiaryReportListData.fromJson(tertiarySaleList[i]);

      // Filter based on date
      if (isDateFilter) {
        int tertiarySaleDateMilliseconds = getDateFromFullDate(option.tertiaryDate);

        print(tertiarySaleDateMilliseconds);
        print(fromDateMilli);
        print(toDateMilli);
        print("--------------");

        if (!(tertiarySaleDateMilliseconds >= fromDateMilli && tertiarySaleDateMilliseconds <= toDateMilli)) {
          continue;
        }

        totalCountTempObject = updateTotalCounts(option, totalCountTempObject);
      }
      
      // Filter based on products
      if (productsList.isNotEmpty && !productsList.contains(option.productType)) {
        continue;
      }

      // Filter based on customers
      if (customersList.isNotEmpty && !customersList.contains(option.customerPhone)) {
        continue;
      }

      // filter based on search
      if (searchStr.isNotEmpty && !(option.customerName.toLowerCase().contains(searchStr.toLowerCase()) ||
          option.customerPhone.toString().contains(searchStr) ||
          option.customerAddress.toLowerCase().contains(searchStr))) {
        continue;
      }

      // Below we are traversing all the tertiary sales and
      // processing the counts of the product type based on the sale made.
      if (customerNameMap.containsKey(option.customerPhone)) {
        customerNameMap[option.customerPhone]!.totalProducts += 1;

        if (customerNameMap[option.customerPhone]!.products.containsKey(option.productType)) {
          final productCount = customerNameMap[option.customerPhone]!.products[option.productType];
          if (productCount != null) {
            customerNameMap[option.customerPhone]!.products[option.productType] = productCount + 1;
          }
        } else {
          customerNameMap[option.customerPhone]!.products[option.productType] = 1;
        }
      } else {
        customerNameMap[option.customerPhone] = CustomerNameMap(customerName: option.customerName, customerAddress: option.customerAddress, totalProducts: 0, products: {});
        customerNameMap[option.customerPhone]!.totalProducts = 1;
        if (customerNameMap[option.customerPhone]!.products.containsKey(option.productType)) {
          final productCount =   customerNameMap[option.customerPhone]!.products[option.productType];
          if(productCount != null) {
            customerNameMap[option.customerPhone]!.products[option.productType] = productCount + 1;
          } 
        } else {
          customerNameMap[option.customerPhone]!.products[option.productType] = 1;
        }
      }
    }
    for (String customerNumber in customerNameMap.keys) {
      CustomerwiseListItem custWiseListItemItrator = CustomerwiseListItem(
        customerName: customerNameMap[customerNumber]!.customerName,
        customerPhone: customerNumber,
        customerAddress: customerNameMap[customerNumber]!.customerAddress,
        totalProducts: customerNameMap[customerNumber]!.totalProducts,
        products: customerNameMap[customerNumber]!.products);
      customerWiseListTemp.add(custWiseListItemItrator);
    }
    customerWiseListTemp.sort((a,b) => a.totalProducts > b.totalProducts ? -1 : 1);
    customerWiseList.value = customerWiseListTemp;
    if (isDateFilter) {
      totalProductsStats.value = totalCountTempObject;
    }
    isLoading(false);
  }

  updateSearch(String str) {
    searchStr = str;
    applyFilter();
    update();
  }

  Map<String, int> updateTotalCounts(TertiaryReportListData option, Map<String, int> totalCountTempObject) {
    totalProducts += 1;

    if (totalCountTempObject.containsKey(option.productType)) {
      final productCount = totalCountTempObject[option.productType];
      if (productCount != null) {
        totalCountTempObject[option.productType] = productCount + 1;
      }
    } else {
      totalCountTempObject[option.productType] = 1;
    }

    return totalCountTempObject;
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  void _getPdfLink() async{
    final result = await mPartnerRemoteDataSource.getTertiaryReportPdfFile(_userDataController.sapId,
            productType: products.value,
            status: "",
            fromDate: from.value,
            toDate: to.value,
            customerPhone: customers.value,
            search: searchStr,
            showHistoricData: isHistoricSearchRequest.value);
    
    reportUrl.value = result;
  }

  clearTertiaryReportState() {
    tertiarySaleList.clear();
    customerWiseList.clear();
    customerWiseListBeforeFilter.clear();
    reportUrl.value = "";
    selectedDateFilter.value = "";
    from.value = "";
    to.value= "";
    isLoading = false.obs;
    error = ''.obs;
    totalProductsStats.value = {
      "totalProducts": 0
    };
    totalProducts.value = 0;
    products.value = '';
    customers.value = '';
    dataFromMilli.value = 0;
    dataToMilli.value = 0;
    searchStr = "";
    isHistoricSearchRequest.value = false;
    update();
  }
}