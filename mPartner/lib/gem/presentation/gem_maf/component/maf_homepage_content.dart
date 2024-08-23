import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../presentation/widgets/common_button.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../data/models/maf_home_page_model.dart';

class MafHomePageContent extends StatelessWidget {
  Function(String, String) onClick;
  Function() requestCode;
  MafHomePageModel? datalist;

  MafHomePageContent(this.datalist,
      {required this.onClick, required this.requestCode});

  String formatStringNumber(String numberString) {
    int number = int.tryParse(numberString) ?? 0;
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double fontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    double textMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();

    // String? statusTitle = "";
    // if (datalist!.received.toString() == "Approved") {
    //   statusTitle = "Issued";
    // } else {
    //   statusTitle = datalist!.received.toString();
    // }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: 18 * variablePixelWidth, right: 18 * variablePixelWidth),
            //padding: EdgeInsets.fromLTRB(widget.horizontalPadding * variablePixelWidth, widget.top * variablePixelHeight, widget.horizontalPadding * variablePixelWidth, widget.bottom * variablePixelHeight),
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.white_234,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.white_234.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 8,bottom: 8),
                    margin: EdgeInsets.only(left: 8, right: 8),
                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.white_234,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.white_234.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                    formatStringNumber(datalist!.total.toString()),
                          style: GoogleFonts.poppins(
                            color: AppColors.lumiBluePrimary,
                            fontSize: 16 * textMultiplier,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        Text(translation(context).totalEnquiry,
                          style: GoogleFonts.poppins(
                              color: AppColors.darkBackground,
                              fontSize: 14 * fontMultiplier,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    onClick("", "");
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 5,bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.white_234,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.white_234.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                child: Column(
                                  children: [
                                    VerticalSpace(
                                        height: 8 * variablePixelHeight),
                                    Text(
                                      formatStringNumber(datalist!.received.toString().toString()),
                                      style: GoogleFonts.poppins(
                                        color: AppColors.lumiBluePrimary,
                                        fontSize: 16 * textMultiplier,
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                    Text(
                                      translation(context).issued,
                                      style: GoogleFonts.poppins(
                                          color: AppColors.darkGreen,
                                          fontSize: 14 * fontMultiplier,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  onClick("Approved", "");
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      new SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 5,bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.white_234,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.white_234.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  child: Column(
                                    children: [
                                      VerticalSpace(
                                          height: 8 * variablePixelHeight),
                                      Text(
                                        formatStringNumber(datalist!.inProgress.toString()),
                                        style: GoogleFonts.poppins(
                                          color: AppColors.lumiBluePrimary,
                                          fontSize: 16 * textMultiplier,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                      Text(
                                        translation(context).inProgress,
                                        style: GoogleFonts.poppins(
                                            color: AppColors.pendingYellow,
                                            fontSize: 14 * fontMultiplier,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    onClick("In Progress", "");
                                  },
                                )
                              ],
                            ),
                          )),
                      new SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 5,bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.white_234,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  child: Column(
                                    children: [
                                      VerticalSpace(
                                          height: 8 * variablePixelHeight),
                                      Text(
                                        formatStringNumber(datalist!.rejected.toString()),
                                        style: GoogleFonts.poppins(
                                          color: AppColors.lumiBluePrimary,
                                          fontSize: 16 * textMultiplier,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                      Text(
                                        translation(context).rejected,
                                        style: GoogleFonts.poppins(
                                            color: AppColors.exceedRed,
                                            fontSize: 14 * fontMultiplier,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    onClick("Rejected", "");
                                  },
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 50 * variablePixelWidth,
                    right: 60 * variablePixelWidth,
                    left: 60 * variablePixelWidth,
                    bottom: 24 * variablePixelWidth),
                child: CommonButton(
                    onPressed: () async {
                      requestCode();
                    },
                    isEnabled: true,
                    buttonText: translation(context).raisemafrequest,
                    withContainer: false
                  //containerBackgroundColor: AppColors.white,
                ),
              )),
        ],
      ),
    );
  }
}
