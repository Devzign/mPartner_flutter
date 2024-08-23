import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/enums.dart';
import '../../../../../state/contoller/tertiary_customer_wise_products_controller.dart';
import '../../../../../state/contoller/tertiary_product_wise_details_controller.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/headers/back_button_header_widget.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../base_screen.dart';
import '../../../userprofile/user_profile_widget.dart';
import '../../report_management_utils/report_management_utils.dart';
import '../../widgets/common_bottom_modal.dart';
import '../../widgets/detailed_report_section.dart';
import '../../widgets/filters/select_date_status_filter.dart';
import '../../widgets/filters/select_date_status_tertiary.dart';
import '../../widgets/overall_summary_2.dart';
import '../../widgets/product_details_card.dart';
import '../../widgets/product_wise_detail_header.dart';
import '../../widgets/search_filter.dart';

class TertiaryReportProductDetail extends StatefulWidget {
  String name, id, address, totalProducts, productTypesString, status;
  Map<String, dynamic> productsList;
  TertiaryReportProductDetail(
      {super.key,
      required this.name,
      required this.id,
      required this.address,
      required this.totalProducts,
      required this.productsList,
      this.productTypesString = "",
      this.status = ""});

  @override
  State<TertiaryReportProductDetail> createState() =>
      _SecondaryReportProductDetailState();
}

class _SecondaryReportProductDetailState
    extends BaseScreenState<TertiaryReportProductDetail> {
  TertiaryCustomerWiseProduct tertiaryCustomerWiseProductController =
      Get.find();
  TertiaryProductWiseDetails tertiaryProductWiseDetailsController = Get.find();
  List<Map<String, dynamic>> originalProductsList = [];
  TextEditingController searchController = TextEditingController();
  String detailedReportDateRange = "";
  UserDataController userDataController = Get.find();
  bool isFilterApplied = false;

  Future<void> fetchData() async {
    await tertiaryProductWiseDetailsController
          .fetchTertiaryCustomerWiseProductsSummary(widget.id,
              disId: userDataController.sapId);
    originalProductsList = List.from(
        tertiaryProductWiseDetailsController.tertiaryProductWiseDetailsList);
  }

  void onProductChipTapped(String productName) {
    setState(() {
      List<String> selectedProductsList = widget.productTypesString.split(', ');

      if (selectedProductsList.contains(productName)) {
        selectedProductsList.remove(productName);
      } else {
        selectedProductsList.add(productName);
      }

      widget.productTypesString = selectedProductsList.join(', ');
    });
      tertiaryProductWiseDetailsController
          .fetchTertiaryCustomerWiseProductsSummary(widget.id,
              disId: userDataController.sapId,
              productType: widget.productTypesString,
              status: tertiaryProductWiseDetailsController.selectedDateStatusMap['status'] ?? "",
              fromDate:
                  tertiaryProductWiseDetailsController
                          .selectedDateStatusMap['fromDate'] ?? "",
              toDate: tertiaryProductWiseDetailsController
                      .selectedDateStatusMap['toDate'] ?? "");
  }

  bool isPrimaryDateVisible() {
    if (userDataController.userType.toLowerCase() == 'disty') {
      return true;
    } else if (userDataController.userType.toLowerCase() == 'dealer') {
      return false;
    }
    return false;
  }

  bool isSecondaryDateVisible() {
    if (userDataController.userType.toLowerCase() == 'disty') {
      return false;
    } else if (userDataController.userType.toLowerCase() == 'dealer') {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void searchList() {
    String searchText = searchController.text.toLowerCase();

    if (searchText.isEmpty) {
      tertiaryProductWiseDetailsController
          .tertiaryProductWiseDetailsList.value = originalProductsList;
    } else {
      tertiaryProductWiseDetailsController.tertiaryProductWiseDetailsList
          .value = originalProductsList.where((item) {
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

  void updateDateRange(value) {
    setState(() {
      if (value == "" && tertiaryProductWiseDetailsController.selectedDateStatusMap['status'] == "") {
        isFilterApplied = false;
      }
      else {
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
        tertiaryCustomerWiseProductController.tertiaryCustomerWiseProductsList
            .clear();
        tertiaryProductWiseDetailsController.clearTertiaryReportState();
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
                    heading: translation(context).tertiaryReport,
                    onPressed: () {
                      tertiaryCustomerWiseProductController
                          .tertiaryCustomerWiseProductsList
                          .clear();
                      tertiaryProductWiseDetailsController
                          .tertiaryProductWiseDetailsList
                          .clear();
                      tertiaryProductWiseDetailsController.selectedDateStatusMap
                          .clear();
                      tertiaryProductWiseDetailsController
                          .clearTertiaryReportState();
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
                                height: 45 * h,
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
                                      fontWeight: FontWeight.w400,
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8 * w),
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
                                          modalLabelText:
                                              translation(context).filter,
                                          body:
                                              SelectDateStatusFilterTertiaryWidget(
                                            id: widget.id,
                                            productTypesString:
                                                widget.productTypesString,
                                            productsList: widget.productsList,
                                            name: widget.name,
                                            address: widget.address,
                                            totalProducts: widget.totalProducts,
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
                        const VerticalSpace(
                          height: 12,
                        ),
                        Obx(
                          () {
                            if (tertiaryProductWiseDetailsController
                                .isLoading.value) {
                              return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      DetailedReportSectionWidget(
                                          detailedReportText:
                                              detailedReportDateRange,
                                          pdfUrl: ""),
                                      VerticalSpace(height: 20),
                                    ]);
                            } else if (tertiaryProductWiseDetailsController
                                .error.isNotEmpty) {
                              return Container();
                            } else {
                              final bool isDataEmpty =
                                  tertiaryProductWiseDetailsController
                                      .tertiaryProductWiseDetailsList.isEmpty;
                              if (isDataEmpty) {
                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      DetailedReportSectionWidget(
                                          detailedReportText:
                                              detailedReportDateRange,
                                          pdfUrl: ""),
                                      VerticalSpace(height: 20),
                                    ]);
                              } else {
                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      DetailedReportSectionWidget(
                                        detailedReportText:
                                            detailedReportDateRange,
                                        pdfUrl:
                                            tertiaryProductWiseDetailsController
                                                .reportUrl
                                                .toString(),
                                      ),
                                      VerticalSpace(height: 20),
                                    ]);
                              }
                            }
                          },
                        ),
                        OverallSummaryWidget2(
                                      name: widget.name,
                                      id: widget.id,
                                      address: widget.address,
                                      totalProducts: widget.totalProducts,
                                      productsList: widget.productsList,
                                      onProductChipTapped: onProductChipTapped,
                                      productTypesString:
                                          widget.productTypesString,
                                    ),
                        VerticalSpace(height: 20),
                        Obx(
                          () {
                            if (tertiaryProductWiseDetailsController
                                .isLoading.value) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (tertiaryProductWiseDetailsController
                                .error.isNotEmpty) {
                              return Container();
                            } else {
                              final bool isDataEmpty =
                                  tertiaryProductWiseDetailsController
                                      .tertiaryProductWiseDetailsList.isEmpty;
                              if (isDataEmpty) {
                                return Center(
                                    child: Container(
                                  child: Text(
                                    translation(context).dataNotFound,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14 * f,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ));
                              } else {
                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ProductWiseDetailHeader(),
                                      VerticalSpace(height: 12),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount:
                                              tertiaryProductWiseDetailsController
                                                  .tertiaryProductWiseDetailsList
                                                  .length,
                                          itemBuilder: (context, index) {
                                            return ProductDetailsCard(
                                              showPrimaryDate:
                                                  isPrimaryDateVisible(),
                                              showSecondaryDate:
                                                  isSecondaryDateVisible(),
                                              serialNo: tertiaryProductWiseDetailsController
                                                      .tertiaryProductWiseDetailsList[
                                                  index]['product_Serial_Number'],
                                              status: tertiaryProductWiseDetailsController
                                                      .tertiaryProductWiseDetailsList[
                                                  index]['systemStatus'],
                                              productNo:
                                                  tertiaryProductWiseDetailsController
                                                          .tertiaryProductWiseDetailsList[
                                                      index]['product_Model'],
                                              remark: tertiaryProductWiseDetailsController
                                                          .tertiaryProductWiseDetailsList[
                                                      index]['systemRemark'] ??
                                                  '',
                                              primaryDate:
                                                  tertiaryProductWiseDetailsController
                                                          .tertiaryProductWiseDetailsList[
                                                      index]['primary_Date'],
                                              secondaryDate:
                                                  tertiaryProductWiseDetailsController
                                                              .tertiaryProductWiseDetailsList[
                                                          index]['secondaryDate'] ??
                                                      "N/A",
                                              tertiaryDate:
                                                  tertiaryProductWiseDetailsController
                                                              .tertiaryProductWiseDetailsList[
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
