import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../presentation/widgets/common_divider.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';

class LabelValue {
  final String status;
  final String action; //reason
  final Color statusColor;

  LabelValue({required this.action, required this.status, required this.statusColor});
}

class RequestTrackingWidget extends StatefulWidget {
  final Map<String, LabelValue> labelData;
  final String monthAndYear;

  const RequestTrackingWidget({
    super.key,
    required this.labelData,
    required this.monthAndYear,
  });

  @override
  State<RequestTrackingWidget> createState() => _RequestTrackingWidgetState();
}

class _RequestTrackingWidgetState extends State<RequestTrackingWidget> {
  List<MapEntry<String, LabelValue>> getLabelDataEntries() {
    return widget.labelData.entries
        .where((entry) => entry.key != "")
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final labelDataEntries = getLabelDataEntries();

    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8 * h, horizontal: 24 * w),
            decoration: ShapeDecoration(
              color: AppColors.lumiLight5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8 * r)),
            ),
            child: Text(
             widget.monthAndYear,
              style: GoogleFonts.poppins(
                color: AppColors.darkText2,
                fontSize: 14 * f,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 12 * h, horizontal: 24 * w),
            itemCount: labelDataEntries.length,
            itemBuilder: (context, index) {
              final entry = labelDataEntries[index];
              final labelKey = entry.key;
              final labelAction = entry.value.action;
              final labelStatus = entry.value.status;
              final statusColor = entry.value.statusColor;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rowWidgetWithStatus(labelKey,  labelStatus, w, f, statusColor),
                  SizedBox(height: 5 * h,),
                  rowWidget(translation(context).actionTaken, labelAction , w, f),
                  if (index != labelDataEntries.length - 1)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0 * h),
                    child: const CustomDivider(color: AppColors.lightGrey2,),
                  ),
                ]
              );
            },),
        ],
    );
  }


  Widget rowWidget(String data1, String data2, double w, double f) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              '$data1:',
              style: GoogleFonts.poppins(
                color: AppColors.darkText2,
                fontSize: 12 * f,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            data2.isEmpty ? "-" : data2,
            textAlign: TextAlign.start,
            softWrap: true,
            style: GoogleFonts.poppins(
              color: AppColors.darkText2,
              fontSize: 12 * f,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  Widget rowWidgetWithStatus(String data1, String data2, double w, double f, Color statusColor) {
    String date = data1;
    DateTime parsedDate = DateTime.parse(date);
    date = DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              date,
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                ),
            ),
          ),
          Expanded(
            child: Text(
              data2.isEmpty ? "-" : data2,
              textAlign: TextAlign.end,
              softWrap: true,
              style: GoogleFonts.poppins(
                color: statusColor,
                fontSize: 14 * f,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
