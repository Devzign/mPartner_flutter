import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class IndividualProductChipWidget extends StatefulWidget {
  int productCount;
  String productName;
  final Function(String) onChipTapped;

  IndividualProductChipWidget(
      {Key? key, required this.productCount, required this.productName, required this.onChipTapped})
      : super(key: key);

  @override
  _IndividualProductChipWidgetState createState() =>
      _IndividualProductChipWidgetState();
}

class _IndividualProductChipWidgetState
    extends State<IndividualProductChipWidget> {
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
          isTapped = !isTapped;
          widget.onChipTapped(widget.productName);
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            //height: 60 * h,
            width: 107 * w,
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
                side: BorderSide(width: 1, color: AppColors.white_234),
                borderRadius: BorderRadius.circular(8 * r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.productCount.toString(),
                  style: GoogleFonts.poppins(
                    color:
                        isTapped ? AppColors.lumiBluePrimary : AppColors.darkGreyText,
                    fontSize: 16 * f,
                    fontWeight: isTapped ? FontWeight.w600 :FontWeight.w500,
                  ),
                ),
                Text(
                  widget.productName,
                  style: GoogleFonts.poppins(
                    color:
                        isTapped ? AppColors.lumiBluePrimary : AppColors.darkGreyText,
                    fontSize: 12 * f,
                    fontWeight: isTapped ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if(isTapped)
              Positioned(
                top: -5,
                right: -5,
                child: SvgPicture.asset("assets/mpartner/close.svg")
              ),
        ],
      ),
    );
  }
}
