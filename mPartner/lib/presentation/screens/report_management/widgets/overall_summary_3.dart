import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/presentation/screens/report_management/screens/secondary_report/distributor/secondary_report_product_detail_screen.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../report_management_utils/report_management_utils.dart';
import 'productchips/individual_product_chip_medium.dart';
import 'productchips/individual_product_chip_mini.dart';

class OverallSummaryWidget3 extends StatelessWidget {
   int totalProducts;
   String productTypesString;
  Map<TotalProductsField, dynamic> productsList;
  final Function(String) onProductChipTapped;
  OverallSummaryWidget3({super.key, required this.totalProducts, required this.productsList, required this.onProductChipTapped, required this.productTypesString});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 26 * h,
          padding: EdgeInsets.symmetric(horizontal: 8 * w, vertical: 12 * h),
          decoration: ShapeDecoration(
            color: AppColors.lumiLight4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4 * r),
                topRight: Radius.circular(4 * r),
              ),
            ),
          ),
          child: Text(
            translation(context).overallSummary,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 14 * f,
              fontWeight: FontWeight.w500,
              height: 0.09,
              letterSpacing: 0.10,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12 * w),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.lumiLight4),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12 * r),
                  bottomLeft: Radius.circular(12 * r),
                  bottomRight: Radius.circular(12 * r)),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        Container(
          width: double.infinity,
          height: 60 * h,
          decoration: ShapeDecoration(
            color: AppColors.lumiLight5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8 * r)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                totalProducts.toString(),
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 20 * f,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                translation(context).totalProductsSold,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
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
                    return ProductChipMediumWidget(
                        productName: getProductName(e.key),
                        productCount: e.value.toString() ?? "0",
                        onProductTapped: onProductChipTapped);
                  }).toList(),
                ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
