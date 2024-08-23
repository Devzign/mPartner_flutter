import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import 'solar_status.dart';

class CustomSolarLeadsCardWidget extends StatefulWidget {
  final Function() onItemSelected;
  final String? id;
  final String? status;
  final String? label1;
  final String? value1;
  final String? label2;
  final String? value2;
  final String? label3;
  final String? value3;
  final String? label4;
  final String? value4;

  const CustomSolarLeadsCardWidget(
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
      super.key});

  @override
  State<CustomSolarLeadsCardWidget> createState() =>
      _CustomSolarLeadsCardWidgetState();
}

class _CustomSolarLeadsCardWidgetState
    extends State<CustomSolarLeadsCardWidget> {
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
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            left: 12 * r,
            right: 12 * r,
            top: 18 * r),
        margin: EdgeInsets.only(
            left: 24 * w,
            right: 24 * w,
            bottom: 18 * r
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.lightGrey2,
          ),
          borderRadius: BorderRadius.circular(12 * r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.id ?? "",
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: 14 * f,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  SolarStatus(status: widget.status!.toLowerCase(),),
                ],
              ),
            ),
            SizedBox(
              height: 10 * h,
            ),
            rowWidget(widget.label1 ?? "", widget.value1 ?? "",w,f),
            SizedBox(
              height: 10 * h,
            ),
            rowWidget(widget.label2 ?? "", widget.value2 ?? "",w,f),
            SizedBox(
              height: 10 * h,
            ),
            rowWidget(widget.label3 ?? "", widget.value3 ?? "",w,f),
            SizedBox(
              height: 10 * h,
            ),
            rowWidget(widget.label4 ?? "", widget.value4 ?? "",w,f),
            SizedBox(
              height: 20 * h,
            ),
          ],
        ),
      ),
    );
  }

  Widget rowWidget(String data1, String data2, double w, double f, {String? status}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 170 * w,
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
          Expanded(
            child: Text(
              data2.isEmpty ? "-" : data2,
              textAlign: TextAlign.end,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12.0 * f,
                letterSpacing: 0.10,
                fontWeight: FontWeight.w500,
                color: AppColors.blackText,
              ),
            ),
          )
        ],
      ),
    );
  }
}
