import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'date_types_product_detail.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/localdata/shared_preferences_util.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../report_management_utils/report_management_utils.dart';

class ProductDetailsCard extends StatelessWidget {
  String serialNo,
      status,
      productNo,
      remark,
      primaryDate,
      secondaryDate,
      tertiaryDate;
  bool showPrimaryDate, showSecondaryDate, showTertiaryDate;
  ProductDetailsCard(
      {super.key,
      required this.serialNo,
      required this.status,
      required this.productNo,
      required this.remark,
      this.primaryDate = "",
      this.secondaryDate = "",
      this.tertiaryDate = "",
      this.showPrimaryDate = true,
      this.showSecondaryDate = true,
      this.showTertiaryDate = true});

  Map<ProductStatus, IconData> statusIcons = {
    ProductStatus.accepted: Icons.check_circle_rounded,
    ProductStatus.rejected: Icons.cancel_rounded,
    ProductStatus.pending: Icons.info,
  };

  Color getStatusColor(ProductStatus status) {
    switch (status) {
      case ProductStatus.accepted:
        return AppColors.successGreen;
      case ProductStatus.rejected:
        return AppColors.errorRed;
      case ProductStatus.pending:
        return AppColors.pendingYellow;
      case ProductStatus.unknown:
        return AppColors.pendingYellow;
    }
  }

  String getStatusText(ProductStatus status) {
    switch (status) {
      case ProductStatus.accepted:
        return 'Accepted';
      case ProductStatus.rejected:
        return 'Rejected';
      case ProductStatus.pending:
        return 'Pending';
      case ProductStatus.unknown:
        return 'Unknown';
    }
  }

  ProductStatus returnEnum(String status) {
    if (status == 'Accepted')
      return ProductStatus.accepted;
    else if (status == 'Pending')
      return ProductStatus.pending;
    else if (status == 'Rejected')
      return ProductStatus.rejected;
    else
      return ProductStatus.unknown;
  }

  String getDateOfSale(String inputDate) {
    if(inputDate == 'N/A' || inputDate == null || inputDate == "")
    return 'N/A';
    else {
    DateTime dateTime = DateTime.parse(inputDate);

    String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
    return formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    ProductStatus statusOfSale = returnEnum(status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * w),
      margin: EdgeInsets.only(bottom: 16 * h),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.white_234),
          borderRadius: BorderRadius.circular(12 * r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                truncateText(productNo, 24),
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(
                    statusIcons[statusOfSale],
                    color: getStatusColor(statusOfSale),
                    size: 16 * w,
                  ),
                  HorizontalSpace(width: 6),
                  Text(
                    status,
                    style: GoogleFonts.poppins(
                      color: getStatusColor(statusOfSale),
                      fontSize: 12 * f,
                      fontWeight: FontWeight.w600,
                      height: 0.11,
                    ),
                  ),
                ],
              )
            ],
          ),
          VerticalSpace(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translation(context).serialNo,
                style: GoogleFonts.poppins(
                  color: AppColors.grayText,
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w500,
                  height: 0.11,
                  letterSpacing: 0.10,
                ),
              ),
              Text(
                serialNo,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w500,
                  height: 0.14,
                  letterSpacing: 0.10,
                ),
              )
            ],
          ),
          VerticalSpace(height: 24),
          Visibility(
            visible: remark!="" ? true : false,
            child: Text(
              translation(context).remark,
              style: GoogleFonts.poppins(
                color: AppColors.grayText,
                fontSize: 12 * f,
                fontWeight: FontWeight.w500,
                height: 0.11,
                letterSpacing: 0.10,
              ),
            ),
          ),
          Visibility(
            visible: remark!="" ? true : false,
            child: VerticalSpace(height: 16)),
          Visibility(
            visible: remark!="" ? true : false,
            child: Text(
              remark,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: 12 * f,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Visibility(
            visible: remark!="" ? true : false,
            child: VerticalSpace(height: 16)),
          DateTypesProductDetailWidget(
            showPrimaryDate: showPrimaryDate,
            showSecondaryDate: showSecondaryDate,
            showTertiaryDate: showTertiaryDate,
            primaryDate: getDateOfSale(primaryDate),
            secondaryDate: getDateOfSale(secondaryDate),
            tertiaryDate: getDateOfSale(tertiaryDate),
          ),
        ],
      ),
    );
  }
}
