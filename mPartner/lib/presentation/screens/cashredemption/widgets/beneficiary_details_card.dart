import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/upi_beneficiary_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class BeneficiaryDetailsCard extends StatelessWidget {
  const BeneficiaryDetailsCard({required this.beneficiaryDetails, super.key});
  final UPIBeneficiaryModel beneficiaryDetails;

  String getLineByIndex(String input, int lineIndex) {
    print('in ');
  List<String> detailsList = input.split(',');

  if (detailsList.length >= 2) {
    switch (lineIndex) {
      case 1:
        return detailsList.sublist(0, detailsList.length ~/ 2).join(',');
      case 2:
        return detailsList.sublist(detailsList.length ~/ 2).join(',');
      default:
        return "";
    }
  }
  else {
    return input;
  }
}

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
   
    return Padding(
      padding: EdgeInsets.only(
        left: 20 * variablePixelWidth,
        right: 20 * variablePixelWidth,
        top: 8 * variablePixelHeight,
      ),
      child: Card(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0 * pixelMultiplier),
        ),
        color: AppColors.grey97,
        child: Padding(
          padding: EdgeInsets.all(12.0 * pixelMultiplier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translation(context).beneficiaryName,
                    style: GoogleFonts.poppins(
                      fontSize: 16 * textMultiplier,
                      height: 24 / 16,
                      color: AppColors.grayText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    beneficiaryDetails.beneficiaryName, 
                    style: GoogleFonts.poppins(
                      fontSize: 16 * textMultiplier,
                      height: 24 / 16,
                      color: AppColors.darkGreyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const VerticalSpace(height: 4),
              Divider(
                thickness: 1 * pixelMultiplier,
                color: AppColors.whisperGrey,
              ),
              const VerticalSpace(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translation(context).upiId,
                    style: GoogleFonts.poppins(
                      fontSize: 16 * textMultiplier,
                      height: 24 / 16,
                      color: AppColors.grayText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    beneficiaryDetails.vpa,
                    style: GoogleFonts.poppins(
                      fontSize: 16 * textMultiplier,
                      height: 24 / 16,
                      color: AppColors.darkGreyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const VerticalSpace(height: 4),
              Divider(
                thickness: 1 * pixelMultiplier,
                color: AppColors.whisperGrey,
              ),
              const VerticalSpace(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translation(context).ifscCode,
                    style: GoogleFonts.poppins(
                      fontSize: 16 * textMultiplier,
                      height: 24 / 16,
                      color: AppColors.grayText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    beneficiaryDetails.ifsc,
                    style: GoogleFonts.poppins(
                      fontSize: 16 * textMultiplier,
                      height: 24 / 16,
                      color: AppColors.darkGreyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const VerticalSpace(height: 4),
              Divider(
                thickness: 1 * pixelMultiplier,
                color: AppColors.whisperGrey,
              ),
              const VerticalSpace(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getLineByIndex(beneficiaryDetails.bankDetails, 1),
                    style: GoogleFonts.poppins(
                      fontSize: 16 * textMultiplier,
                      height: 24 / 16,
                      color: AppColors.grayText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    getLineByIndex(beneficiaryDetails.bankDetails, 2),
                    style: GoogleFonts.poppins(
                      fontSize: 16 * textMultiplier,
                      height: 24 / 16,
                      color: AppColors.darkGreyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
