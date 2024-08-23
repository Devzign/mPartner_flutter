import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';

import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../widgets/coin_with_image_widget.dart';
import '../../../../widgets/dot_horizontal_divider.dart';
import '../../../../widgets/rupee_with_sign_widget.dart';

class MasterCard extends StatelessWidget {
  final String state;
  final String stateMsg;
  final String cashOrCoinHistory;
  final String transMsg;
  final String points;
  final String pointsEarnedMsg;
  final String remark;
  final String otpRemark;
  final String category;
  final String model;
  final String serialNo;
  final String saleTypeRemark;
  final String customerName;
  final String customerPhone;
  final String transDate;
  const MasterCard(
      {super.key,
      required this.state,
      required this.cashOrCoinHistory,
      required this.stateMsg,
      required this.transMsg,
      required this.points,
      required this.pointsEarnedMsg,
      required this.remark,
      required this.otpRemark,
      required this.category,
      required this.model,
      required this.serialNo,
      required this.saleTypeRemark,
      required this.customerName,
      required this.customerPhone,
      required this.transDate,
      });

  String getImagePath(String status) {
    switch (status) {
      case 'Accepted':
        return "assets/mpartner/success.svg";
      case 'Rejected':
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
    double textFontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();


    return
      Stack(children: [
      Container(
        decoration: BoxDecoration(
          color: AppColors.lightWhite1,
          borderRadius: BorderRadius.circular(10*pixelMultiplier),
          border: Border.all(
            color: AppColors.lightGrey1, // Adjust the color as needed
            width: 1*variablePixelWidth, // Adjust the width as needed
          ),
        ),
        margin: EdgeInsets.only(left:16*variablePixelWidth ,right: 16*variablePixelWidth,bottom: 16*variablePixelHeight),
        child: Padding(
          padding: EdgeInsets.all(16 * pixelMultiplier),
          child: Column(
            children: [
              Column(
                children: [
                  SvgPicture.asset(getImagePath(state)),
                  SizedBox(height: variablePixelHeight * 12),
                  Text(stateMsg,
                      style: GoogleFonts.poppins(
                        color: AppColors.blackStatus,
                        fontSize: textFontMultiplier * 24,
                        fontWeight: FontWeight.w600,
                      ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: variablePixelHeight*16),
                      Text(transMsg, style: GoogleFonts.poppins(
                    color: AppColors.lumiDarkBlack,
                    fontSize: textFontMultiplier*14,
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
                        borderRadius: BorderRadius.circular(10*pixelMultiplier),
                      ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16*variablePixelWidth, 8*variablePixelHeight, 16*variablePixelWidth, 8*variablePixelHeight),
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
                              Text(
                                pointsEarnedMsg,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.lumiBluePrimary,
                                  fontSize: 14 * textFontMultiplier,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          ),
                        ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: AppColors.goldCoinLight,
                        borderRadius: BorderRadius.circular(10*pixelMultiplier),
                      ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16*variablePixelWidth, 8*variablePixelHeight, 16*variablePixelWidth, 8*variablePixelHeight),
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
                                    color: AppColors.goldCoin,
                                  )
                                ],
                              ),
                              SizedBox(height: 8 * variablePixelHeight),
                              Text(
                                pointsEarnedMsg,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.pendingYellow,
                                  fontSize: 14 * textFontMultiplier,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
              SizedBox(height: variablePixelHeight * 24),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  remark.isNotEmpty ? Text(
                    "Remark: $remark",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 12 * textFontMultiplier,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.10,
                    ),
                  ):const SizedBox(),
                  SizedBox(height: variablePixelHeight * 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      otpRemark.isNotEmpty ? Container(
                        height: variablePixelHeight * 24,
                        decoration: BoxDecoration(
                          color: AppColors.lumiLight4,
                          borderRadius: BorderRadius.circular(10*pixelMultiplier),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8*variablePixelWidth,right: 8*variablePixelWidth),
                            child: Text(
                              otpRemark,
                              style: GoogleFonts.poppins(
                                color: AppColors.lumiBluePrimary,
                                fontSize: 10 * variablePixelWidth,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),),):const SizedBox(),
                    ],
                  )
                ],
              ),
                SizedBox(height: variablePixelHeight*40,),
                const DotHorizontalDivider(color: Colors.grey),
                SizedBox(height: variablePixelHeight*35,),
                //body
                Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          () {
                            if (category.toString().isNotEmpty) {
                              return category;
                            } else {
                              return '-';
                            }
                          }(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkGrey,
                            fontSize: 12 * textFontMultiplier,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5 * variablePixelWidth,
                            top: 5 * variablePixelHeight,
                            right: 5 * variablePixelWidth),
                        child: Container(
                          width: 4 * variablePixelWidth,
                          height: 4 * variablePixelHeight,
                          decoration: const ShapeDecoration(
                            color: AppColors.lightGrey1,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                            () {
                              if (model.toString().isNotEmpty) {
                                return model;
                              } else {
                                return '-';
                              }
                            }(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5 * variablePixelWidth,
                            top: 5 * variablePixelHeight,
                            right: 5 * variablePixelWidth),
                        child: Container(
                          width: 4 * variablePixelWidth,
                          height: 4 * variablePixelHeight,
                          decoration: const ShapeDecoration(
                            color: AppColors.lightGrey1,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            serialNo,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(height: 8 * variablePixelHeight),
                  Text(
                    saleTypeRemark,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGrey,
                      fontSize: 12 * textFontMultiplier,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.10,
                    ),
                  ),
                  SizedBox(height: 8 * variablePixelHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        customerName,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGrey,
                          fontSize: 12 * textFontMultiplier,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10,
                        ),
                      ),
                      Text(
                        customerPhone,
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
                        'Registered on ',
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
                  )
                ],
              ),
              ],
              ),
        ),
      ),
    ]);
  }
}
