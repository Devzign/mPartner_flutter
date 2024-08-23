import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';

class DetailedReportSectionWidget extends StatelessWidget {
  String detailedReportText;
  String pdfUrl;
  DetailedReportSectionWidget(
      {super.key, required this.detailedReportText, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    bool isPdfUrlEmpty = pdfUrl.isEmpty;
    Color iconColor = isPdfUrlEmpty ? Colors.grey : AppColors.darkGrey;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            if (detailedReportText.isEmpty) {
              return Container(
                height: 28 * w,
                padding: EdgeInsets.symmetric(vertical: 4 * w),
                child: Center(
                  child: Text(
                    translation(context).detailedReport,
                    style: GoogleFonts.poppins(
                    color: AppColors.lumiDarkBlack,
                    fontSize: 16 * f,
                    fontWeight: FontWeight.w600,
                  ),
                  )
                )
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translation(context).detailedReport,
                  style: GoogleFonts.poppins(
                    color: AppColors.lumiDarkBlack,
                    fontSize: 16 * f,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  detailedReportText,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGrey,
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            );
          }
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                print("URLLLL ${pdfUrl}");
                if (pdfUrl != "") {
                  Share.shareUri(Uri.parse(pdfUrl));
                }
              },
              child: Container(
                  width: 28 * w,
                  height: 28 * w,
                  padding: EdgeInsets.all(4 * w),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: AppColors.white_234),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.share_outlined,
                    size: 20 * r,
                    color: iconColor,
                  ))),
            ),
            HorizontalSpace(width: 12),
            GestureDetector(
              onTap: () async {
                _openPdfUrl(pdfUrl);
              },
              child: Container(
                  width: 28 * w,
                  height: 28 * w,
                  padding: EdgeInsets.all(4 * w),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: AppColors.white_234),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.download_outlined,
                    size: 20 * r,
                    color: iconColor,
                  ))),
            ),
          ],
        )
      ],
    );
  }
}

void _openPdfUrl(String pdfUrl) async {
  if (await canLaunchUrlString(pdfUrl)) {
    await launchUrlString(pdfUrl);
  } else {
    throw 'Could not launch $pdfUrl';
  }
}
