import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/presentation/screens/report_management/screens/secondary_report/distributor/select_date_filter_secondary.dart';

import '../../../../../../data/models/customer_wise_list_model.dart';
import '../../../../../../state/contoller/secondary_report_distributor_controller.dart';
import '../../../../../../state/contoller/user_data_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/enums.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../widgets/headers/back_button_header_widget.dart';
import '../../../../../widgets/verticalspace/vertical_space.dart';
import '../../../../base_screen.dart';
import '../../../../userprofile/user_profile_widget.dart';
import '../../../widgets/common_bottom_modal.dart';
import '../../../widgets/detailed_report_section.dart';
import '../../../widgets/dropdown_button.dart';
import '../../../widgets/overall_summary_1.dart';
import 'dealer_wise_summary.dart';
import 'user_list_filter.dart';

class SecondaryReportDistributor extends StatefulWidget {
  const SecondaryReportDistributor({super.key});

  @override
  State<SecondaryReportDistributor> createState() =>
      _SecondaryReportDistributorState();
}

class _SecondaryReportDistributorState
    extends BaseScreenState<SecondaryReportDistributor> {
  // secondaryReportSummaryController secondaryReportSummaryController = Get.find();
  SecondaryReportDistrubutorController dealerWiseListController = Get.find();
  UserDataController userDataController = Get.find();
  String selectedProducts = "";
  List<CustomerwiseListItem> originalCustomerWiseList = [];
  TextEditingController searchController = TextEditingController();
  String totalCustomersSelected = "";
  String customerFilterText = "";
  String detailedReportDateRange = "";
  bool isFilterApplied = false;

  void fetchData() async {
    fetchDealerList();
    fetchProducts();
    await dealerWiseListController.fetchSecondaryReportSummaryDistributor();
    originalCustomerWiseList =
        List.from(dealerWiseListController.customerWiseList);
  }

  void fetchDealerList() async {
    await dealerWiseListController.fetchDealerList();
    setState(() {
      totalCustomersSelected =
          "All ${dealerWiseListController.dealerList.length.toString()} dealers selected";
    });
    await dealerWiseListController.fetchSecondaryReportPdfDistributor();
    setState(() {});
  }

  void searchList() {
    String searchText = searchController.text;
    print(searchText);
    dealerWiseListController.updateSearch(searchController.text);
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
    dealerWiseListController.startDateController.text="";
    dealerWiseListController.endDateController.text="";
    dealerWiseListController.oldStartDateInMillis = 0;
    dealerWiseListController.oldEndDateInMillis = 0;
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
      dealerWiseListController.products.value = selectedProducts;
      dealerWiseListController.applyFilter();
    });
  }

  Map<TotalProductsField, dynamic> fetchProducts() {
    if (dealerWiseListController.secondarySaleList.isNotEmpty) {
      final Map<String, dynamic> firstItem =
          dealerWiseListController.secondarySaleList.first;

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

  void updateFilterText(int selectedCount) {
    setState(() {
      totalCustomersSelected = "$selectedCount dealers selected";
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
        dealerWiseListController.secondarySaleList.clear();
        dealerWiseListController.clearSecondaryReportState();
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
                  heading: translation(context).secondaryReport,
                  onPressed: () {
                    dealerWiseListController.secondarySaleList.clear();
                    dealerWiseListController.clearSecondaryReportState();
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
                        Obx(() {
                          if (dealerWiseListController.isDealerLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (dealerWiseListController
                              .dealerListError.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Error: ${dealerWiseListController.dealerListError.value}',
                                style:
                                    const TextStyle(color: AppColors.errorRed),
                              ),
                            );
                          } else {
                            final bool isDataEmpty =
                                dealerWiseListController.dealerList.isEmpty;
                            if (isDataEmpty) {
                              return DropDownButtonWidget(
                                isEnabled: false,
                                labelText:
                                    translation(context).dealerNameCode,
                                placeholdertext: "No Dealers found",
                                icon: Icons.keyboard_arrow_down_outlined,
                                textColor: AppColors.titleColor,
                                modalBody: Container(),
                              );
                            } else {
                              return DropDownButtonWidget(
                                labelText: translation(context).dealerNameCode,
                                placeholdertext: totalCustomersSelected,
                                icon: Icons.keyboard_arrow_down_outlined,
                                textColor: AppColors.titleColor,
                                modalBody: UserListFilterWidget(
                                  updateFilterText: updateFilterText,
                                  dealerList:
                                      dealerWiseListController.dealerList,
                                ),
                              );
                            }
                          }
                        }),
                        const VerticalSpace(height: 12),
                        Row(
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
                                    contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8 * w),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: AppColors.white_234),
                                      borderRadius:
                                      BorderRadius.circular(8 * r),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: AppColors.white_234),
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
                            SizedBox(width: 8 * w),
                            Container(
                              height: 45 * h,
                              width: 40 * w,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1,
                                      color: isFilterApplied
                                          ? AppColors.lumiBluePrimary
                                          : AppColors.white_234),
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
                                              .selectDateRange,
                                          body: SelectDateFilterSecondaryWidget(
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
                            ),
                          ],
                        ),
                        const VerticalSpace(height: 12),
                        Obx(() {
                          if (dealerWiseListController.isLoading.value) {
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
                          } else if (dealerWiseListController
                              .error.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Error: ${dealerWiseListController.error.value}',
                                style:
                                    const TextStyle(color: AppColors.errorRed),
                              ),
                            );
                          } else {
                            final bool isDataEmpty = dealerWiseListController
                                .secondarySaleList.isEmpty;
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
                                  Obx(() => DetailedReportSectionWidget(
                                        detailedReportText:
                                            detailedReportDateRange,
                                        pdfUrl: dealerWiseListController
                                            .reportUrl
                                            .toString(),
                                      )),
                                  const VerticalSpace(height: 24),
                                  
                                ],
                              );
                            }
                          }
                        }),
                        Obx(() {
                          if (dealerWiseListController.isDealerLoading.value) {
                            return Container();
                          } else if (dealerWiseListController
                              .error.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Error: ${dealerWiseListController.dealerListError.value}',
                                style:
                                    const TextStyle(color: AppColors.errorRed),
                              ),
                            );
                          } else {
                            final bool isDataEmpty = dealerWiseListController
                                .totalProductsStats.isEmpty;

                            if (isDataEmpty) {
                              return Container();
                            } else {
                              return Column(
                                children: [
                                  OverallSummaryWidget1(
                                    totalProducts: dealerWiseListController
                                        .totalProducts.value,
                                    productsList: dealerWiseListController
                                        .totalProductsStats,
                                    onProductChipTapped: onProductChipTapped,
                                  ),
                                  const VerticalSpace(height: 28),
                                ],
                              );
                            }
                          }
                        }),
                        Obx(() {
                          if (dealerWiseListController.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (dealerWiseListController
                              .error.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Error: ${dealerWiseListController.error.value}',
                                style:
                                    const TextStyle(color: AppColors.errorRed),
                              ),
                            );
                          } else {
                            final bool isDataEmpty = dealerWiseListController
                                .secondarySaleList.isEmpty;
                            if (isDataEmpty) {
                              return Container(
                                child: Center(
                                    child: Text(
                                  translation(context).dataNotFound,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14 * f,
                                      fontWeight: FontWeight.w500),
                                )),
                              );
                            } else {
                              return DealerWiseSummaryWidget(
                                usertype: "Dealer",
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
