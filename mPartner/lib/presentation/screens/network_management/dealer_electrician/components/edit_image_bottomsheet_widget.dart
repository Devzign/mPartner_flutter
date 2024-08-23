import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'dashed_rectangle_widget.dart';
import 'search_header.dart';

class EditImageBottomSheetWidget extends StatefulWidget {
  final Function(String) onItemSelected;
  final String? contentTiltle;
  final String? path;

  const EditImageBottomSheetWidget(
      {required this.onItemSelected, this.contentTiltle, this.path, super.key});

  @override
  State<EditImageBottomSheetWidget> createState() =>
      _EditImageBottomSheetWidget();
}

class _EditImageBottomSheetWidget extends State<EditImageBottomSheetWidget> {
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
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

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
              Stack(
                alignment: Alignment.center,
                children: [
                  Visibility(
                    visible: false,
                    child: Container(
                      height: 220 * variablePixelHeight,
                      width: 350 * variablePixelWidth,
                      child: DashedRect(
                          color: AppColors.lumiBluePrimary,
                          strokeWidth: 2.0,
                          gap: 5.0),
                    ),
                  ),
                  ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12.0 * variablePixelMultiplier),
                      // margin: EdgeInsets.only(left:5*variablePixelWidth,right: 5*variablePixelWidth,top: 5*variablePixelHeight,bottom: 5*variablePixelHeight),
                      child: Image.file(
                        File(widget.path!),
                        fit: BoxFit.cover,
                        height: 210 * variablePixelHeight,
                        width: 320 * variablePixelWidth,
                      )),
                ],
              ),
              SizedBox(
                height: 20 * variablePixelWidth,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 10 * variablePixelWidth),
                height: 60 * variablePixelHeight,
                child: Row(
                  children: [
                    Container(
                      height: 48 * variablePixelHeight,
                      width: 320 * variablePixelWidth,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () => {widget.onItemSelected("reupload")},
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
                            width: 320 * variablePixelWidth,
                            alignment: Alignment.center,
                            child: Text(
                              maxLines: 1,
                              translation(context).reUpload,
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
                  ],
                ),
              ),
              SizedBox(
                width: 20 * variablePixelWidth,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
