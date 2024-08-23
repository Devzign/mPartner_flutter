import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/get_dealer_list_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../report_management_utils/report_management_utils.dart';

class UserCheckBoxWidget extends StatefulWidget {
  final Dealer dealer;
  final bool isSelected;
  final Function(bool, String) onCheckBoxChanged;
  const UserCheckBoxWidget({super.key, required this.dealer, required this.isSelected, required this.onCheckBoxChanged});

  @override
  State<UserCheckBoxWidget> createState() => _UserCheckBoxWidgetState();
}
class _UserCheckBoxWidgetState extends State<UserCheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      onTap: () {
        setState(() {
            widget.onCheckBoxChanged(!widget.isSelected,widget.dealer.dlr_Sap_Code);
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 24 * h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24 * h,
              width: 24 * w,
              child: Checkbox(
                value:  widget.isSelected,
                onChanged: (bool? value) {
                  setState(() {
                      widget.onCheckBoxChanged(value!,widget.dealer.dlr_Sap_Code);
                  });
                },
                checkColor: AppColors.lightWhite1,
                activeColor: AppColors.lumiBluePrimary,
              ),
            ),
            HorizontalSpace(width: 4),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  truncateText("${widget.dealer.dealerName}, ${widget.dealer.dlr_Sap_Code}", 35),
                  style: GoogleFonts.poppins(
                    color: AppColors.darkText2,
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: true,
                ),
                VerticalSpace(height: 8),
                Text(
                  "${widget.dealer.city}, India",
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

