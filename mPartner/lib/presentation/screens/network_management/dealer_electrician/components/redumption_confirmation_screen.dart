import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'dashed_rectangle_widget.dart';
import 'search_header.dart';

class RedumptionConfirmationScreenWidget extends StatefulWidget {
  final Function(String) onItemSelected;
  final String? contentTiltle;
  final String? path;
  final String? message;

  const RedumptionConfirmationScreenWidget(
      {required this.onItemSelected, this.contentTiltle, this.path,this.message, super.key});

  @override
  State<RedumptionConfirmationScreenWidget> createState() =>
      _RedumptionConfirmationScreenWidget();
}

class _RedumptionConfirmationScreenWidget extends State<RedumptionConfirmationScreenWidget> {
  TextEditingController _searchController = TextEditingController();

  String contentTiltle = "";

  @override
  void initState() {
    contentTiltle = widget.contentTiltle!;
    super.initState();
  }

  void _handleStateSelected(String stateInfo) {
    widget.onItemSelected(
        stateInfo); // Invoke the callback passed from the parent
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    var variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    var textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      margin: EdgeInsets.only(left: 10 * variablePixelWidth),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SearchHeaderWidget(
          title: contentTiltle,
          onClose: () => Navigator.of(context).pop(),
        ),
        Container(
          width: variablePixelWidth * 392,
          padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20 * variablePixelHeight,
              ),
              Text(widget.message!+translation(context).redeemAnyReward, style: GoogleFonts.poppins(
                fontSize: 14.0 * textMultiplier,
                letterSpacing: 0.10,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),),

              SizedBox(height: 30*variablePixelHeight,),
              Text(translation(context).sureToContinue, style: GoogleFonts.poppins(
                fontSize: 16.0 * textMultiplier,
                letterSpacing: 0.10,
                height: 0.10,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),),
              SizedBox(
                height: 20 * variablePixelWidth,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 10*variablePixelWidth),
                height: 60*variablePixelHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10*variablePixelWidth),
                        height: 48 * variablePixelHeight,
                        width: 165* variablePixelWidth,
                        alignment: Alignment.center,
                        child: OutlinedButton(
                            onPressed: ()=>{
                              widget.onItemSelected("no")
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(const BorderSide(
                                  color: AppColors.lumiBluePrimary,
                                  width: 1,
                                  style: BorderStyle.solid)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30.0*variablePixelMultiplier))),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 48 * variablePixelHeight,
                              width: 165* variablePixelWidth,
                              child: Text(
                                maxLines: 1,
                                translation(context).no,
                                // softWrap: true,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.0 * textMultiplier,
                                  letterSpacing: 0.10,
                                  height: 0.10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.lumiBluePrimary,
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 10 * variablePixelWidth,
                    ),
                    Expanded(
                      child: Container(
                        height: 48 * variablePixelHeight,
                        width: 165* variablePixelWidth,

                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: ()=>{
                              widget.onItemSelected("yes")
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0 * variablePixelWidth),
                              ),
                              backgroundColor: AppColors.lumiBluePrimary,
                              disabledBackgroundColor: AppColors.lightWhite2,
                            ),
                            child: Container(
                              height: 48 * variablePixelHeight,
                              width: 165* variablePixelWidth,
                              alignment: Alignment.center,
                              child: Text(
                                maxLines: 1,
                                translation(context).yes,
                                // softWrap: true,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.0 * textMultiplier,
                                  letterSpacing: 0.10,
                                  height: 0.10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16 * variablePixelWidth,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
