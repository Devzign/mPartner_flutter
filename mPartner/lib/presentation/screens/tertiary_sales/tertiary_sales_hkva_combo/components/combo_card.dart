import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'combo_heading_and_card.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../widgets/status.dart';

class ComboCard extends StatelessWidget {
  String serialNumber, productName, remark, status;
  UserDataController controller = Get.find();
  int coins, cashback;
  bool showCoinsAndCash;
  ComboCard({
    super.key,
    required this.serialNumber,
    required this.productName,
    required this.remark,
    required this.status,
    required this.coins,
    required this.cashback,
    required this.showCoinsAndCash,
  });

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    var style1 = GoogleFonts.poppins(
      color: AppColors.grayText,
      fontSize: 12 * f,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10 * w,
    );
    var style2 = GoogleFonts.poppins(
      color: AppColors.darkGrey,
      fontSize: 12 * f,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10 * w,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineOneComboCard(
          text: serialNumber,
          coins: coins,
          cashback: cashback,
          showCoins: controller.userType == "DEALER" ? true : false,
          showCoinsAndCash: showCoinsAndCash
        ),
        VerticalSpace(height: 12),
        RowWithTwoElements(
          widget1: Text(
            translation(context).modelName,
            style: style1,
          ),
          widget2: Text(
            (productName=='')?'-':productName,
            style: style2,
          ),
        ),
        VerticalSpace(height: 4),
        RowWithTwoElements(
            widget1: Text(
              translation(context).status,
              style: style1,
            ),
            widget2: Status(
              status: status.toLowerCase(),
            )),
        VerticalSpace(height: 4),
        Visibility(
          visible: remark.isNotEmpty,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translation(context).remark,
                style: style1,
              ),
              remark.isNotEmpty
                  ? Text(
                      remark,
                      style: style2,
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }
}
