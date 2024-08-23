import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';

import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../coin_with_image_widget.dart';
import '../dot_horizontal_divider.dart';

class MasterCard extends StatelessWidget {
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
  const MasterCard({super.key, required this.screenTitle, required this.userType,required this.state, required this.body, required this.stateMsg, required this.data1, required this.data2, required this.data3, required this.data4, required this.data5});

  String getImagePath(String status) {
    switch (status) {
      case 'Success':
        return "assets/mpartner/success.svg";
      case 'Failure':
        return "assets/mpartner/rejected.svg";
      case 'Pending':
        return "assets/mpartner/pending.svg";
      default:
        return "assets/mpartner/ic_icon_placeholder.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();

    return Stack(

        children: [

          Container(
            decoration: BoxDecoration(
              color: AppColors.lightWhite1,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: AppColors.lightGrey1,  // Adjust the color as needed
                width: 1.0,  // Adjust the width as needed
              ),
            ),
            margin: EdgeInsets.all(16*variablePixelWidth),
            child: Padding(
              padding: EdgeInsets.all(16*variablePixelWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon and Text
                  Column(
                    children: [
                      SvgPicture.asset(getImagePath(state)),
                      SizedBox(height: variablePixelHeight*12),
                      Text(stateMsg, style: GoogleFonts.poppins(
                        color: AppColors.blackStatus,
                        fontSize: variablePixelHeight*24,
                        fontWeight: FontWeight.w600,
                      )),
                      SizedBox(height: variablePixelHeight*16),
                      Text(data1, style: GoogleFonts.poppins(
                        color: AppColors.lumiDarkBlack,
                        fontSize: variablePixelHeight*14,
                        fontWeight: FontWeight.w400,
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: variablePixelHeight*16),
                  userType == 'Dealer' ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: variablePixelWidth*123,
                        height: variablePixelHeight*76,
                        decoration: BoxDecoration(
                          color: AppColors.goldCoinLight,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CoinWithImageWidget(
                                      coin: double.tryParse(
                                          data2.replaceAll(",", "")) ??
                                          0,
                                      color: AppColors.pendingYellow,
                                      size: 12,
                                      weight: FontWeight.w600,
                                      width: 120),

                                  // SvgPicture.asset('assets/mpartner/ic_coins.svg'),
                                  // Text(
                                  //   data2,
                                  //   textAlign: TextAlign.right,
                                  //   style: GoogleFonts.poppins(
                                  //     color: AppColors.pendingYellow,
                                  //     fontSize: 12*variablePixelWidth,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // )
                                ],
                              ),
                              SizedBox(height: 8*variablePixelHeight),
                              Text(
                                data3,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.pendingYellow,
                                  fontSize: 14*variablePixelWidth,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12*variablePixelWidth,),
                      Container(
                        width: variablePixelWidth*123,
                        height: variablePixelHeight*76,
                        decoration: BoxDecoration(
                          color: AppColors.lumiLight4,
                          borderRadius: BorderRadius.circular(10.0),
                          // border: Border.all(
                          //   color: Colors.black,  // Adjust the color as needed
                          //   width: 1.0,  // Adjust the width as needed
                          // ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data4,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.lumiBluePrimary,
                                  fontSize: 28*variablePixelWidth,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8*variablePixelHeight),
                              Text(
                                data5,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.lumiBluePrimary,
                                  fontSize: 14*variablePixelWidth,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ) : Container(
                    width: variablePixelWidth*123,
                    height: variablePixelHeight*76,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.lumiLight4,
                      borderRadius: BorderRadius.circular(10.0),
                      // border: Border.all(
                      //   color: Colors.black,  // Adjust the color as needed
                      //   width: 1.0,  // Adjust the width as needed
                      // ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.lumiBluePrimary,
                              fontSize: 28*variablePixelWidth,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8*variablePixelHeight),
                          Text(
                            data3,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.lumiBluePrimary,
                              fontSize: 14*variablePixelWidth,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: variablePixelHeight*16),
                  Text(
                    '${translation(context).remark}: ${translation(context).productNotBilledMessage}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 12*variablePixelWidth,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.10,
                    ),
                  ),
                  SizedBox(height: variablePixelHeight*16),
                  Container(
                    width: variablePixelWidth*157,
                    height: variablePixelHeight*24,
                    decoration: BoxDecoration(
                      color: AppColors.lumiLight4,
                      borderRadius: BorderRadius.circular(10.0),
                      // border: Border.all(
                      //   color: Colors.black,  // Adjust the color as needed
                      //   width: 1.0,  // Adjust the width as needed
                      // ),
                    ),
                    child: Center(
                      child: Text(
                        translation(context).purchaseVerifiedwithOtp,
                        style: GoogleFonts.poppins(
                          color: AppColors.lumiBluePrimary,
                          fontSize: 10*variablePixelWidth,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: variablePixelHeight*35,),
                  const DotHorizontalDivider(color: Colors.grey),
                  SizedBox(height: variablePixelHeight*35,),
                  body,
                ],
              ),
            ),
          ),

        ]
    );

  }
}