import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../presentation/widgets/rupee_with_sign_widget.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../solar_finance_utils.dart';

class ProjectCard extends StatelessWidget {
  String uniqueId, name, projectCost, financePartner, status, capacity;
  ProjectCard(
      {super.key,
      required this.uniqueId,
      required this.name,
      required this.projectCost,
      required this.financePartner,
      required this.status,
      required this.capacity});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16 * w, vertical: 8 * h),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.white_234),
          borderRadius: BorderRadius.circular(12 * r),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              uniqueId,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f, fontWeight: FontWeight.w600),
            ),
                        Row(
                children: [
                  Icon(
                    statusIcons[status.toLowerCase()],
                    color: getStatusColor(status.toLowerCase()),
                    size: 16 * w,
                  ),
                  HorizontalSpace(width: 6),
                  Text(
                    getStatusString(status.toLowerCase(), context),
                    style: GoogleFonts.poppins(
                      color: getStatusColor(status.toLowerCase()),
                      fontSize: 12 * f,
                      fontWeight: FontWeight.w600,
                      height: 0.11,
                    ),
                  ),
                ],
              )
          ],
        ),
        VerticalSpace(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 146 * w,
              child: Text(
                translation(context).contactPersonName,
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grayText),
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),
            Container(
              width: 165 * w,
              child: Text(
                name,
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black),
                overflow: TextOverflow.ellipsis,
                maxLines: 1, 
              ),
            )
          ],
        ),
        VerticalSpace(height: 4),
                Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 146 * w,
              child: Text(
                translation(context).projectCapacity,
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grayText),
              ),
            ),
            Text(
              capacity,
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black),
            )
          ],
        ),
        VerticalSpace(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 146 * w,
              child: Text(
                translation(context).projectCost,
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grayText),
              ),
            ),
            RupeeWithSignWidget(cash: double.parse(projectCost), color: AppColors.black, size: 12, weight: FontWeight.w500, width: 100)
          ],
        ),
        VerticalSpace(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 146 * w,
              child: Text(
                translation(context).approvedBank,
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grayText),
              ),
            ),
            Text(
              financePartner.isNotEmpty ? financePartner : "-",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black),
            )
          ],
        ),
      ]),
    );
  }
}
