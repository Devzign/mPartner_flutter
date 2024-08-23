import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/routes/app_routes.dart';


class HeadingDealer extends StatefulWidget {
  final String heading;
 final dynamic controller;
 final  Function()? callBackBtnClick;

  const HeadingDealer({required this.heading, super.key, this.controller, this.callBackBtnClick});

  @override
  State<HeadingDealer> createState() => _HeadingDealerState();
}

class _HeadingDealerState extends State<HeadingDealer> {
  @override
  Widget build(BuildContext context) {
    final variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    final variableTextMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (widget.callBackBtnClick!=null)?widget.callBackBtnClick:(){
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.of(context).pushReplacementNamed(AppRoutes.viewDetails);
            }
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: AppColors.iconColor,
            size: 24 * variablePixelMultiplier,
          ),
        ),
        SizedBox(width: 10*variablePixelMultiplier,),
        Expanded(
          child: Text(
            widget.heading,
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
            softWrap: true,
            style: GoogleFonts.poppins(
              color: AppColors.iconColor,
              fontSize: 22 * variableTextMultiplier,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
