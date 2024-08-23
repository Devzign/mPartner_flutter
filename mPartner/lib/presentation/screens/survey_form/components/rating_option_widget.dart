import 'package:flutter/material.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';

class RatingOptionWidget extends StatefulWidget {
  final void Function(String, int) onStarOptionSelected;
  final int selectedIndex;

  RatingOptionWidget({
    required this.onStarOptionSelected,
    required this.selectedIndex,
  });

  @override
  State<RatingOptionWidget> createState() => _RatingOptionWidgetState();
}

class _RatingOptionWidgetState extends State<RatingOptionWidget> {
  int selectedStar = 0;
  String selectedRating = "";

  @override
  void initState() {
    super.initState();
    selectedStar = widget.selectedIndex;
    if( selectedStar == 1 )
      selectedRating = 'A';
    if( selectedStar == 2 )
      selectedRating = 'B';
    if( selectedStar == 3 )
      selectedRating = 'C';
    if( selectedStar == 4 )
      selectedRating = 'D';
    if( selectedStar == 5 )
      selectedRating = 'E';
  }

  @override
  void didUpdateWidget(covariant RatingOptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedStar = 0;
    selectedRating = "";

    selectedStar = widget.selectedIndex;
    if( selectedStar == 1 )
      selectedRating = 'A';
    if( selectedStar == 2 )
      selectedRating = 'B';
    if( selectedStar == 3 )
      selectedRating = 'C';
    if( selectedStar == 4 )
      selectedRating = 'D';
    if( selectedStar == 5 )
      selectedRating = 'E';
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Padding(
      padding: EdgeInsets.only(top: 12 * h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedStar = index + 1;
                if( selectedStar == 1 )
                  selectedRating = 'A';
                if( selectedStar == 2 )
                  selectedRating = 'B';
                if( selectedStar == 3 )
                  selectedRating = 'C';
                if( selectedStar == 4 )
                  selectedRating = 'D';
                if( selectedStar == 5 )
                  selectedRating = 'E';
                //selectedRating = selectedStar.toString();
                widget.onStarOptionSelected(selectedRating, selectedStar);
              });
            },
            child: Container(
              width: 44 * w,
              height: 44 * h,
              decoration: ShapeDecoration(
                color: index < selectedStar
                    ? AppColors.yellowStar
                    : AppColors.lightGrey1,
                shape: StarBorder(
                  points: 5,
                  innerRadiusRatio: 0.38,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}