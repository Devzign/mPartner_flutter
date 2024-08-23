import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/utils.dart';
import '../../../data/models/gem_auth_list.dart';

class Build_AuthListItem extends StatelessWidget {
  GemAuthList? authenticationlist;
  Function(int, String) onTap;
  Build_AuthListItem(this.authenticationlist, {required this.onTap});
  @override
  Widget build(BuildContext context) {
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    var ecolor = AppColors.grayText;
    var expiredColor = AppColors.grayText;
   // authenticationlist!.validity = "Expired";
    if (authenticationlist!.validity.toString() == "Expired") {
      ecolor = AppColors.red;
      expiredColor = AppColors.grayText;
    } else {
      ecolor = AppColors.black;
      expiredColor = AppColors.black;
    }
    return InkWell(
      child: Container(
        margin: EdgeInsets.fromLTRB(
            24.0 * variablePixelWidth,
            10 * variablePixelHeight,
            24.0 * variablePixelWidth,
            10 * variablePixelHeight),
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(15),
            border: new Border.all(width: 1, color: AppColors.white_234)),
        child: Column(
          children: [
            new Container(
              child: new Row(
                children: [
                  Expanded(
                      child: Container(
                    child: new Text(
                        authenticationlist!.authorizationCode.toString(),
                        style: GoogleFonts.poppins(
                          color: expiredColor,
                          fontSize: 14 * textMultiplier,
                          fontWeight: FontWeight.w600,
                        )),
                  )),
                  if (authenticationlist!.authorizationCode.toString() !=
                          "null" &&
                      authenticationlist!.authorizationCode.toString() != "" &&
                      authenticationlist!.authorizationCode.toString() !=
                          "Code not created" &&
                      authenticationlist!.validity.toString() != "Expired")
                    InkWell(
                      child: new Container(
                        height: 30,
                        width: 30,
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(100),
                            border: new Border.all(
                                width: 1, color: AppColors.grey)),
                        child: new Icon(
                          Icons.copy,
                          color: AppColors.grey,
                          size: 15,
                        ),
                      ),
                      onTap: () {
                        Utils().copyText(
                            authenticationlist!.authorizationCode.toString(),
                            context);
                      },
                    ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(translation(context).validity,
                      style: GoogleFonts.poppins(
                        color: AppColors.grayText,
                        fontSize: 12 * textMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(
                      Utils().getFormattedDateMonth(
                          authenticationlist!.validity.toString()),
                      style: GoogleFonts.poppins(
                        color: ecolor,
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
                  Text(translation(context).mobileNumber,
                      style: GoogleFonts.poppins(
                        color: AppColors.grayText,
                        fontSize: 12 * textMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(authenticationlist!.mobile_Number.toString(),
                      style: GoogleFonts.poppins(
                        color: expiredColor,
                        fontSize: 12 * textMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
              margin: EdgeInsets.only(top: 10),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                      child: new Container(
                    child: Text(translation(context).authorizationcodestatus,
                        style: GoogleFonts.poppins(
                          color: AppColors.grayText,
                          fontSize: 12 * textMultiplier,
                          fontWeight: FontWeight.w600,
                        )),
                  )),
                  if (authenticationlist!.status.toString() == "Rejected")
                    SvgPicture.asset(
                      "assets/mpartner/cancel.svg",
                      height: 20,
                    ),
                  if (authenticationlist!.status.toString() == "In Progress")
                    SvgPicture.asset(
                      "assets/mpartner/pending.svg",
                      height: 20,
                    ),
                  if (authenticationlist!.status.toString() == "Received" &&
                      authenticationlist!.validity.toString() != "Expired")
                    SvgPicture.asset(
                      "assets/mpartner/check_circle.svg",
                      height: 20,
                    ),
                  new SizedBox(
                    width: 10,
                  ),
                  Text(authenticationlist!.status.toString(),
                      style: GoogleFonts.poppins(
                        color: authenticationlist!.status.toString() ==
                                "In Progress"
                            ? AppColors.pendingYellow
                            : authenticationlist!.status.toString() ==
                                    "Received"
                                ? authenticationlist!.validity.toString() ==
                                        "Expired"
                                    ? AppColors.grey
                                    : AppColors.green
                                : authenticationlist!.status.toString() ==
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
      onTap: () {
        onTap(authenticationlist!.id!,
            authenticationlist!.authorizationCode.toString());
      },
    );
  }
}
