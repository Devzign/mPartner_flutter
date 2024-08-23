import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';

class RadioOptionWidget extends StatefulWidget {
  final List<String> optionsList;
  final void Function(String, int) onOptionSelected;
  final int selectedIndex;

  RadioOptionWidget({
    required this.optionsList,
    required this.onOptionSelected,
    required this.selectedIndex,
  });

  @override
  State<RadioOptionWidget> createState() =>
      _RadioOptionWidgetState();
}

class _RadioOptionWidgetState extends State<RadioOptionWidget> {
  String selectedOption = "";
  int selectedOptionIndex = -1;

  @override
  void initState() {
    super.initState();
    selectedOptionIndex = widget.selectedIndex;
    if( selectedOptionIndex == 0 )
      selectedOption = 'A';
    if( selectedOptionIndex == 1 )
      selectedOption = 'B';
    if( selectedOptionIndex == 2 )
      selectedOption = 'C';
    if( selectedOptionIndex == 3 )
      selectedOption = 'D';
    if( selectedOptionIndex == 4 )
      selectedOption = 'E';
  }

  @override
  void didUpdateWidget(covariant RadioOptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedOption = "";
    selectedOptionIndex = -1;

    selectedOptionIndex = widget.selectedIndex;
    if( selectedOptionIndex == 0 )
      selectedOption = 'A';
    if( selectedOptionIndex == 1 )
      selectedOption = 'B';
    if( selectedOptionIndex == 2 )
      selectedOption = 'C';
    if( selectedOptionIndex == 3 )
      selectedOption = 'D';
    if( selectedOptionIndex == 4 )
      selectedOption = 'E';
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.optionsList!.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(
              top: 8 * h,
              bottom: 8 * h
          ),
          child: Row(
            children: [
              Radio(
                activeColor: AppColors.lumiBluePrimary,
                //groupValue: selectedOption,
                value: index,
                groupValue: selectedOptionIndex,
                onChanged: (value) {
                  setState(() {
                    selectedOptionIndex = value as int;
                    if( selectedOptionIndex == 0 )
                      selectedOption = 'A';
                    if( selectedOptionIndex == 1 )
                      selectedOption = 'B';
                    if( selectedOptionIndex == 2 )
                      selectedOption = 'C';
                    if( selectedOptionIndex == 3 )
                      selectedOption = 'D';
                    if( selectedOptionIndex == 4 )
                      selectedOption = 'E';

                    widget.onOptionSelected(selectedOption, selectedOptionIndex);
                  });
                },
                materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity
                ),
              ),
              SizedBox(width: 7 * w),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOptionIndex = index as int;
                      if( selectedOptionIndex == 0 )
                        selectedOption = 'A';
                      if( selectedOptionIndex == 1 )
                        selectedOption = 'B';
                      if( selectedOptionIndex == 2 )
                        selectedOption = 'C';
                      if( selectedOptionIndex == 3 )
                        selectedOption = 'D';
                      if( selectedOptionIndex == 4 )
                        selectedOption = 'E';

                      widget.onOptionSelected(selectedOption, selectedOptionIndex);
                    });
                  },
                  child: Text(
                      widget.optionsList![index],
                      style: GoogleFonts.poppins(
                        color: AppColors.darkText2,
                        fontSize: 16 * f,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.50,
                      )
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}