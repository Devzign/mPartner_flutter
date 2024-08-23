import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../state/contoller/scheme_tab_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import 'title_bottom_modal.dart';

List<String> getListOfMonths() {
  int curr = DateTime.now().month;
  int setYear = 0;

  List<String>? result = <String>[
    'All',
    'Year ${DateTime.now().year.toString()}'
  ];

  if (curr == 12) {
    for (int i = 2; i <= 13; i++) {
      result.insert(i, _getMonthName(curr, setYear));
      curr--;
    }
  } else {
    for (int i = 2; i <= 14 && curr > 0; i++) {
      result.insert(i, _getMonthName(curr, setYear));
      curr--;
      if (curr == 0) {
        i++;
        result.insert(i, 'Year ${(DateTime.now().year - 1).toString()}');
        curr = 12;
        setYear = 1;
      }
    }
  }

  return result;
}

String _getMonthName(int month, int setYear) {
  // Convert the numeric month to its name
  switch (month) {
    case 1:
      return 'January ${DateTime.now().year - setYear}';
    case 2:
      return 'February ${DateTime.now().year - setYear}';
    case 3:
      return 'March ${DateTime.now().year - setYear}';
    case 4:
      return 'April ${DateTime.now().year - setYear}';
    case 5:
      return 'May ${DateTime.now().year - setYear}';
    case 6:
      return 'June ${DateTime.now().year - setYear}';
    case 7:
      return 'July ${DateTime.now().year - setYear}';
    case 8:
      return 'August ${DateTime.now().year - setYear}';
    case 9:
      return 'September ${DateTime.now().year - setYear}';
    case 10:
      return 'October ${DateTime.now().year - setYear}';
    case 11:
      return 'November ${DateTime.now().year - setYear}';
    case 12:
      return 'December ${DateTime.now().year - setYear}';
    default:
      return 'Unknown ${DateTime.now().year - setYear}';
  }
}

class MonthSelector extends StatelessWidget {
  MonthSelector({super.key});

  final List<String>? listItemsofMonths = getListOfMonths();

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return ListView.separated(
      shrinkWrap: true,
      itemCount: listItemsofMonths!.length,
      itemBuilder: (BuildContext context, int index) {
        if (listItemsofMonths![index].startsWith("Year")) {
          return monthContainers(
            color: AppColors.lumiLight4,
            text: listItemsofMonths![index],
            style: GoogleFonts.poppins(
              color: AppColors.darkGrey,
              fontSize: 18 * f,
              height: 24 / 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.50 * w,
            ),
          );
        } else {
          return monthContainers(
            color: Colors.white,
            text: listItemsofMonths![index],
            style: GoogleFonts.poppins(
              color: AppColors.darkGrey,
              fontSize: 16 * f,
              height: 24 / 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.50 * w,
            ),
          );
        }
      },
      separatorBuilder: (context, builder) {
        return SizedBox(
          height: 5 * h,
        );
      },
    );
  }
}

String formatText(String test) {
  if (test.startsWith("Year")) {
    return test;
  } else
    return test.split(' ')[0];
}

class monthContainers extends StatelessWidget {
  monthContainers({
    super.key,
    required this.color,
    required this.text,
    required this.style,
  });

  
  final String text;
  final Color color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return GestureDetector(
      onTap: () async {
        if (!text.startsWith("Year")) {
          SchemeTabController schemeTabController = Get.find();
          schemeTabController.currMonth.value = text;

          Navigator.pop(context);
        }
      },
      child: Container(

        color: color,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24 * w, vertical: 8 * h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formatText(text), style: style),
            ],
          ),
        ),
      ),
    );
  }
}

class monthBottomText extends StatelessWidget {
  const monthBottomText({super.key});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      child: Text(
        AppStringProducts.monthBottomText,
        style: GoogleFonts.poppins(
          color: AppColors.hintColor,
          fontSize: 12 * f,
          height: 24 / 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.50 * w,
        ),
      ),
    );
  }
}

class monthSelectorBody extends StatelessWidget {
  const monthSelectorBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * w),
            child: titleBottomModal(
              title: translation(context).selectMonth,
              onPressed: () => {Navigator.pop(context)},
            ),
          ),
          VerticalSpace(height: 12),
          Flexible(flex: 1, child: MonthSelector()),
          Container(
            width: double.maxFinite,
            child: Padding(
                padding: EdgeInsets.fromLTRB(24 * w, 0, 0, 22 * h),
                child: monthBottomText()),
          ),
          VerticalSpace(height: 16),
        ],
      ),
    );
  }
}
