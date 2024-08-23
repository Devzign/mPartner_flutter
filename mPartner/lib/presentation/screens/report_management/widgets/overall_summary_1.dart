import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../../state/contoller/secondary_report_distributor_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../report_management_utils/report_management_utils.dart';
import 'productchips/individual_product_chip.dart';

class OverallSummaryWidget1 extends StatefulWidget {
  int totalProducts;
  Map<String, dynamic> productsList;
  final Function(String) onProductChipTapped;
  OverallSummaryWidget1(
      {Key? key, required this.totalProducts, required this.productsList, required this.onProductChipTapped})
      : super(key: key);

  @override
  State<OverallSummaryWidget1> createState() => _OverallSummaryWidget1State();
}

class _OverallSummaryWidget1State extends State<OverallSummaryWidget1> {
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation(context).overallSummary,
          style: GoogleFonts.poppins(
            color: AppColors.lumiDarkBlack,
            fontSize: 16 * f,
            fontWeight: FontWeight.w600,
          ),
        ),
        VerticalSpace(height: 4),
        Text(
         translation(context).secondaryReportDateFilterText,
          style: GoogleFonts.poppins(
            color: AppColors.darkGreyText,
            fontSize: 12 * f,
            fontWeight: FontWeight.w400,
          ),
        ),
        VerticalSpace(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8 * h),
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
                widget.totalProducts.toString(),
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
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 107 / 54,
            crossAxisCount: 3,
            crossAxisSpacing: 8 * w,
            mainAxisSpacing: 16 * h,
          ),
          itemCount: widget.productsList.length,
          itemBuilder: (context, index) {
            String field =
                widget.productsList.keys.elementAt(index);
            String productName = field;
            int? productCount = widget.productsList[field];
            int actualProductCount = productCount ?? 0;
            return IndividualProductChipWidget(
              productCount: actualProductCount,
              productName: productName,
              onChipTapped: widget.onProductChipTapped,
            );
          },
        ),
      ],
    );
  }
}
