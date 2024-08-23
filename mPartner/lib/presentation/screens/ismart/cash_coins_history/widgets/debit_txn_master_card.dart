import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';

import '../../../../../../utils/app_string.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/coin_with_image_widget.dart';
import '../../../../widgets/dot_horizontal_divider.dart';
import '../../../../widgets/rupee_with_sign_widget.dart';

class MasterCard extends StatelessWidget {
  final String state;
  final String stateMsg;
  final String cashOrCoinHistory;
  final String transactionRemark;
  final String points;
  final String pointsEarnedMsg;
  final String transactionId;

  // final Widget body;
  final String customerName;
  final String transDate;
  final String transactionType;
  final String finalRemark;

  const MasterCard(
      {super.key,
      required this.state,
      required this.cashOrCoinHistory,
      // required this.body,
      required this.customerName,
      required this.transDate,
      required this.stateMsg,
      required this.transactionRemark,
      required this.points,
      required this.pointsEarnedMsg,
      required this.transactionId,
      required this.finalRemark,
      required this.transactionType});

  String getImagePath(String status) {
    logger.e("N_D: state==> $state , cashOrCoinHistory: $cashOrCoinHistory");
    switch (status) {
      case 'Successful':
        return "assets/mpartner/success.svg";
      case 'Failed':
        return "assets/mpartner/rejected.svg";
      case 'Pending':
        return "assets/mpartner/pending.svg";
      default:
        return "assets/mpartner/pending.svg";
    }
  }

  Widget setTransactionType(String transactionType, double variablePixelHeight,
      double variablePixelWidth, BuildContext context) {
    logger.e("N_D: transactionType: $transactionType");
    switch (transactionType) {
      case FilterCashCoin.paytmType:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/mpartner/type_paytm.png'),
            SizedBox(
              height: variablePixelHeight * 12,
            ),
            Text(
              translation(context).redemptionViaPaytmWallet,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: variablePixelHeight * 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      case FilterCashCoin.pinelabType:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/mpartner/type_pinelab.png'),
            SizedBox(
              height: variablePixelHeight * 12,
            ),
            Text(
              translation(context).redemptionViaPinelabWallet,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: variablePixelHeight * 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      case FilterCashCoin.upiType:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/mpartner/type_upi.png'),
            SizedBox(
              height: variablePixelHeight * 12,
            ),
            Text(
              translation(context).redemptionViaUPI,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: variablePixelHeight * 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );

      case FilterCashCoin.creditNoteType:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/mpartner/type_creditnote.png'),
            SizedBox(
              height: variablePixelHeight * 12,
            ),
            Text(
              translation(context).issuedViaCN,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: variablePixelHeight * 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      case FilterCashCoin.cashbackType:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/mpartner/ic_coinstocash.png'),
            SizedBox(
              height: variablePixelHeight * 12,
            ),
            Text(
              translation(context).coinsConvertedToCash,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: variablePixelHeight * 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      case FilterCashCoin.tripsType:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/mpartner/coinstotrips.png'),
            SizedBox(
              height: variablePixelHeight * 12,
            ),
            Text(
              translation(context).redemptionViaTrips,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: variablePixelHeight * 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      case FilterCashCoin.giftsType:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/mpartner/coinstogifts.png'),
            SizedBox(
              height: variablePixelHeight * 12,
            ),
            Text(
              translation(context).redemptionViaGifts,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: variablePixelHeight * 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      case FilterCashCoin.bonusType:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/mpartner/bonus_cake.svg"),
            SizedBox(
              height: variablePixelHeight * 12,
            ),
            Text(
              translation(context).bonusByLuminous,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: variablePixelHeight * 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          color: AppColors.lightWhite1,
          borderRadius: BorderRadius.circular(10 * pixelMultiplier),
          border: Border.all(
            color: AppColors.lightGrey1,
            width: 1 * variablePixelWidth,
          ),
        ),
        margin: EdgeInsets.only(
            left: 16 * variablePixelWidth,
            right: 16 * variablePixelWidth,
            bottom: 16 * variablePixelHeight),
        child: Padding(
          padding: EdgeInsets.all(16 * pixelMultiplier),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon and Text
              Column(
                children: [
                  state == "Bonus"
                      ? Image.asset('assets/mpartner/ic_congo.jpg')
                      : SvgPicture.asset(getImagePath(state)),
                  state == "Bonus"
                      ? SizedBox()
                      : SizedBox(height: variablePixelHeight * 12),
                  state == "Bonus"
                      ? SizedBox()
                      : Text(
                          stateMsg,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppColors.blackStatus,
                            fontSize: 24 * textFontMultiplier,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  SizedBox(height: variablePixelHeight * 16),
                  Text(
                    (state.toLowerCase() == FilterCashCoin.pendingType &&
                            transactionType == FilterCashCoin.tripsType)
                        ? CoinHistoryStrings.pendingRemarkTrip
                        : transactionRemark,
                    style: GoogleFonts.poppins(
                      color: (transactionType == FilterCashCoin.bonus_adjustment)
                          ? AppColors.lightRed : AppColors.lumiDarkBlack,
                      fontSize: textFontMultiplier * 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: variablePixelHeight * 16),
              cashOrCoinHistory == "Cash"
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppColors.lumiLight4,
                        borderRadius:
                            BorderRadius.circular(10 * pixelMultiplier),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RupeeWithSignWidget(
                                  cash: double.parse(
                                      points.toString().replaceAll(',', '')),
                                  color: AppColors.lumiBluePrimary,
                                  width: 180,
                                  weight: FontWeight.w600,
                                  size: 18,
                                )
                              ],
                            ),
                            pointsEarnedMsg.isNotEmpty
                                ? Text(
                                    pointsEarnedMsg,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.lumiBluePrimary,
                                      fontSize: 14 * textFontMultiplier,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.10,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: AppColors.goldCoinLight,
                        borderRadius:
                            BorderRadius.circular(10 * pixelMultiplier),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CoinWithImageWidget(
                                  coin: double.parse(
                                      points.toString().replaceAll(',', '')),
                                  width: 180,
                                  weight: FontWeight.w600,
                                  size: 18,
                                  color: (transactionType == FilterCashCoin.bonus_adjustment)
                                      ?AppColors.lightRed:AppColors.goldCoin,
                                )
                              ],
                            ),
                            pointsEarnedMsg.isNotEmpty
                                ? Text(
                                    pointsEarnedMsg,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color:  (transactionType == FilterCashCoin.bonus_adjustment)
                                          ?AppColors.lightRed:AppColors.pendingYellow,
                                      fontSize: 14 * textFontMultiplier,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.10,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: variablePixelHeight * 28),
              //body
              transactionType == FilterCashCoin.paytmType
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Credited to $transactionType wallet linked with',
                          style: GoogleFonts.poppins(
                            color: AppColors.darkGrey,
                            fontSize: 12 * textFontMultiplier,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.10,
                          ),
                        ),
                        SizedBox(height: 8 * variablePixelHeight),
                        Text(
                          '$customerName on $transDate',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkText2,
                            fontSize: 12 * textFontMultiplier,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.10,
                          ),
                        ),
                        SizedBox(height: 8 * variablePixelHeight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${translation(context).transactionId}: ',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkText2,
                                fontSize: 12 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.10,
                              ),
                            ),
                            Text(
                              transactionId,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkText2,
                                fontSize: 12 * textFontMultiplier,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : ((transactionType == FilterCashCoin.bonus_adjustment))
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${translation(context).transactionDate}: ',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGrey,
                                    fontSize: 12 * textFontMultiplier,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                                Text(
                                  transDate,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGrey,
                                    fontSize: 12 * textFontMultiplier,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8 * variablePixelHeight),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${translation(context).transactionId}: ',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkText2,
                                    fontSize: 12 * textFontMultiplier,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                                Text(
                                  transactionId,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkText2,
                                    fontSize: 12 * textFontMultiplier,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8 * variablePixelHeight),
                            Text(
                              finalRemark,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGrey,
                                fontSize: 12 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
              SizedBox(
                height: variablePixelHeight * 40,
              ),
              const DotHorizontalDivider(color: Colors.grey),
              SizedBox(
                height: variablePixelHeight * 35,
              ),
              (transactionType == FilterCashCoin.bonus_adjustment)
                  ? Container(
                    margin: EdgeInsets.only(bottom: 24 * variablePixelHeight ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            /*${translation(context).transactionDate}:*/
                            'Adjusted on ',
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Text(
                            transDate,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ],
                      ),
                  )
                  : Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 8 * variablePixelHeight),
                      child: setTransactionType(transactionType,
                          variablePixelHeight, variablePixelWidth, context),
                    ),
            ],
          ),
        ),
      ),
    ]);
  }
}
