import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';
import 'package:mpartner/utils/app_string.dart';
import 'package:mpartner/presentation/widgets/headers/back_button_header_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class ProductCardBanner extends StatelessWidget {
  ProductCardBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.pdfURI,
    required this.onShare,
    required this.onDownload,
  });
  final String title, subtitle, pdfURI;
  final VoidCallback onShare;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      width: 317 * w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 225 * w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkText2,
                        fontSize: 14 * f,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.10 * w,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 2 * h,
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 12 * f,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.10 * w,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          VerticalSpace(height: 24),
          Container(
            height: 40 * h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onShare,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.lumiBluePrimary, backgroundColor: AppColors.lightWhite1,
                      side: BorderSide(color: AppColors.lumiBluePrimary),
                    ),
                    child: Text(
                      'Share',
                      style: TextStyle(
                        color: AppColors.lumiBluePrimary,
                      ),
                    ),
                  ),
                ),
                HorizontalSpace(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onDownload,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.lightWhite1, backgroundColor: AppColors.lumiBluePrimary,
                    ),
                    child: Text(
                      'Download',
                      style: TextStyle(
                        color: AppColors.lightWhite1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryReportCardWidget extends StatelessWidget {
  const PrimaryReportCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.Uri,
    this.showCardHeading = false,
    this.pdfUri = "www.google.com",
  });
  final String title;
  final String subtitle;
  final String Uri;
  final String pdfUri;
  final bool showCardHeading;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: showCardHeading
              ? Container(
                  padding: EdgeInsets.only(bottom: 12 * h),
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkText2,
                      fontSize: 14 * f,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.10 * w,
                    ),
                  ),
                )
              : null,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16 * w, 16 * h, 12 * w, 16 * h),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: AppColors.white_234),
                    borderRadius: BorderRadius.circular(12 * r)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ProductCardBanner(
                  title: title,
                  subtitle: subtitle,
                  pdfURI: pdfUri,
                  onShare: () {
                    // Implement your share logic here
                    Share.share(pdfUri);
                  },
                  onDownload: () {
                    // Implement your download logic here
                    _openPdfUrl(pdfUri);
                  },
                ),
              ]),
            ),
          ],
        ),
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
