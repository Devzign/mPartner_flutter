import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/get_customer_list_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

class CustomerCheckBoxWidget extends StatefulWidget {
  final Customer customer;
  final bool isSelected;
  final Function(bool, String) onCheckBoxChanged;

  const CustomerCheckBoxWidget(
      {super.key,
      required this.customer,
      required this.isSelected,
      required this.onCheckBoxChanged});

  @override
  State<CustomerCheckBoxWidget> createState() => _CustomerCheckBoxWidgetState();
}

class _CustomerCheckBoxWidgetState extends State<CustomerCheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onCheckBoxChanged(
              !widget.isSelected, widget.customer.customer_Phone);
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
                value: widget.isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    widget.onCheckBoxChanged(
                        value!, widget.customer.customer_Phone);
                  });
                },
                checkColor: AppColors.lightWhite1,
                activeColor: AppColors.lumiBluePrimary,
              ),
            ),
            const HorizontalSpace(width: 4),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.customer.customer_Name.isEmpty
                      ? "+91 ${widget.customer.customer_Phone}"
                      : "${widget.customer.customer_Name}, +91 ${widget.customer.customer_Phone}",
                  style: GoogleFonts.poppins(
                    color: AppColors.darkText2,
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: true,
                ),
                const VerticalSpace(height: 8),
                Text(
                  widget.customer.customer_Address.isEmpty
                      ? "India"
                      : "${widget.customer.customer_Address}, India",
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
