import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../report_management_utils/report_management_utils.dart';
import '../screens/secondary_report/distributor/secondary_report_product_detail_screen.dart';
import '../../../../state/contoller/product_list_controller.dart';
import '../../../../state/contoller/secondary_report_distributor_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../widgets/productchips/individual_product_chip_mini.dart';

class UserSummaryCardWidget extends StatelessWidget {
  String name, id, address, totalProducts, productTypesString;
  int index;
  Map<String, dynamic> productsList;
  UserSummaryCardWidget(
      {super.key,
      required this.name,
      required this.id,
      required this.address,
      required this.totalProducts,
      required this.productsList,
      required this.productTypesString,
      required this.index});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier(); 
    ProductListController productListController = Get.find();
    return GestureDetector(
      onTap: () async {
        await productListController.clearProductDetailsState();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondaryReportProductDetail(
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatNameInReport(truncateText(name, 25)),
                      style: GoogleFonts.poppins(
                        color: AppColors.blackText,
                        fontSize: 14 * f,
                        fontWeight: FontWeight.w500,
                        height: 22 / 14,
                        letterSpacing: 0.50,
                      ),
                    ),
                    Text(
                      id,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 12 * f,
                        fontWeight: FontWeight.w400,
                        height: 22 / 14,
                        letterSpacing: 0.50,
                      ),
                    ),
                    Text(
                      address,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 12 * f,
                        fontWeight: FontWeight.w400,
                        height: 16 / 14,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Container(
                    width: 130 * h,
                    padding: EdgeInsets.symmetric(
                        horizontal: 12 * w, vertical: 8 * h),
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
