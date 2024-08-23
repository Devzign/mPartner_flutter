import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';

import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/utils.dart';
import '../../../data/models/maf_listing_home_model.dart';

class MafHomePageListingItemWidget extends StatelessWidget {
  MafListingHomePageModel? authenticationlist;
  Function(String, String) onTap;
  MafHomePageListingItemWidget(this.authenticationlist, {required this.onTap});
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler = DisplayMethods(context: context).getPixelMultiplier();

    String? statusTitle = "";
    if(authenticationlist?.sStatus.toString() == "Approved"){
      statusTitle = "MAF Issued";
    }else{
      statusTitle = authenticationlist?.sStatus.toString();
    }

    double textMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    return InkWell(
      child:  Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: 10 * variablePixelWidth,
            vertical: 10 * variablePixelHeight),
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1 * variablePixelWidth, color: AppColors.white_234),
            borderRadius: BorderRadius.circular(12 * pixelMultipler),
          ),
        ),
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        child:  Column(
          children: [
             Container(
              child:  Row(
                children: [
                  Expanded(
                      child: Container(
                        child: Text(translation(context).bidNumber + ' - ${authenticationlist!.sBidNumber}',
                            style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 14 * textMultiplier,
                              fontWeight: FontWeight.w600,
                            )),
                      )),


                  Container(
                    child: Row(
                      children: [
                        if (authenticationlist!.sStatus.toString() == "Rejected")
                          SvgPicture.asset(
                            "assets/mpartner/cancel.svg",
                            height: 20,
                          ),
                        if (authenticationlist!.sStatus.toString() == "In Progress")
                          SvgPicture.asset(
                            "assets/mpartner/inprogress.svg",
                            height: 20,
                          ),
                        if (authenticationlist!.sStatus.toString() == "Approved")
                          SvgPicture.asset(
                            "assets/mpartner/check_circle.svg",
                            height: 20,
                          ),
                        new SizedBox(
                          width: 10,
                        ),
                        Text(
                            statusTitle!,
                            style: GoogleFonts.poppins(
                              color: authenticationlist!.sStatus.toString() ==
                                  "In Progress"
                                  ?AppColors.pendingYellow
                                  : authenticationlist!.sStatus.toString() ==
                                  "Approved"
                                  ? AppColors.green
                                  : authenticationlist!.sStatus.toString() ==
                                  "Rejected"
                                  ? AppColors.red
                                  : AppColors.black,
                              fontSize: 12 * textMultiplier,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(translation(context).bidPubDate,
                      style: GoogleFonts.poppins(
                        color: AppColors.grayText,
                        fontSize: 12 * textMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(Utils().getFormattedDateMonth(authenticationlist!.dBidPublishDate.toString()),
                      style: GoogleFonts.poppins(
                        color: AppColors.darkText2,
                        fontSize: 12 * textMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
              margin: EdgeInsets.only(top: 10),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(translation(context).bidDueDate,
                      style: GoogleFonts.poppins(
                        color: AppColors.grayText,
                        fontSize: 12 * textMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(Utils().getFormattedDateMonth(authenticationlist!.dBidDueDate.toString()),
                      style: GoogleFonts.poppins(
                        color: AppColors.darkText2,
                        fontSize: 12 * textMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
              margin: EdgeInsets.only(top: 10),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(translation(context).bidstatus,
                      style: GoogleFonts.poppins(
                        color: AppColors.grayText,
                        fontSize: 12 * textMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(authenticationlist!.sBidStatus.toString(),
                      style: GoogleFonts.poppins(
                        color: AppColors.darkText2,
                        fontSize: 12 * textMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
              margin: EdgeInsets.only(top: 10),
            ),
          ],
        ),
      ),
      onTap: () {
       onTap(authenticationlist!.sBidNumber!,
           authenticationlist!.sBidNumber.toString());
      },
    );
  }
}
