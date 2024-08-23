import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/presentation/screens/report_management/widgets/common_bottom_modal.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import 'filters/select_date_status_filter.dart';

class SearchFilterWidget extends StatelessWidget {
  final Widget filterType;

  SearchFilterWidget({Key? key, required this.filterType});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 40 * h,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.lightGreyOval,
                  size: 20 * w,
                ),
                hintText: "Search",
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.hintColor,
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 8 * w),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: AppColors.white_234),
                  borderRadius: BorderRadius.circular(8 * r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: AppColors.white_234),
                  borderRadius: BorderRadius.circular(8 * r),
                ),
                 focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: AppColors.lumiBluePrimary),
                  borderRadius: BorderRadius.circular(8 * r),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8 * w),
        Container(
          height: 40 * h,
          width: 40 * w,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.white_234),
              borderRadius: BorderRadius.circular(8 * r),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                useSafeArea: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28 * r),
                        topRight: Radius.circular(28 * r))),
                showDragHandle: true,
                backgroundColor: Colors.white,
                context: context,
                builder: (BuildContext ctx) {
                  return Container(
                    child: CommonBottomModal(
                      modalLabelText:  translation(context).selectDateRange,
                      body: filterType,
                    ),
                  );
                },
              );
            },
            child: Center(child: Icon(Icons.filter_alt_outlined)),
          ),
        ),
      ],
    );
  }
}
