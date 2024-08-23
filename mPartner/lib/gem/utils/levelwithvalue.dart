import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../presentation/screens/tertiary_sales/tertiary_sales_hkva_combo/components/combo_heading_and_card.dart';
import '../../solar/presentation/common/leads_list_detail_cards/detailed_summary_card.dart';
import '../../utils/app_colors.dart';
import '../../utils/displaymethods/display_methods.dart';

class LevelWithValue extends StatelessWidget {
  final String lavel;
  final String value;
  LevelWithValue({required this.lavel, required this.value});

  @override
  Widget build(BuildContext context) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    var style1 = GoogleFonts.poppins(
      color: AppColors.darkGreyText,
      fontSize: 12 * f,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.10,
    );
    var style3 = GoogleFonts.poppins(
      color: value.toString() == "Expired" ? AppColors.red : AppColors.black,
      fontSize: 14 * f,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10,
    );
    return rowWidget(lavel, value, style1, style3, w, context);
  }

  Widget rowWidget(String label, String labelValue, TextStyle style1,
      TextStyle style2, double w, BuildContext context) {
    bool isTruncated =
        TooltipHelper.isTextTruncated(labelValue, style2, w * 140);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: RowWithTwoElements(
        widget1: Container(
          child: Text(label, style: style1, maxLines: 10, softWrap: true),
        ),
        widget2: Container(
          child: isTruncated
              ? Tooltip(
                  message: (labelValue == "") ? "" : labelValue,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Text(
                    (labelValue == "") ? "" : labelValue,
                    textAlign: TextAlign.end,
                    style: style2,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : Text(
                  (labelValue == "") ? "" : labelValue,
                  textAlign: TextAlign.end,
                  style: style2,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
        context: context,
      ),
    );
  }
}

Widget RowWithTwoElements(
    {Widget? widget1, Widget? widget2, BuildContext? context}) {
  double w = DisplayMethods(context: context!).getVariablePixelWidth();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(child: widget1!),
      SizedBox(width: 10 * w),
      Expanded(child: widget2!),
    ],
  );
}

class LevelWithStatus extends StatelessWidget {
  final String lavel;
  final String value;
  LevelWithStatus({required this.lavel, required this.value});
  @override
  Widget build(BuildContext context) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    var style1 = GoogleFonts.poppins(
      color: AppColors.darkGreyText,
      fontSize: 12 * f,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.10,
    );
    var style3 = GoogleFonts.poppins(
      color: AppColors.black,
      fontSize: 12 * f,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10,
    );
    return new Container(
      margin: EdgeInsets.only(top: 5),
      child: new Row(
        children: [
          Expanded(
              child: new Container(
            child: new Text(
              lavel,
              style: style1,
            ),
          )),
          if (value.toString() == "Rejected")
            SvgPicture.asset(
              "assets/mpartner/cancel.svg",
              height: 20,
            ),
          if (value.toString() == "In Progress")
            SvgPicture.asset(
              "assets/mpartner/pending.svg",
              height: 20,
            ),
          if (value.toString() == "Received" ||
              value.toString() == "MAF Issued")
            SvgPicture.asset(
              "assets/mpartner/check_circle.svg",
              height: 20,
            ),
          new SizedBox(
            width: 10,
          ),
          Text(value.toString(),
              style: GoogleFonts.poppins(
                color: value.toString() == "In Progress"
                    ? AppColors.pendingYellow
                    : value.toString() == "Received"
                        ? AppColors.green
                        : value.toString() == "Rejected"
                            ? AppColors.red
                            : AppColors.black,
                fontSize: 12 * f,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }
}
