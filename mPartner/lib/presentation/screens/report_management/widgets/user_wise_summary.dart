import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../state/contoller/dealer_wise_summary_controller.dart';
import '../../../../state/contoller/secondary_report_distributor_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../report_management_utils/report_management_utils.dart';
import '../widgets/user_summary_card.dart';
import 'customer_summary_card.dart';

class UserWiseSummaryWidget extends StatelessWidget {
  String usertype, productTypesString;
  UserWiseSummaryWidget({super.key, required this.usertype, required this.productTypesString});

  @override
  Widget build(BuildContext context) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    DealerSummaryController dealerSummaryController =
        Get.find();

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
            itemCount: dealerSummaryController
                .dealerSummaryList.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> productsList = fetchProductsList(dealerSummaryController, index);
              return UserSummaryCardWidget(
                name: dealerSummaryController
                    .dealerSummaryList[index]['dlr_Name'],
                id: dealerSummaryController
                    .dealerSummaryList[index]['dlr_Sap_Code'],
                address: dealerSummaryController
                    .dealerSummaryList[index]['dlr_City'],
                totalProducts: dealerSummaryController
                    .dealerSummaryList[index]['totalProduct'].toString(),
                productsList: productsList,
                productTypesString : productTypesString,
                index: index,
              );
            }),
      ],
    );
  }
}
