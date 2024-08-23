import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/customer_wise_list_model.dart';
import '../../../../../state/contoller/customer_wise_list_controller.dart';
import '../../../../../state/contoller/tertiary_report_summary_controller.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/headers/back_button_header_widget.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../base_screen.dart';
import '../../../userprofile/user_profile_widget.dart';
import '../../widgets/common_bottom_modal.dart';
import '../../widgets/customer_wise_summary.dart';
import '../../widgets/detailed_report_section.dart';
import '../../widgets/filters/select_date_filter_tertiary.dart';
import '../../widgets/overall_summary_1.dart';

class TertiaryReportScreen extends StatefulWidget {
  const TertiaryReportScreen({super.key});

  @override
  State<TertiaryReportScreen> createState() => _TertiaryReportScreenState();
}

class _TertiaryReportScreenState extends BaseScreenState<TertiaryReportScreen> {
  TertiaryReportSummaryController tertiaryReportSummaryController = Get.find();
  CustomerWiseListController customerWiseListController = Get.find();
  UserDataController userDataController = Get.find();
  String selectedProducts = "";
  List<CustomerwiseListItem> originalCustomerWiseList = [];
  TextEditingController searchController = TextEditingController();

  //CustomerList customerListController = Get.find();
  //String totalCustomersSelected = "";
  //String customerFilterText = "";
  String detailedReportDateRange = "";
  bool isFilterApplied = false;

  void fetchData() async {
    fetchProducts();
    //  fetchCustomerList();
    await customerWiseListController
        .fetchTertiaryReportSummary(userDataController.sapId);
    originalCustomerWiseList =
        List.from(customerWiseListController.customerWiseList);
  }

  /* void fetchCustomerList() async {
    await customerListController.fetchCustomerList();
    setState(() {
      totalCustomersSelected =
          "All ${customerListController.customerList.length.toString()} customers selected";
    });
  } */

  void searchList() {
    customerWiseListController.updateSearch(searchController.text);
  }

  void updateRange(value) {
    setState(() {
      if (value == "") {
        detailedReportDateRange = "";
        isFilterApplied = false;
      }
      if (value != "") {
        detailedReportDateRange = value;
        isFilterApplied = true;
      }
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void onProductChipTapped(String productName) {
    Future.delayed(Duration.zero, () {
      setState(() {
        List<String> selectedProductsList = selectedProducts.split(',');
        if (selectedProductsList.contains(productName)) {
          selectedProductsList.remove(productName);
        } else {
          selectedProductsList.add(productName);
        }
        selectedProducts = selectedProductsList.join(',');
      });
      customerWiseListController.products.value = selectedProducts;
      customerWiseListController.applyFilter();
    });
  }

  Map<TotalProductsField, dynamic> fetchProducts() {
    if (customerWiseListController.tertiarySaleList.isNotEmpty) {
      final Map<String, dynamic> firstItem =
          customerWiseListController.tertiarySaleList.first;

      final Map<TotalProductsField, dynamic> totalProductsMap = {
        TotalProductsField.totalBatteryProduct:
            firstItem['totalBatteryProduct'],
        TotalProductsField.totalHKVAProduct: firstItem['totalHKVAProduct'],
        TotalProductsField.totalHUPSProduct: firstItem['totalHUPSProduct'],
        TotalProductsField.totalNXGProduct: firstItem['totalNXGProduct'],
        TotalProductsField.totalSolarBatteryProduct:
            firstItem['totalSolarBatteryProduct'],
        TotalProductsField.totalCRUZEProduct: firstItem['totalCRUZEProduct'],
        TotalProductsField.totalGTIProduct: firstItem['totalGTIProduct'],
        TotalProductsField.totalSolarPanelProduct:
            firstItem['totalSolarPanelProduct'],
        TotalProductsField.totalAutoBatteryProduct:
            firstItem['totalAutoBatteryProduct'],
        TotalProductsField.totalPCUProduct: firstItem['totalPCUProduct'],
        TotalProductsField.totalRegaliaProduct:
            firstItem['totalRegaliaProduct'],
      };
      final Map<TotalProductsField, dynamic> filteredProductsMap =
          Map.fromEntries(totalProductsMap.entries
              .where((entry) => entry.value != null && entry.value != 0));

      return filteredProductsMap;
    }
    return {};
  }

  /* void updateFilterText(int selectedCount) {
    setState(() {
      totalCustomersSelected = "$selectedCount customers selected";
    });
  } */

  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return WillPopScope(
      onWillPop: () async {
        //  customerListController.clearCustomerList();
        customerWiseListController.tertiarySaleList.clear();
        customerWiseListController.clearTertiaryReportState();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidgetWithBackButton(
                  heading: translation(context).tertiaryReport,
                  onPressed: () {
                    //customerListController.clearCustomerList();
                    customerWiseListController.tertiarySaleList.clear();
                    customerWiseListController.clearTertiaryReportState();
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
                      children: [
                        const VerticalSpace(height: 12),
                        Obx(() {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 45 * h,
                                  child: TextField(
                                    controller: searchController,
                                    maxLength: 50,
                                    onChanged: (value) {
                                      searchList();
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: customerWiseListController
                                              .isHistoricSearchRequest.value
                                          ? IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                customerWiseListController
                                                    .isHistoricSearchRequest
                                                    .value = false;
                                                customerWiseListController
                                                    .searchStr = "";
                                                searchController.clear();
                                                customerWiseListController
                                                    .fetchTertiaryReportSummary(
                                                        userDataController
                                                            .sapId);
                                              },
                                            )
                                          : null,
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: AppColors.lightGreyOval,
                                        size: 20 * w,
                                      ),
                                      counterText: "",
                                      hintText: translation(context).search,
                                      hintStyle: GoogleFonts.poppins(
                                          color: AppColors.hintColor,
                                          fontSize: 12 * f,
                                          fontWeight: FontWeight.w400,),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8 * w),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1,
                                            color: AppColors.white_234),
                                        borderRadius:
                                            BorderRadius.circular(8 * r),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1,
                                            color: AppColors.white_234),
                                        borderRadius:
                                            BorderRadius.circular(8 * r),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1,
                                            color: AppColors.lumiBluePrimary),
                                        borderRadius:
                                            BorderRadius.circular(8 * r),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Builder(builder: (context) {
                                if (customerWiseListController
                                    .isHistoricSearchRequest.isTrue) {
                                  return const SizedBox(width: 0);
                                }
                                return SizedBox(width: 8 * w);
                              }),
                              Builder(builder: (context) {
                                if (customerWiseListController
                                    .isHistoricSearchRequest.isTrue) {
                                  return Container();
                                }
                                return Container(
                                  height: 45 * h,
                                  width: 40 * w,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color: isFilterApplied
                                              ? AppColors.lumiBluePrimary
                                              : AppColors.white_234),
                                      borderRadius:
                                          BorderRadius.circular(8 * r),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(28 * r),
                                                topRight:
                                                    Radius.circular(28 * r))),
                                        showDragHandle: true,
                                        backgroundColor: AppColors.lightWhite1,
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return Container(
                                            child: CommonBottomModal(
                                              modalLabelText:
                                                  translation(context)
                                                      .selectDateRange,
                                              body:
                                                  SelectDateFilterTertiaryWidget(
                                                dateRangeSelected: (value) {
                                                  updateRange(value);
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
                                );
                              }),
                            ],
                          );
                        }),
                        const VerticalSpace(height: 12),
                        Obx(() {
                          if (customerWiseListController.isLoading.value) {
                            return Column(
                              children: [
                                DetailedReportSectionWidget(
                                  detailedReportText: detailedReportDateRange,
                                  pdfUrl: "",
                                ),
                                const VerticalSpace(height: 12),
                                const Divider(
                                  color: AppColors.grey,
                                  thickness: 0.5,
                                ),
                                const VerticalSpace(height: 24),
                              ],
                            );
                          } else if (customerWiseListController
                              .error.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Error: ${customerWiseListController.error.value}',
                                style:
                                    const TextStyle(color: AppColors.errorRed),
                              ),
                            );
                          } else {
                            final bool isDataEmpty = customerWiseListController
                                .tertiarySaleList.isEmpty;
                            if (isDataEmpty) {
                              return Column(
                                children: [
                                  DetailedReportSectionWidget(
                                    detailedReportText: detailedReportDateRange,
                                    pdfUrl: "",
                                  ),
                                  const VerticalSpace(height: 12),
                                  const Divider(
                                    color: AppColors.grey,
                                    thickness: 0.5,
                                  ),
                                  const VerticalSpace(height: 24),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  DetailedReportSectionWidget(
                                    detailedReportText: detailedReportDateRange,
                                    pdfUrl: customerWiseListController.reportUrl
                                        .toString(),
                                  ),
                                  const VerticalSpace(height: 24),
                                ],
                              );
                            }
                          }
                        }),
                        Obx(() {
                          /* if (customerListController.isLoading.value) {
                            return Container();
                          } else if (customerListController
                              .error.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Error: ${tertiaryReportSummaryController.error.value}',
                                style: const TextStyle(color: AppColors.errorRed),
                              ),
                            );
                          } else { */
                          final bool isDataEmpty = customerWiseListController
                              .totalProductsStats.isEmpty;

                          if (isDataEmpty) {
                            return Container();
                          } else {
                            return Column(
                              children: [
                                OverallSummaryWidget1(
                                  totalProducts: customerWiseListController
                                      .totalProducts.value,
                                  productsList: customerWiseListController
                                      .totalProductsStats,
                                  onProductChipTapped: onProductChipTapped,
                                ),
                                const VerticalSpace(height: 28),
                              ],
                            );
                          }
                          //  }
                        }),
                        Obx(() {
                          if (customerWiseListController.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (customerWiseListController
                              .error.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Error: ${customerWiseListController.error.value}',
                                style:
                                    const TextStyle(color: AppColors.errorRed),
                              ),
                            );
                          } else {
                            final bool isDataEmpty = customerWiseListController
                                .customerWiseList.isEmpty;
                            if (isDataEmpty) {
                              if (customerWiseListController
                                  .isHistoricSearchRequest.isTrue) {
                                return Center(
                                    child: Text(
                                  translation(context).dataNotFound,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14 * f,
                                      fontWeight: FontWeight.w500),
                                ));
                              }
                              if (customerWiseListController
                                  .searchStr.isNotEmpty) {
                                return (Column(
                                  children: [
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: Text(
                                        "Customer wise summary",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.blackText,
                                          fontSize: 16 * f,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const VerticalSpace(height: 16),
                                    Text(
                                      "No record found for ${customerWiseListController.searchStr} in the last 6 months.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14 * f,
                                          color: AppColors.grayText,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const VerticalSpace(height: 16),
                                    Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Color(0xFF284093),
                                            // Specify your primary color here
                                            width:
                                                1, // Specify the width of the border
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            customerWiseListController
                                                .isHistoricSearchRequest
                                                .value = true;
                                            // Resetting the date filter
                                            setState(() {
                                              detailedReportDateRange = "";
                                              isFilterApplied = false;
                                            });
                                            customerWiseListController
                                                .selectedDateFilter.value = "";
                                            tertiaryReportSummaryController
                                                .startDateController.text = "";
                                            tertiaryReportSummaryController
                                                .endDateController.text = "";
                                            customerWiseListController
                                                .fetchTertiaryReportSummary(
                                                    userDataController.sapId);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            backgroundColor: Color(0xFFFFFFFF),
                                            surfaceTintColor: Color(0xFFFFFFFF),
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                          ),
                                          child: Text(
                                            "Run historic search",
                                            // softWrap: true,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.lumiBluePrimary,
                                            ),
                                          ),
                                        ))
                                  ],
                                ));
                              }
                              return Center(
                                  child: Text(
                                translation(context).dataNotFound,
                                style: GoogleFonts.poppins(
                                    fontSize: 14 * f,
                                    fontWeight: FontWeight.w500),
                              ));
                            } else {
                              return CustomerWiseSummaryWidget(
                                usertype: "Customer",
                                productTypesString: selectedProducts,
                              );
                            }
                          }
                        }),
                      ]),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
