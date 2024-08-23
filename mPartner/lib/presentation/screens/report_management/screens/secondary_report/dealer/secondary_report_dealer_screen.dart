import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../state/contoller/product_list_controller.dart';
import '../../../../../../state/contoller/product_wise_details_controller.dart';
import '../../../../../../state/contoller/report_download_for_dealer_controller.dart';
import '../../../../../../state/contoller/user_data_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/enums.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../../utils/routes/app_routes.dart';
import '../../../../../widgets/headers/back_button_header_widget.dart';
import '../../../../../widgets/verticalspace/vertical_space.dart';
import '../../../../base_screen.dart';
import '../../../../userprofile/user_profile_widget.dart';
import '../../../widgets/common_bottom_modal.dart';
import '../../../widgets/detailed_report_section.dart';
import '../../../widgets/filters/select_date_status_dealer.dart';
import '../../../widgets/filters/select_date_status_filter.dart';
import '../../../widgets/overall_summary_3.dart';
import '../../../widgets/product_details_card.dart';
import '../../../widgets/product_wise_detail_header.dart';
import '../../../widgets/search_filter.dart';
import '../../select_report_type.dart';

class SecondaryReportDealer extends StatefulWidget {
  const SecondaryReportDealer({super.key});

  @override
  State<SecondaryReportDealer> createState() => _SecondaryReportDealerState();
}

class _SecondaryReportDealerState extends BaseScreenState<SecondaryReportDealer> {
  ProductWiseDetailsController productWiseDetailsController = Get.find();
  ProductListController productListController = Get.find();
  UserDataController userDataController = Get.find();
  SecondaryReportDealerDownloadController
      secondaryReportDealerDownloadController = Get.find();
  String selectedProducts = "";
  List<Map<String, dynamic>> originalProductsList = [];
  TextEditingController searchController = TextEditingController();
  String detailedReportDateRange = "";
  bool isFilterApplied = false;

  Future<void> fetchData() async {
    secondaryReportDealerDownloadController
        .fetchSecondaryReportForDealer(userDataController.sapId);
    productWiseDetailsController
        .fetchProductWiseDetails(userDataController.sapId);
    await productListController
        .fetchProductListDetails(userDataController.sapId);
    originalProductsList = List.from(productListController.productDetailsList);
  }

  Map<TotalProductsField, dynamic> fetchProducts() {
    if (productWiseDetailsController.productWiseDetailsList.isNotEmpty) {
      final Map<String, dynamic> firstItem =
          productWiseDetailsController.productWiseDetailsList.first;

      final Map<TotalProductsField, dynamic> totalProductsMap = {
        TotalProductsField.totalBatteryProduct:
            firstItem['totalBatteryProduct'],
        TotalProductsField.totalHKVAProduct: firstItem['totalHKVAProduct'],
        TotalProductsField.totalHUPSProduct: firstItem['totalHUPSProduct'],
        TotalProductsField.totalNXGProduct: firstItem['totalNXGProduct'],
        TotalProductsField.totalSolarBatteryProduct:
            firstItem['totalSolarBatteryProduct'],
        TotalProductsField.totalGTIProduct: firstItem['totalGTIProduct'],
        TotalProductsField.totalRegaliaProduct:
            firstItem['totalRegaliaProduct'],
        TotalProductsField.totalAutoBatteryProduct:
            firstItem['totalAutoBatteryProduct'],
        TotalProductsField.totalCRUZEProduct: firstItem['totalCRUZEProduct'],
        TotalProductsField.totalPCUProduct: firstItem['totalPCUProduct'],
        TotalProductsField.totalSolarPanelProduct:
            firstItem['totalSolarPanelProduct']
      };
      final Map<TotalProductsField, dynamic> filteredProductsMap =
          Map.fromEntries(totalProductsMap.entries
              .where((entry) => entry.value != null && entry.value != 0));
      return filteredProductsMap;
    }
    return {};
  }

  void onProductChipTapped(String productName) {
    setState(() {
      List<String> selectedProductsList = selectedProducts.split(', ');
      if (selectedProductsList.contains(productName)) {
        selectedProductsList.remove(productName);
      } else {
        selectedProductsList.add(productName);
      }
      selectedProducts = selectedProductsList.join(', ');
    });
    productListController.fetchProductListDetails(userDataController.sapId,
        status: productListController.selectedDateStatusMap['status'] ?? "",
        fromDate: productListController.selectedDateStatusMap['fromDate'] ?? "",
        toDate: productListController.selectedDateStatusMap['toDate'] ?? "",
        productType: selectedProducts);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void searchList() {
    String searchText = searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      productListController.productDetailsList.value = originalProductsList;
    } else {
      productListController.productDetailsList.value =
          originalProductsList.where((item) {
        String productModel = item['product_Model']?.toLowerCase() ?? '';
        String serialNumber =
            item['product_Serial_Number']?.toLowerCase() ?? '';
        String systemStatus = item['systemStatus']?.toLowerCase() ?? '';

        return productModel.contains(searchText) ||
            serialNumber.contains(searchText) ||
            systemStatus.contains(searchText);
      }).toList();
    }  }

  void updateDateRange(value) {
    setState(() {
      if (value == "" && productListController.selectedDateStatusMap['status'] == "") {
        isFilterApplied = false;
        detailedReportDateRange = "";
      }
      else {
        isFilterApplied = true;
        detailedReportDateRange = value;
      }
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return WillPopScope(
      onWillPop: () async {
        productWiseDetailsController.clearProductWiseDetailsState();
        productListController.clearProductDetailsState();
        Navigator.pop(context);
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus
                                    ?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.lightWhite1,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidgetWithBackButton(
                    heading: translation(context).secondaryReport,
                    onPressed: () {
                      productWiseDetailsController.clearProductWiseDetailsState();
                      productListController.clearProductDetailsState();
                     Navigator.pop(context);
                    }),
                UserProfileWidget(),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24 * w),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 40 * h,
                                child: TextField(
                                  controller: searchController,
                                  maxLength: 50,
                                  onChanged: (value) {
                                    searchList();
                                  },
                                  decoration: InputDecoration(
                                    counterText: "",
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: AppColors.lightGreyOval,
                                      size: 20 * w,
                                    ),
                                    hintText: translation(context).search,
                                    hintStyle: GoogleFonts.poppins(
                                      color: AppColors.hintColor,
                                      fontSize: 12 * f,
                                      fontWeight: FontWeight.w400,
                                      height: 40/12
                                    ),
                                    contentPadding:
                                        EdgeInsets.all(0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: AppColors.white_234),
                                      borderRadius: BorderRadius.circular(8 * r),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: AppColors.white_234),
                                      borderRadius: BorderRadius.circular(8 * r),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: AppColors.lumiBluePrimary),
                                      borderRadius: BorderRadius.circular(8 * r),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8 * w),
                            Container(
                              height: 40 * h,
                              width: 40 * w,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: isFilterApplied? AppColors.lumiBluePrimary : AppColors.white_234),
                                  borderRadius: BorderRadius.circular(8 * r),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(28 * r),
                                            topRight: Radius.circular(28 * r))),
                                    showDragHandle: true,
                                    backgroundColor: AppColors.lightWhite1,
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return Container(
                                        child: CommonBottomModal(
                                          modalLabelText: translation(context)
                                              .filter,
                                          body:
                                              SelectDateStatusDealerFilterWidget(
                                            id: userDataController.sapId,
                                            productTypesString: selectedProducts,
                                            productsList: {},
                                            name: "",
                                            address: "",
                                            totalProducts: "",
                                            dateRangeSelected: (value) {
                                              updateDateRange(value);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Center(
                                    child: Icon(
                                  isFilterApplied
                                      ? Icons.filter_alt
                                      : Icons.filter_alt_outlined,
                                  color: isFilterApplied
                                      ? AppColors.lumiBluePrimary
                                      : AppColors.blackText,
                                )),
                              ),
                            ),
                          ],
                        ),
                        VerticalSpace(height: 12),
                        Obx(() {
                          if (secondaryReportDealerDownloadController
                              .isLoading.value) {
                            return DetailedReportSectionWidget(
                                detailedReportText: detailedReportDateRange,
                                pdfUrl: "",
                              );
                          } else if (secondaryReportDealerDownloadController
                              .error.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Error: ${secondaryReportDealerDownloadController.error.value}',
                                style: TextStyle(color: AppColors.errorRed),
                              ),
                            );
                          } else {
                            final bool isDataEmpty =
                                secondaryReportDealerDownloadController
                                    .pdfUrl.value.isEmpty;
                            if (isDataEmpty) {
                              return DetailedReportSectionWidget(
                                detailedReportText: detailedReportDateRange,
                                pdfUrl: "",
                              );
                            } else {
                              return DetailedReportSectionWidget(
                                detailedReportText: detailedReportDateRange,
                                pdfUrl: secondaryReportDealerDownloadController
                                    .pdfUrl.value,
                              );
                            }
                          }
                        }),
                        VerticalSpace(height: 20),
                        Obx(() {
                          if (productWiseDetailsController.isLoading.value) {
                            return Container();
                          } else if (productWiseDetailsController
                              .error.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Error: ${productWiseDetailsController.error.value}',
                                style: TextStyle(color: AppColors.errorRed),
                              ),
                            );
                          } else {
                            final bool isDataEmpty = productWiseDetailsController
                                .productWiseDetailsList.isEmpty;
                            if (isDataEmpty) {
                              return Container();
                            } else {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OverallSummaryWidget3(
                                      productsList: fetchProducts(),
                                      totalProducts: productWiseDetailsController
                                          .productWiseDetailsList
                                          .first['totalProducts'],
                                      onProductChipTapped: onProductChipTapped,
                                      productTypesString: selectedProducts,
                                    ),
                                    VerticalSpace(height: 20),
                                    ProductWiseDetailHeader(),
                                    VerticalSpace(height: 12),
                                  ]);
                            }
                          }
                        }),
                        Obx(() {
                          if (productListController.isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (productListController.error.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Error: ${productListController.error.value}',
                                style: TextStyle(color: AppColors.errorRed),
                              ),
                            );
                          } else {
                            final bool isDataEmpty =
                                productListController.productDetailsList.isEmpty;
                            if (isDataEmpty) {
                              return Container(
                                child: Center(
                                  child: Text(translation(context).dataNotFound, style: GoogleFonts.poppins(
                                    fontSize: 14 * f,
                                    fontWeight: FontWeight.w500
                                  ),),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: productListController
                                      .productDetailsList.length,
                                  itemBuilder: (context, index) {
                                    return ProductDetailsCard(
                                      showPrimaryDate: false,
                                      serialNo: productListController
                                              .productDetailsList[index]
                                          ['product_Serial_Number'],
                                      status: productListController
                                              .productDetailsList[index]
                                          ['systemStatus'],
                                      productNo: productListController
                                              .productDetailsList[index]
                                          ['product_Model'],
                                      remark: productListController
                                                  .productDetailsList[index]
                                              ['systemRemark'] ??
                                          "",
                                      primaryDate: productListController
                                                  .productDetailsList[index]
                                              ['primary_Date'] ??
                                          "N/A",
                                      secondaryDate: productListController
                                                  .productDetailsList[index]
                                              ['secondaryDate'] ??
                                          "N/A",
                                      tertiaryDate: productListController
                                                  .productDetailsList[index]
                                              ['tertiaryDate'] ??
                                          "N/A",
                                    );
                                  });
                            }
                          }
                        })
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
