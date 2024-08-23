import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../state/contoller/product_list_controller.dart';
import '../../../../../../state/contoller/product_wise_details_controller.dart';
import '../../../../../../state/contoller/report_download_for_dealer_controller.dart';
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
import '../../../widgets/filters/select_date_status_filter.dart';
import '../../../widgets/overall_summary_2.dart';
import '../../../widgets/product_details_card.dart';
import '../../../widgets/product_wise_detail_header.dart';

class SecondaryReportProductDetail extends StatefulWidget {
  String? name, id, address, totalProducts, productTypesString, status;
  Map<String, dynamic>? productsList;

  SecondaryReportProductDetail(
      {super.key,
      this.name,
      required this.id,
      this.address,
      this.totalProducts,
      this.productsList,
      this.productTypesString = "",
      this.status = ""});

  @override
  State<SecondaryReportProductDetail> createState() =>
      _SecondaryReportProductDetailState();
}

class _SecondaryReportProductDetailState
    extends BaseScreenState<SecondaryReportProductDetail> {
  ProductWiseDetailsController productWiseDetailsController = Get.find();
  ProductListController productListController = Get.find();
  SecondaryReportDealerDownloadController
      secondaryReportDealerDownloadController = Get.find();
  List<Map<String, dynamic>> originalProductsList = [];
  TextEditingController searchController = TextEditingController();
  UserDataController userDataController = Get.find();
  String detailedReportDateRange = "";
  bool isFilterApplied = false;

  Future<void> fetchData() async {
    secondaryReportDealerDownloadController.fetchSecondaryReportForDealer(
        widget.id ?? "" ?? "",
        disID: userDataController.sapId);
    productWiseDetailsController.fetchProductWiseDetails(widget.id ?? "",
        distributorCode: userDataController.sapId,
        productType: widget.productTypesString ?? "");
    await productListController.fetchProductListDetails(widget.id ?? "",
        distributorCode: userDataController.sapId,
        productType: widget.productTypesString ?? "",
        status: widget.status ?? "");
    originalProductsList = List.from(productListController.productDetailsList);
  }

  void onProductChipTapped(String productName) {
    setState(() {
      List<String> selectedProductsList =
          (widget.productTypesString ?? "").split(', ');

      if (selectedProductsList.contains(productName)) {
        selectedProductsList.remove(productName);
      } else {
        selectedProductsList.add(productName);
      }

      widget.productTypesString = selectedProductsList.join(', ');
    });

    productListController.fetchProductListDetails(widget.id ?? "",
        distributorCode: userDataController.sapId,
        productType: widget.productTypesString ?? "",
        fromDate: productListController.selectedDateStatusMap['fromDate'] ?? "",
        toDate: productListController.selectedDateStatusMap['toDate'] ?? "",
        status: productListController.selectedDateStatusMap['status'] ?? "");
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
    }
  }

  @override
  void initState() {
    //clear filter
    productListController.selectedDateStatusMap['dateSelected'] = "";
    productListController.selectedDateStatusMap['status'] = "";
    productListController.selectedDateStatusMap['fromDate'] = "";
    productListController.selectedDateStatusMap['toDate'] = "";
    fetchData();
    super.initState();
  }

  void updateDateRange(value) {
    setState(() {
      if (value == "" &&
          productListController.selectedDateStatusMap['status'] == "") {
        isFilterApplied = false;
        detailedReportDateRange = "";
      } else {
        detailedReportDateRange = value;
        isFilterApplied = true;
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
        productWiseDetailsController.productWiseDetailsList.clear();
        productListController.productDetailsList.clear();
        Navigator.pop(context);
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                      productWiseDetailsController.productWiseDetailsList
                          .clear();
                      productListController.productDetailsList.clear();
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
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 40 * h,
                                child: TextField(
                                  controller: searchController,
                                  maxLength: 50,
                                  onChanged: (value) {
                                    setState(() {
                                      searchList();
                                    });
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
                                        fontWeight: FontWeight.w400,),
                                    contentPadding: const EdgeInsets.all(0),
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
                              height: 40 * h,
                              width: 40 * w,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: isFilterApplied
                                        ? AppColors.lumiBluePrimary
                                        : AppColors.white_234,
                                  ),
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
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return Container(
                                        child: CommonBottomModal(
                                          modalLabelText:
                                              translation(context).filter,
                                          body: SelectDateStatusFilterWidget(
                                            id: widget.id ?? "",
                                            productTypesString:
                                                widget.productTypesString ?? "",
                                            productsList:
                                                widget.productsList ?? Map(),
                                            name: widget.name ?? "",
                                            address: widget.address ?? "",
                                            totalProducts:
                                                widget.totalProducts ?? "",
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
                        VerticalSpace(height: 20),
                        Obx(() {
                          if (productListController.isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (productListController.error.isNotEmpty) {
                            return Center(
                              child: Text(translation(context)
                                  .somethingWentWrongPleaseRetry),
                            );
                          } else {
                            final bool isDataEmpty = productListController
                                .productDetailsList.isEmpty;
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
                        const VerticalSpace(height: 20),
                        OverallSummaryWidget2(
                          name: widget.name ?? "",
                          id: widget.id ?? "",
                          address: widget.address ?? "",
                          totalProducts: widget.totalProducts ?? "",
                          productsList: widget.productsList ?? Map(),
                          onProductChipTapped: onProductChipTapped,
                          productTypesString: widget.productTypesString ?? "",
                        ),
                        const VerticalSpace(height: 20),
                        Obx(
                          () {
                            if (productListController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (productListController.error.isNotEmpty) {
                              return Center(
                                child: Text(
                                  'Error: ${productListController.error.value}',
                                  style: const TextStyle(color: AppColors.errorRed),
                                ),
                              );
                            } else {
                              final bool isDataEmpty = productListController
                                  .productDetailsList.isEmpty;
                              if (isDataEmpty) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const ProductWiseDetailHeader(),
                                      const VerticalSpace(height: 50),
                                      Center(
                                          child: Text(
                                        translation(context).dataNotFound,
                                        style: GoogleFonts.poppins(
                                            fontSize: 14 * f,
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ]);
                              } else {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const ProductWiseDetailHeader(),
                                      const VerticalSpace(height: 12),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: productListController
                                              .productDetailsList.length,
                                          itemBuilder: (context, index) {
                                            return ProductDetailsCard(
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
                                                          .productDetailsList[
                                                      index]['systemRemark'] ??
                                                  'N/A',
                                              primaryDate: productListController
                                                          .productDetailsList[
                                                      index]['primary_Date'] ??
                                                  "N/A",
                                              secondaryDate: productListController
                                                          .productDetailsList[
                                                      index]['secondaryDate'] ??
                                                  "N/A",
                                              tertiaryDate: productListController
                                                          .productDetailsList[
                                                      index]['tertiaryDate'] ??
                                                  "N/A",
                                            );
                                          }),
                                    ]);
                              }
                            }
                          },
                        )
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
