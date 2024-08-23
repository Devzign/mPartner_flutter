import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/upi_beneficiary_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class TransferringTo_2 extends StatelessWidget {
  TransferringTo_2({required this.beneficiaryDetails, super.key});

  final UPIBeneficiaryModel beneficiaryDetails;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    var variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    var textMultiplier= DisplayMethods(context: context).getTextFontMultiplier();
    var pixelMultiplier=DisplayMethods(context: context).getPixelMultiplier();
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24 * variablePixelWidth,
          8 * variablePixelHeight,
          24 * variablePixelWidth,
          8 * variablePixelHeight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            translation(context).transferringTo,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreyText,
              fontSize: 14 * textMultiplier,
              height: 24 / 14,
            ),
          ),
          VerticalSpace(height: 4),
          Text(
            '${beneficiaryDetails.beneficiaryName} (${beneficiaryDetails.vpa})',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: AppColors.grayText,
              fontSize: 14 * textMultiplier,
              height: 24 / 14,
            ),
          ),
        ],
      ),
    );
  }
}
