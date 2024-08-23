import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../screens/userprofile/user_profile_widget.dart';
import '../common_button.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../screens/help_and_support/help_and_support.dart';
import '../horizontalspace/horizontal_space.dart';
import 'master_card.dart';

class RegisterSalesDetailedHistory extends StatelessWidget {
  final String screenTitle;
  final String userType;
  final String state;
  final String stateMsg;
  final String data1;
  final String data2;
  final String data3;
  final String data4;
  final String data5;
  final Widget body;
  final VoidCallback? onPressed;

  const RegisterSalesDetailedHistory(
      {super.key,
      required this.screenTitle,
      required this.userType,
      required this.state,
      required this.body,
      required this.stateMsg,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.data4,
      required this.data5,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 24 * variablePixelWidth,
                  right: 24 * variablePixelWidth,
                  top: 54 * variablePixelHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: screenTitle == 'Tertiary sale registration'
                              ? SvgPicture.asset(
                                  "assets/mpartner/ic_close.svg",
                                )
                              :  Icon(
                                  Icons.arrow_back_outlined,
                                  color: AppColors.iconColor,
                                  size: 24 * pixelMultiplier,
                                ),
                        ),
                        SizedBox(
                          width: 10 * variablePixelWidth,
                        ),
                        Text(
                          screenTitle,
                          style: GoogleFonts.poppins(
                            color: AppColors.iconColor,
                            fontSize: 22 * textFontMultiplier,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            UserProfileWidget(),
            MasterCard(
              screenTitle: screenTitle,
              userType: userType,
              state: state,
              body: body,
              stateMsg: stateMsg,
              data1: data1,
              data2: data2,
              data3: data3,
              data4: data4,
              data5: data5,
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpAndSupport()),
                );
              },
              child: Container(
                  width: 157 * variablePixelWidth,
                  height: 40 * variablePixelHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 20 * pixelMultiplier,
                        color: AppColors.lumiBluePrimary,
                      ),
                      const HorizontalSpace(width: 4),
                      Text(
                        translation(context).helpAndSupport,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.lumiBluePrimary,
                          fontSize:  textFontMultiplier * 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 7 * variablePixelHeight,
            ),
            screenTitle == 'Tertiary sale registration'
                ? CommonButton(
                    onPressed: onPressed,
                    isEnabled: (state=="Accepted")?true:false,
                    buttonText: translation(context).downloadWarrantyCard)
                : Container(),
          ],
        ),
      ),
    );
  }
}
