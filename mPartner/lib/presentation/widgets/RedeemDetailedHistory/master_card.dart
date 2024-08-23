import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';

import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../coin_with_image_widget.dart';
import '../dot_horizontal_divider.dart';
import '../rupee_with_sign_widget.dart';

class MasterCard extends StatelessWidget {
  final String state;
  final String stateMsg;
  final String cashOrCoinHistory;
  final String data1;
  final String data2;
  final String data3;
  final String data4;
  final String data5;
  final String transactionType;
  const MasterCard(
      {super.key,
      required this.state,
      required this.stateMsg,
      required this.cashOrCoinHistory,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.transactionType,
      required this.data4,
      required this.data5});

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

  String getImgBanner(String moduleName) {
    switch (moduleName) {
      case 'Paytm':
        return "assets/mpartner/ic_paytm.png";
      case 'UPI':
        return "assets/mpartner/ic_upi.png";
      case 'PineLab':
        return "assets/mpartner/ic_pinelab.png";
      case 'Cashback':
        return "assets/mpartner/ic_cashback.png";
      case 'Trips':
        return "assets/mpartner/ic_trips_small.png";
      case 'Gifts':
        return "assets/mpartner/ic_gifts.png";
      default:
        return "assets/mpartner/ic_icon_placeholder.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          color: AppColors.lightWhite1,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: AppColors.lightGrey1, // Adjust the color as needed
            width: 1.0, // Adjust the width as needed
          ),
        ),
        margin: EdgeInsets.all(16 * variablePixelWidth),
        child: Padding(
          padding: EdgeInsets.all(16 * variablePixelWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(getImagePath(state)),
                  SizedBox(height: variablePixelHeight * 12),
                  Text(stateMsg,
                      style: GoogleFonts.poppins(
                        color: AppColors.blackStatus,
                        fontSize: variablePixelHeight * 24,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(height: variablePixelHeight * 16),
                  Center(
                    child: Text(
                      data1,
                      style: GoogleFonts.poppins(
                        color: AppColors.lumiDarkBlack,
                        fontSize: variablePixelHeight * 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: variablePixelHeight * 16),
                  cashOrCoinHistory == "Cash"
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColors.lumiLight4,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                16 * variablePixelWidth,
                                8 * variablePixelHeight,
                                16 * variablePixelWidth,
                                8 * variablePixelHeight),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RupeeWithSignWidget(
                                    cash: double.tryParse(data2) ?? 0,
                                    color: AppColors.lumiBluePrimary,
                                    size: 16,
                                    weight: FontWeight.w600,
                                    width: 160),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   mainAxisSize: MainAxisSize.min,
                                //   children: [
                                //     Icon(
                                //       Icons.currency_rupee,
                                //       color: AppColors.lumiBluePrimary,
                                //       weight: 600,
                                //       size: 28 * variablePixelWidth,
                                //     ),
                                //     Text(
                                //       data2,
                                //       textAlign: TextAlign.center,
                                //       style: GoogleFonts.poppins(
                                //         color: AppColors.lumiBluePrimary,
                                //         fontSize: 28 * variablePixelWidth,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(height: 4 * variablePixelHeight),
                                Text(
                                  data3,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.lumiBluePrimary,
                                    fontSize: 14 * variablePixelWidth,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          // width: variablePixelWidth * 123,
                          // height: variablePixelHeight * 76,
                          decoration: BoxDecoration(
                            color: AppColors.goldCoinLight,
                            borderRadius: BorderRadius.circular(10.0),
                            // border: Border.all(
                            //   color: Colors.black,  // Adjust the color as needed
                            //   width: 1.0,  // Adjust the width as needed
                            // ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CoinWithImageWidget(
                                        coin: double.tryParse(
                                                data2.replaceAll(",", "")) ??
                                            0,
                                        color: AppColors.pendingYellow,
                                        size: 28,
                                        weight: FontWeight.w500,
                                        width: 280),
                                    // SvgPicture.asset(
                                    //   'assets/mpartner/ic_coins.svg',
                                    //   width: 21 * variablePixelWidth,
                                    //   height: 21 * variablePixelWidth,
                                    // ),
                                    // SizedBox(
                                    //   width: 4 * variablePixelWidth,
                                    // ),
                                    // Text(
                                    //   data2,
                                    //   textAlign: TextAlign.right,
                                    //   style: GoogleFonts.poppins(
                                    //     color: AppColors.pendingYellow,
                                    //     fontSize: 28 * variablePixelWidth,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // )
                                  ],
                                ),
                                SizedBox(height: 4 * variablePixelHeight),
                                Text(
                                  data3,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.pendingYellow,
                                    fontSize: 14 * variablePixelWidth,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(height: variablePixelHeight * 16),
                  Container(
                    width: variablePixelWidth * 336,
                    height: variablePixelHeight * 40,
                    child: Center(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${translation(context).transactionDate}: ',
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 12 * variablePixelWidth,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.10,
                              ),
                            ),
                            Text(
                              data4,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.lumiDarkBlack,
                                fontSize: 12 * variablePixelWidth,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.10,
                              ),
                            )
                          ],
                        ),
                        data5.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${translation(context).transactionId}: ',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.darkGreyText,
                                      fontSize: 12 * variablePixelWidth,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.10,
                                    ),
                                  ),
                                  Text(
                                    data5,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.lumiDarkBlack,
                                      fontSize: 12 * variablePixelWidth,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.10,
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                      ],
                    )),
                  ),
                  SizedBox(
                    height: variablePixelHeight * 35,
                  ),
                  const DotHorizontalDivider(color: Colors.grey),
                  SizedBox(
                    height: variablePixelHeight * 35,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${translation(context).exploreMoreOptionsToRedeem}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkGreyText,
                            fontSize: variablePixelHeight * 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: variablePixelHeight * 12,
                        ),
                        Container(
                            height: 114 * variablePixelHeight,
                            width: 297 * variablePixelWidth,
                            child: Image.asset(
                              getImgBanner(transactionType),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: variablePixelHeight * 35,
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
