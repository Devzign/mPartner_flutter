import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../state/contoller/customer_wise_list_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../report_management_utils/report_management_utils.dart';
import '../widgets/user_summary_card.dart';
import 'customer_summary_card.dart';

class CustomerWiseSummaryWidget extends StatelessWidget {
  String usertype, productTypesString;
  CustomerWiseSummaryWidget({super.key, required this.usertype, required this.productTypesString});

  @override
  Widget build(BuildContext context) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    CustomerWiseListController customerWiseListController =
        Get.find();

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
            VerticalSpace(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
                itemCount: customerWiseListController
                    .customerWiseList.length,
                itemBuilder: (context, index) {
                  return CustomerSummaryCardWidget(
                    name: customerWiseListController
                        .customerWiseList[index].customerName,
                    id: customerWiseListController
                        .customerWiseList[index].customerPhone,
                    address: customerWiseListController
                        .customerWiseList[index].customerAddress,
                    totalProducts: customerWiseListController
                        .customerWiseList[index].totalProducts.toString(),
                    productsList: customerWiseListController
                        .customerWiseList[index].products,
                    productTypesString : productTypesString,
                    index: index,
                  );
                }),
          ],
        );
      }
    );
  }
}
