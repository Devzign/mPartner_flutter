import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';
import 'package:mpartner/presentation/widgets/verticalspace/vertical_space.dart';

class ServiceEscalationCard extends StatefulWidget {
  String imagePath;
  String text;
  ServiceEscalationCard(
      {super.key, required this.imagePath, required this.text});

  @override
  State<ServiceEscalationCard> createState() => _ServiceEscalationCardState();
}

class _ServiceEscalationCardState extends State<ServiceEscalationCard> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      width: 160 * variablePixelWidth,
      height: 121 * variablePixelHeight,
      padding: EdgeInsets.all(14),
      decoration: ShapeDecoration(
        color: AppColors.lightWhite1,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0, color: AppColors.white_234),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(widget.imagePath),
            VerticalSpace(height: 9),
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.blackText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
    );
  }
}
