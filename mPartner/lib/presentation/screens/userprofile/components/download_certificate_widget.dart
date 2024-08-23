import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class DownloadCertificateWidget extends StatelessWidget {
  final String url;
  final String certificate;
  final String issueDate;

  const DownloadCertificateWidget({
    Key? key,
    required this.url,
    required this.certificate,
    required this.issueDate,
  }) : super(key: key);


  void _openPdfUrl(String pdfUrl) async {
    if (await canLaunchUrlString(pdfUrl)) {
      await launchUrlString(pdfUrl);
    } else {
      throw 'Could not launch $pdfUrl';
    }
  }

  String formatDateString(String originalDate) {
    try {
      DateTime parsedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(originalDate);
      String formattedDate = DateFormat("MMM''yy").format(parsedDate);
      return formattedDate;
    } catch (e) {
      print("Error converting date format: $e");
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                certificate,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 16 * textFontMultiplier,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              onTap: () async {
                _openPdfUrl(url);
              },
              child: Text(
                translation(context).download,
                style: GoogleFonts.poppins(
                  color: AppColors.lumiBluePrimary,
                  fontSize: 14 * textFontMultiplier,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const VerticalSpace(height: 10),
        Text(
          issueDate.isNotEmpty && issueDate != null ? '${translation(context).issuedOn} ${formatDateString(issueDate)}' : '',
          style: GoogleFonts.poppins(
            color: AppColors.hintColor,
            fontSize: 12 * textFontMultiplier,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.10,
          ),
        ),
      ],
    );
  }
}
