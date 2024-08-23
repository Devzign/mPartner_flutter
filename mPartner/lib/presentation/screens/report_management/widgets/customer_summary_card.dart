import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../state/contoller/product_list_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../screens/secondary_report/distributor/secondary_report_product_detail_screen.dart';
import '../screens/tertiary_report/tertiary_report_product_detail_screen.dart';
import '../widgets/productchips/individual_product_chip_mini.dart';

class CustomerSummaryCardWidget extends StatelessWidget {
  String name, id, address, totalProducts, productTypesString;
  int index;
  String? type;
  Map<String, dynamic> productsList;

  CustomerSummaryCardWidget(
      {super.key,
      required this.name,
      required this.id,
      required this.address,
      required this.totalProducts,
      required this.productsList,
      required this.productTypesString,
      required this.index,
      this.type});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    ProductListController productListController = Get.find();
    UserDataController userDataController = Get.find();
    return GestureDetector(
      onTap: () async {
        await productListController.clearProductDetailsState();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ((type ?? "").contains("secondary"))
                    ? SecondaryReportProductDetail(
                        name: name,
                        id: id,
                        address: address,
                        totalProducts: totalProducts,
                        productsList: productsList,
                      )
                    : TertiaryReportProductDetail(
                        name: name,
                        id: id,
                        address: address,
                        totalProducts: totalProducts,
                        productsList: productsList,
                      )));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12 * w),
        margin: EdgeInsets.only(bottom: 20 * h),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: AppColors.lightGrey2),
            borderRadius: BorderRadius.circular(12 * r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width / 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 14 * f,
                            fontWeight: FontWeight.w500,
                            height: 22 / 14,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          id,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkGreyText,
                            fontSize: 12 * f,
                            fontWeight: FontWeight.w400,
                            height: 22 / 14,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          address,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkGreyText,
                            fontSize: 12 * f,
                            fontWeight: FontWeight.w400,
                            height: 16 / 14,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 90 * h,
                    decoration: ShapeDecoration(
                      color: AppColors.lumiLight5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          totalProducts,
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 16 * f,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        VerticalSpace(height: 4),
                        Text(
                          translation(context).totalProducts,
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 12 * f,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            VerticalSpace(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translation(context).productsCategory,
                  style: GoogleFonts.poppins(
                    color: AppColors.hintColor,
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                VerticalSpace(height: 8),
                Wrap(
                  spacing: 8 * w,
                  runSpacing: 8 * h,
                  children: productsList.entries.map((e) {
                    return ProductChipMiniWidget(
                        productName: e.key,
                        productCount: e.value.toString() ?? "0");
                  }).toList(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
