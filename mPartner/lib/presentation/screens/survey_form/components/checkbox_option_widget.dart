import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';

class CheckboxOptionWidget extends StatefulWidget {
  final List<String> optionsList;
  final void Function(String, int) onOptionsSelected;
  final int selectedIndex;

  CheckboxOptionWidget({
    required this.optionsList,
    required this.onOptionsSelected,
    required this.selectedIndex,
  });

  @override
  State<CheckboxOptionWidget> createState() => _CheckboxOptionWidgetState();
}

class _CheckboxOptionWidgetState extends State<CheckboxOptionWidget> {
  String selectedOptions = "";
  List<int> selectedOptionIndices = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex != -1) {
      String selectedIndexString = widget.selectedIndex.toString();
      for (int i = 0; i < selectedIndexString.length; i++) {
        int index = int.parse(selectedIndexString[i]);
        selectedOptionIndices.add(index);

        switch (index) {
          case 0:
            selectedOptions += 'A';
            break;
          case 1:
            selectedOptions += 'B';
            break;
          case 2:
            selectedOptions += 'C';
            break;
          case 3:
            selectedOptions += 'D';
            break;
          case 4:
            selectedOptions += 'E';
            break;
          default:
            selectedOptions += '';
        }
      }
    } else {
      selectedOptionIndices = [];
    }
  }

  @override
  void didUpdateWidget(covariant CheckboxOptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedOptions = "";
    selectedOptionIndices = [];

    if (widget.selectedIndex != -1) {
      String selectedIndexString = widget.selectedIndex.toString();
      for (int i = 0; i < selectedIndexString.length; i++) {
        int index = int.parse(selectedIndexString[i]);
        selectedOptionIndices.add(index);

        switch (index) {
          case 0:
            selectedOptions += 'A';
            break;
          case 1:
            selectedOptions += 'B';
            break;
          case 2:
            selectedOptions += 'C';
            break;
          case 3:
            selectedOptions += 'D';
            break;
          case 4:
            selectedOptions += 'E';
            break;
          default:
            selectedOptions += '';
        }
      }
    } else {
      selectedOptionIndices = [];
    }
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
      itemCount: widget.optionsList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(
              top: 8 * h,
              bottom: 8 * h
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                  activeColor: AppColors.lumiBluePrimary,
                  value: selectedOptionIndices.contains(index),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedOptionIndices.add(index);

                        if(index == 0)
                          selectedOptions += 'A';
                        else if(index == 1)
                          selectedOptions += 'B';
                        else if(index == 2)
                          selectedOptions += 'C';
                        else if(index == 3)
                          selectedOptions += 'D';
                        else if(index == 4)
                          selectedOptions += 'E';
                      } else {
                        selectedOptionIndices.remove(index);

                        if(index == 0)
                          selectedOptions = selectedOptions.replaceAll('A', '');
                        else if(index == 1)
                          selectedOptions = selectedOptions.replaceAll('B', '');
                        else if(index == 2)
                          selectedOptions = selectedOptions.replaceAll('C', '');
                        else if(index == 3)
                          selectedOptions = selectedOptions.replaceAll('D', '');
                        else if(index == 4)
                          selectedOptions = selectedOptions.replaceAll('E', '');
                      }
                      String selectedOptionIndicesString = selectedOptionIndices.join('');
                      widget.onOptionsSelected(selectedOptions, int.parse(selectedOptionIndicesString));
                    });
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      if (!selectedOptionIndices.contains(index)) {
                        selectedOptionIndices.add(index);

                        if(index == 0)
                          selectedOptions += 'A';
                        else if(index == 1)
                          selectedOptions += 'B';
                        else if(index == 2)
                          selectedOptions += 'C';
                        else if(index == 3)
                          selectedOptions += 'D';
                        else if(index == 4)
                          selectedOptions += 'E';
                      } else {
                        selectedOptionIndices.remove(index);

                        if(index == 0)
                          selectedOptions = selectedOptions.replaceAll('A', '');
                        else if(index == 1)
                          selectedOptions = selectedOptions.replaceAll('B', '');
                        else if(index == 2)
                          selectedOptions = selectedOptions.replaceAll('C', '');
                        else if(index == 3)
                          selectedOptions = selectedOptions.replaceAll('D', '');
                        else if(index == 4)
                          selectedOptions = selectedOptions.replaceAll('E', '');
                      }
                      String selectedOptionIndicesString = selectedOptionIndices.join('');
                      if (selectedOptionIndicesString.length >= 2 && selectedOptionIndicesString[0] == "0") {
                        selectedOptionIndicesString = selectedOptionIndicesString.substring(1) + "0";
                      }
                      widget.onOptionsSelected(selectedOptions, int.parse(selectedOptionIndicesString));
                    });
                  },
                  child: Text(
                    widget.optionsList[index],
                    style: GoogleFonts.poppins(
                      color: AppColors.darkText2,
                      fontSize: 16 * f,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.50,
                    ),
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