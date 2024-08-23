import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../common/leads_list_detail_cards/solar_status.dart';

class CustomExistingLeadsCardWidget extends StatefulWidget {
  final Function() onItemSelected;
  final String? id;
  final String? label1;
  final String? label2;
  final String? label3;
  final String? label4;
  final String? value1;
  final String? value2;
  final String? value3;
  final String? value4;
  final String? status;
  final String? statusText;

  /*final Color? statusColor;
  final SvgPicture? statusIconWidget;*/

  const CustomExistingLeadsCardWidget(
      {required this.onItemSelected,
      this.id,
      this.label1,
      this.label2,
      this.label3,
      this.label4,
      this.value1,
      this.value2,
      this.value3,
      this.value4,
      this.status,
      this.statusText,
      /*this.statusColor,
        this.statusIconWidget,*/
      super.key});

  @override
  State<CustomExistingLeadsCardWidget> createState() =>
      _CustomExistingLeadsCardWidgetState();
}

class _CustomExistingLeadsCardWidgetState
    extends State<CustomExistingLeadsCardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return GestureDetector(
      onTap: widget.onItemSelected,
      child: Container(
        alignment: Alignment.center,
        //height: 182 * h,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 12 * r, right: 12 * r, top: 15 * r),
        margin: EdgeInsets.only(left: 24 * w, right: 24 * w, bottom: 18 * r),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.lightGrey2,
          ),
          borderRadius: BorderRadius.circular(12 * r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 160 * w,
                  alignment: Alignment.centerLeft,
                  child: Text(widget.id ?? "",
                      style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontSize: 14 * f,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                SolarStatus(
                  status: widget.status!.toLowerCase(),
                ),
              ],
            ),
            SizedBox(
              height: 10 * h,
            ),
            rowWidget(widget.label1 ?? "", widget.value1 ?? "", w, f),
            SizedBox(
              height: 10 * h,
            ),
            rowWidget(widget.label2 ?? "", widget.value2 ?? "", w, f),
            SizedBox(
              height: 10 * h,
            ),
            rowWidget(widget.label3 ?? "", widget.value3 ?? "", w, f),
            SizedBox(
              height: 10 * h,
            ),
            rowWidget(widget.label4 ?? "", widget.value4 ?? "", w, f),
            SizedBox(
              height: 10 * h,
            ),
          ],
        ),
      ),
    );
  }

  Widget rowWidget(String data1, String data2, double w, double f,
      {String? status}) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    var style2 = GoogleFonts.poppins(
      color: AppColors.darkGreyText,
      fontSize: 12 * f,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10,
    );
    bool isTruncated = TooltipHelper.isTextTruncated(data2, style2, w * 140);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 160 * w,
            child: Text(
              data1,
              style: GoogleFonts.poppins(
                fontSize: 12.0 * f,
                letterSpacing: 0.10,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
          ),
          status == null
              ? /*Expanded(
                  child: Text(
                    data2.isEmpty ? "-" : data2,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.poppins(
                      fontSize: 12.0 * f,
                      letterSpacing: 0.10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackText,
                    ),
                  ),
                )*/
              Expanded(
                child: Container(
                    //  width: w * 140,
                    child: isTruncated
                        ? Tooltip(
                            margin: EdgeInsets.only(left: 20*w,right: 20*w),
                            message: data2.isEmpty ? "-" : data2,
                            triggerMode: TooltipTriggerMode.tap,
                            child: Text(
                              data2.isEmpty ? "-" : data2,
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(
                                fontSize: 12.0 * f,
                                letterSpacing: 0.10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackText,
                              ),
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Text(
                            data2.isEmpty ? "-" : data2,
                            textAlign: TextAlign.end,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0 * f,
                              letterSpacing: 0.10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackText,
                            ),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          )),
              )
              : SolarStatus(
                  status: widget.statusText!.toLowerCase(),
                ),
        ],
      ),
    );
  }
}

class TooltipHelper {
  static bool isTextTruncated(String text, TextStyle style, double maxWidth) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }
}
