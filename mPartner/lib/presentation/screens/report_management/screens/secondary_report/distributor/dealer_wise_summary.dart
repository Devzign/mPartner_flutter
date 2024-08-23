import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../state/contoller/secondary_report_distributor_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../widgets/verticalspace/vertical_space.dart';
import '../../../widgets/customer_summary_card.dart';

class DealerWiseSummaryWidget extends StatelessWidget {
  String usertype, productTypesString;

  DealerWiseSummaryWidget(
      {super.key, required this.usertype, required this.productTypesString});

  @override
  Widget build(BuildContext context) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    SecondaryReportDistrubutorController dealerWiseListController = Get.find();

    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${usertype} wise summary",
            style: GoogleFonts.poppins(
              color: AppColors.blackText,
              fontSize: 16 * f,
              fontWeight: FontWeight.w600,
            ),
          ),
          VerticalSpace(height: 12 * h),
          (dealerWiseListController.customerWiseList.isEmpty)
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 100 * h, bottom: 50 * h),
                  child: Text(
                    "No data found",
                    style: GoogleFonts.poppins(
                      color: AppColors.blackText,
                      fontSize: 16 * f,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dealerWiseListController.customerWiseList.length,
                  itemBuilder: (context, index) {
                    return CustomerSummaryCardWidget(
                        name: dealerWiseListController
                            .customerWiseList[index].customerName,
                        id: dealerWiseListController
                            .customerWiseList[index].dealerCode,
                        address: dealerWiseListController
                            .customerWiseList[index].customerAddress,
                        totalProducts: dealerWiseListController
                            .customerWiseList[index].totalProducts
                            .toString(),
                        productsList: dealerWiseListController
                            .customerWiseList[index].products,
                        productTypesString: productTypesString,
                        index: index,
                        type: "secondary");
                  }),
        ],
      );
    });
  }
}
