import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/get_dealer_list_model.dart';
import '../../data/models/secondary_report_distributor_model.dart';
import '../../utils/app_constants.dart';
import '../../utils/utils.dart';

class CustomerNameMap {
  String customerName;
  int totalProducts;
  String customerAddress;
  Map<String, int> products;

  CustomerNameMap(
      {required this.customerName,
      required this.customerAddress,
      required this.totalProducts,
      required this.products});

  printData() {
    print(customerName);
    print(totalProducts);
    print(customerAddress);
    print(products);
  }
}

class SecondaryReportDistrubutorController extends GetxController {
  var secondarySaleList = <Map<String, dynamic>>[].obs;
  var customerWiseList = <DealerwiseListItem>[].obs;
  var dealerList = <Dealer>[].obs;
  var customerWiseListBeforeFilter = <DealerwiseListItem>[].obs;
  RxMap<String, int> totalProductsStats = {"totalProducts": 0}.obs;
  var totalProducts = 0.obs;
  var reportUrl = "".obs;
  var isLoading = false.obs;
  var isDealerLoading = false.obs;
  var error = ''.obs;
  var dealerListError = ''.obs;
  RxString selectedDateFilter = ''.obs;

  int oldStartDateInMillis = 0;
  int oldEndDateInMillis = 0;

  //var dealersSelected = ''.obs;
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  RxString from = ''.obs;
  RxString to = ''.obs;
  RxString products = ''.obs;
  RxString customers = ''.obs;
  String searchStr = "";
  var dealersSelected = ''.obs;

  var customerWiseListSummary =
      SecondaryReport(message: "", status: "", token: "", data: [], data1: "")
          .obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchDealerList() async {
    try {
      isDealerLoading(true);
      final result = await mPartnerRemoteDataSource.getDealerList();
      print("result ::: $result");
      result.fold(
        (l) => print("Error: $l"),
        (r) async {
          dealerList.addAll(r);
          setCustomerAddress();
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isDealerLoading(false);
    }
  }

  void setCustomerAddress() {
    customerWiseList?.forEach((element) {
      dealerList.forEach((dealer) {
        if (element.dealerCode == dealer.dlr_Sap_Code) {
          element.customerAddress =
              "${dealer.city}, ${dealer.district}, ${dealer.state}. ";
        }
      });
    });
  }

  Future<void> fetchSecondaryReportSummaryDistributor(
      {String dealerCode = "",
      String productType = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      String toDate = AppConstants.TO_DATE}) async {
    try {
      isLoading(true);
      secondarySaleList.clear();
      customerWiseList.clear();
      customerWiseListBeforeFilter.clear();
      totalProductsStats.clear();
      totalProducts.value = 0;
      reportUrl.value = "";

      List<String> productsList =
          products.split(',').where((i) => i != "").toList();
      List<String> customersList =
          customers.split(',').where((i) => i != "").toList();

      List<Map<String, dynamic>> temp = [];
      List<DealerwiseListItem> customerWiseListTemp = [];
      Map<String, CustomerNameMap> customerNameMap = {};
      Map<String, int> totalCountTempObject = {};

      final result =
          await mPartnerRemoteDataSource.postSecondarySummaryReportDistributor(
              productType: productType,
              status: status,
              fromDate: fromDate,
              toDate: toDate,
              dealerCode: dealerCode);
      result.fold(
        (failure) {
          // Handle failure (Left)
          error('Failed to fetch secondary report information: $failure');
        },
        (secondaryReportSummary) async {
          for (SecondaryReportListData option in secondaryReportSummary.data) {
            if (option.props.every((value) => value == 'NA')) {
              error('No secondary report summary available.');
            } else {
              error('');
            }
            var val = option.toJson();
            temp.add(val);

            // We are calculating the totals in the function below
            totalCountTempObject =
                updateTotalCounts(option, totalCountTempObject);

            if (productsList.isNotEmpty &&
                !productsList.contains(option.productType)) {
              continue;
            }

            // Filter based on customers
            if (customersList.isNotEmpty &&
                !customersList.contains(option.dealerCode)) {
              continue;
            }

            // filter based on search
            if (searchStr.isNotEmpty &&
                !(option.dealerName
                        .toLowerCase()
                        .contains(searchStr.toLowerCase()) ||
                    option.dealerCode.toString().contains(searchStr) ||
                    option.customerAddress.toString().contains(searchStr))) {
              continue;
            }


            // Below we are traversing all the secondary sales and
            // processing the counts of the product type based on the sale made.
            if (customerNameMap.containsKey(option.dealerCode)) {
              customerNameMap[option.dealerCode]!.totalProducts += 1;

              if (customerNameMap[option.dealerCode]!
                  .products
                  .containsKey(option.productType)) {
                final productCount = customerNameMap[option.dealerCode]!
                    .products[option.productType];
                if (productCount != null) {
                  customerNameMap[option.dealerCode]!
                      .products[option.productType] = productCount + 1;
                }
              } else {
                customerNameMap[option.dealerCode]!
                    .products[option.productType] = 1;
              }
            } else {
              customerNameMap[option.dealerCode] = CustomerNameMap(
                  customerName: option.dealerName,
                  customerAddress: option.customerAddress,
                  totalProducts: 0,
                  products: {});
              customerNameMap[option.dealerCode]!.totalProducts = 1;
              if (customerNameMap[option.dealerCode]!
                  .products
                  .containsKey(option.productType)) {
                final productCount = customerNameMap[option.dealerCode]!
                    .products[option.productType];
                if (productCount != null) {
                  customerNameMap[option.dealerCode]!
                      .products[option.productType] = productCount + 1;
                }
              } else {
                customerNameMap[option.dealerCode]!
                    .products[option.productType] = 1;
              }
            }
          }
          for (String dealerCode in customerNameMap.keys) {
            DealerwiseListItem custWiseListItemItrator = DealerwiseListItem(
                customerName: customerNameMap[dealerCode]!.customerName,
                dealerCode: dealerCode,
                customerAddress: customerNameMap[dealerCode]!.customerAddress,
                totalProducts: customerNameMap[dealerCode]!.totalProducts,
                products: customerNameMap[dealerCode]!.products);
            customerWiseListTemp.add(custWiseListItemItrator);
          }
          customerWiseListTemp.printInfo();
          customerWiseList.value = customerWiseListTemp;
          customerWiseListBeforeFilter.value = customerWiseListTemp;
          secondarySaleList.value = temp;
          // reportUrl.value = secondaryReportSummary.data1;
          totalProductsStats.value = totalCountTempObject;
        },
      );
    } finally {
      isLoading(false);
    }
  }

  Map<String, int> updateTotalCounts(
      SecondaryReportListData option, Map<String, int> totalCountTempObject) {
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

  applyFilter() {
    List<DealerwiseListItem> customerWiseListTemp = [];
    Map<String, CustomerNameMap> customerNameMap = {};
    bool isDateFilter = false;
    int fromDateMilli = 0;
    int toDateMilli = 0;
    isLoading(true);
    customerWiseList.clear();

    Map<String, int> totalCountTempObject = {};

    if (to.value.isNotEmpty && from.value.isNotEmpty) {
      String fromDateFull = convertDateFormat(from.value);
      String toDateFull = convertDateFormat(to.value);

      fromDateMilli = getDateFromFullDate(fromDateFull);
      // Adding the amount of milliseconds in a day to suffice the whole day which we missed in the calculation
      //We have also reduced a second from the calculation so that the date doesn't go to the next day
      toDateMilli = getDateFromFullDate(toDateFull) + 86399000; 
      isDateFilter = true;
      totalProducts.value = 0;
    }

    List<String> productsList =
        products.split(',').where((i) => i != "").toList();
    List<String> customersList =
        customers.split(',').where((i) => i != "").toList();

    for (int i = 0; i < secondarySaleList.length; i++) {
      SecondaryReportListData option =
          SecondaryReportListData.fromJson(secondarySaleList[i]);

      // Filter based on date
      if (isDateFilter) {
        
        int tertiarySaleDateMilliseconds =
            getDateFromFullDate(option.secondarySaleDate);
        
        


        if (!(tertiarySaleDateMilliseconds >= fromDateMilli &&
            tertiarySaleDateMilliseconds <= toDateMilli)) {
          continue;
        }
if(option.dealerName == "nalanda inverter and airconditioner") {
print(option.dealerName);
        print(option.secondarySaleDate);
        print(tertiarySaleDateMilliseconds);
        print(fromDateMilli);
        print(toDateMilli);
        print("-----------");
        }

        totalCountTempObject = updateTotalCounts(option, totalCountTempObject);
      }

      // Filter based on products
      if (productsList.isNotEmpty &&
          !productsList.contains(option.productType)) {
        continue;
      }

      // Filter based on customers
      if (customersList.isNotEmpty &&
          !customersList.contains(option.dealerCode)) {
        continue;
      }

      // filter based on search
      if (searchStr.isNotEmpty &&
          !(option.dealerName.toLowerCase().contains(searchStr.toLowerCase()) ||
              option.dealerCode.toString().contains(searchStr) ||
              option.customerAddress.toLowerCase().contains(searchStr))) {
        continue;
      }

      // Below we are traversing all the tertiary sales and
      // processing the counts of the product type based on the sale made.
      if (customerNameMap.containsKey(option.dealerCode)) {
        customerNameMap[option.dealerCode]!.totalProducts += 1;

        if (customerNameMap[option.dealerCode]!
            .products
            .containsKey(option.productType)) {
          final productCount =
              customerNameMap[option.dealerCode]!.products[option.productType];
          if (productCount != null) {
            customerNameMap[option.dealerCode]!.products[option.productType] =
                productCount + 1;
          }
        } else {
          customerNameMap[option.dealerCode]!.products[option.productType] = 1;
        }
      } else {
        customerNameMap[option.dealerCode] = CustomerNameMap(
            customerName: option.dealerName,
            customerAddress: option.customerAddress,
            totalProducts: 0,
            products: {});
        customerNameMap[option.dealerCode]!.totalProducts = 1;
        if (customerNameMap[option.dealerCode]!
            .products
            .containsKey(option.productType)) {
          final productCount =
              customerNameMap[option.dealerCode]!.products[option.productType];
          if (productCount != null) {
            customerNameMap[option.dealerCode]!.products[option.productType] =
                productCount + 1;
          }
        } else {
          customerNameMap[option.dealerCode]!.products[option.productType] = 1;
        }
      }
    }
    for (String dealerCode in customerNameMap.keys) {
      DealerwiseListItem custWiseListItemItrator = DealerwiseListItem(
          customerName: customerNameMap[dealerCode]!.customerName,
          dealerCode: dealerCode,
          customerAddress: customerNameMap[dealerCode]!.customerAddress,
          totalProducts: customerNameMap[dealerCode]!.totalProducts,
          products: customerNameMap[dealerCode]!.products);
      customerWiseListTemp.add(custWiseListItemItrator);
    }
    customerWiseListTemp
        .sort((a, b) => a.totalProducts > b.totalProducts ? -1 : 1);
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

  Future<void> fetchSecondaryReportPdfDistributor(
      {String fromDate = "", String toDate = "", dealerCode = ""}) async {
    try {
      final result =
          await mPartnerRemoteDataSource.getSecondaryReportPdfDistributor(
              productType: products.value,
              status: "",
              fromDate: from.value,
              toDate: to.value,
              dealerCode: customers.value);
      result.fold(
        (failure) {
          error('Failed to fetch PDF URL: $failure');
        },
        (pdfDistributor) {
          reportUrl.value = pdfDistributor;
        },
      );
    } catch (e) {
      print(e);
    } finally {
      update();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  clearSecondaryReportState() {
    secondarySaleList.clear();
    dealerList.clear();
    reportUrl.value = "";
    selectedDateFilter.value = "";
    from.value = "";
    to.value = "";
    oldStartDateInMillis = 0;
    oldEndDateInMillis = 0;
    isLoading = false.obs;
    //dealersSelected.value = '';
    customerWiseListBeforeFilter.clear();
    isDealerLoading.value = false;
    error = ''.obs;
    dealerListError = ''.obs;
    totalProductsStats.value = {"totalProducts": 0};
    totalProducts.value = 0;
    products.value = '';
    customers.value = '';
    searchStr = "";
    dealersSelected.value = '';
    isDealerLoading.value = false;
    error = ''.obs;
    dealerListError = ''.obs;
    update();
  }
}
