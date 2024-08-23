import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class ProductChipMediumWidget extends StatefulWidget {
  String productName;
  String productCount;
  void Function(String) onProductTapped;
  ProductChipMediumWidget(
      {super.key, required this.productName, required this.productCount, required this.onProductTapped,});

  @override
  State<ProductChipMediumWidget> createState() =>
      _ProductChipMediumWidgetState();
}

class _ProductChipMediumWidgetState extends State<ProductChipMediumWidget> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    
    return GestureDetector(
      onTap: () {
        setState(() {
          print("WIDGET TAPPED --> ${widget.productName}");
          isTapped = !isTapped;
          // if (isTapped) {
            widget.onProductTapped(widget.productName);
          //}
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
        Container(
          height: 36 * h,
          padding: EdgeInsets.only(left: 12 * w, right: 12 * w, top: 16 * h),
          decoration: ShapeDecoration(
            color: AppColors.lightWhite1,
            shadows: isTapped ? [
                BoxShadow(
                    color: AppColors.lightGrey,
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    spreadRadius: 3,
                  ),
              ] : [],
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.lightGrey2),
              borderRadius: BorderRadius.circular(4 * r),
            ),
          ),
          child: Text(
            "${widget.productName} (${widget.productCount})",
            style: GoogleFonts.poppins(
              color: isTapped
                  ? AppColors.lumiBluePrimary
                  : AppColors.darkGreyText,
              fontSize: 12 * f,
              fontWeight: isTapped ? FontWeight.w500 : FontWeight.w400,
              height: 0.16,
              letterSpacing: 0.10,
            ),
          ),
        ),
        if (isTapped)
          Positioned(
              top: -7,
              right: -5,
              child: SvgPicture.asset("assets/mpartner/close.svg")),
      ]),
    );
  }
}
