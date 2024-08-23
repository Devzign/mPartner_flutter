import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import 'download_certificate_widget.dart';

class CertificateWidget extends StatefulWidget {
  final String authorisedCertificateUrl;
  final String authorisedCertificateIssueDate;
  final String certificateOfAppreciationUrl;
  final String certificateOfAppreciationIssueDate;

  const CertificateWidget({
    required this.authorisedCertificateUrl,
    required this.authorisedCertificateIssueDate,
    required this.certificateOfAppreciationUrl,
    required this.certificateOfAppreciationIssueDate,
    Key? key,
  }) : super(key: key);

  @override
  State<CertificateWidget> createState() => _CertificateWidgetState();
}

class _CertificateWidgetState extends State<CertificateWidget> {
  @override
  Widget build(BuildContext context) {

    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return widget.authorisedCertificateUrl.isNotEmpty || widget.certificateOfAppreciationUrl.isNotEmpty ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const VerticalSpace(height: 32),
        Text(
          translation(context).certificates,
          style: GoogleFonts.poppins(
            color: AppColors.darkGreyText,
            fontSize: 16 * textFontMultiplier,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.10,
          ),
        ),
        const VerticalSpace(height: 16),
        widget.authorisedCertificateUrl.isNotEmpty ?
        DownloadCertificateWidget(url: widget.authorisedCertificateUrl, certificate: translation(context).authorizedCertificate, issueDate: widget.authorisedCertificateIssueDate): const SizedBox(width: 0),
        widget.authorisedCertificateUrl.isNotEmpty && widget.certificateOfAppreciationUrl.isNotEmpty ? const VerticalSpace(height: 10) : const SizedBox(height: 0),
        widget.authorisedCertificateUrl.isNotEmpty && widget.certificateOfAppreciationUrl.isNotEmpty ? const CustomDivider(color: AppColors.dividerColor) : const SizedBox(height: 0),
        widget.certificateOfAppreciationUrl.isNotEmpty  && widget.certificateOfAppreciationUrl.isNotEmpty  ? const VerticalSpace(height: 10) : const SizedBox(height: 0),
        widget.certificateOfAppreciationUrl.isNotEmpty ?
        DownloadCertificateWidget(url: widget.certificateOfAppreciationUrl, certificate: translation(context).certificateOfAppreciation, issueDate: widget.certificateOfAppreciationIssueDate): const SizedBox(width: 0),
      ],
    ) : const SizedBox(height: 0);
  }
}
