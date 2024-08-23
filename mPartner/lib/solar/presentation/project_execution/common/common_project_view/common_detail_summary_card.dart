import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/solar/presentation/common/leads_list_detail_cards/solar_status.dart';

import '../../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';


class CustomDetailedSummaryCard extends StatefulWidget {
  final Map<String, Map<String, String>> labelData;
  final String statusValue;
  final VoidCallback? onTapDownload;
  final VoidCallback? onTapShare;

  const CustomDetailedSummaryCard({
    super.key,
    required this.labelData,
    this.statusValue = "",
    this.onTapDownload,
    this.onTapShare,
  });

  @override
  State<CustomDetailedSummaryCard> createState() => _DetailedSummaryCardState();
}

class _DetailedSummaryCardState extends State<CustomDetailedSummaryCard> {
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    var style1 = GoogleFonts.poppins(
      color: AppColors.darkGreyText,
      fontSize: 12 * f,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.10 ,
    );
    var style2 = GoogleFonts.poppins(
      color: AppColors.darkGreyText,
      fontSize: 14 * f,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10 ,
    );
    var style3 = GoogleFonts.poppins(
      color: AppColors.black,
      fontSize: 14 * f,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10 ,
    );

    return Card(
      elevation: 0,
      shadowColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0 *r),
      ),
      color: AppColors.grey97,
      child: Padding(
        padding: EdgeInsets.all(12.0 * r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  translation(context).customerProjectDetails,
                  style: GoogleFonts.poppins(
                    fontSize: 16 * f,
                    color: AppColors.darkGreyText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.statusValue != "" && (widget.statusValue.toLowerCase() == 'resolved'/*widget.statusValue.toLowerCase() == 'resolved'*/))
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.onTapDownload != null) {
                            widget.onTapDownload!();
                          }
                        },
                        child: Container(
                            width: 28 * w,
                            height: 28 * w,
                            padding: EdgeInsets.all(4 * r),
                            clipBehavior: Clip.none,
                            decoration: ShapeDecoration(
                              color: AppColors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1 * w, color: AppColors.grayBorder),
                                borderRadius: BorderRadius.circular(12 * r),
                              ),
                            ),
                            child: Center(
                                child: Icon(
                                  Icons.file_download_outlined,
                                  size: 20 * r,
                                  color: AppColors.darkGreyText,
                                )
                            )
                        ),
                      ),
                      HorizontalSpace(width: 12),
                      GestureDetector(
                        onTap: () {
                          if (widget.onTapShare != null) {
                            widget.onTapShare!();
                          }
                        },
                        child: Container(
                            width: 28 * w,
                            height: 28 * w,
                            padding: EdgeInsets.all(4 * r,),
                            clipBehavior: Clip.none,
                            decoration: ShapeDecoration(
                              color: AppColors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1 * w, color: AppColors.grayBorder),
                                borderRadius: BorderRadius.circular(12 * r),
                              ),
                            ),
                            child: Center(
                                child: Icon(
                                  Icons.share_outlined,
                                  size: 20 * r,
                                  color: AppColors.darkGreyText,
                                )
                            )
                        ),
                      ),
                    ],
                  )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0 * h ),
              child: Divider(
                thickness: 1 * r,
                color: AppColors.lightGrey2,
              ),
            ),
            for (var label in widget.labelData.entries)
              if (label.value['type'] == "status" && label.key != "")
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5 * h),
                  child: RowWithTwoElements(
                      widget1: Text(
                        label.key,
                        style: style1,
                      ),
                      widget2: SolarStatus(
                        status: label.value['val']!.toLowerCase(),
                      )
                  ),
                )
              else if (label.value['type'] == "text" && label.key != "")
                rowWidget(label.key, label.value['val']!,
                    style1, style2)
              else if (label.value['type'] == "black_text" && label.key != "")
                  rowWidget(label.key, label.value['val']!,
                      style1, style3),
          ],
        ),
      ),
    );
  }

  Widget rowWidget(String label, String labelValue, TextStyle style1, TextStyle style2) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    bool isTruncated = TooltipHelper.isTextTruncated(
        labelValue,
        style2,
        w * 140
    );

    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: RowWithTwoElements(
        widget1: Container(
          // width: w * 160,
          child: Text(
            label,
            style: style1,
            maxLines: 10,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        widget2: Container(
          //  width: w * 140,
          child: isTruncated
              ? Tooltip(
            message: (labelValue == "") ? "" : labelValue,
            triggerMode: TooltipTriggerMode.tap,
            child: Text(
              (labelValue == "") ? "-" : labelValue,
              textAlign: TextAlign.end,
              style: style2,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          )
              : Text(
            (labelValue == "") ? "-" : labelValue,
            textAlign: TextAlign.end,
            style: style2,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget RowWithTwoElements({Widget? widget1,Widget? widget2}){
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: widget1!),
        SizedBox(width: 10*w),
        Expanded(child: widget2!),
      ],
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
