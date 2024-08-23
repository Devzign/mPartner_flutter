import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/presentation/screens/ismart/registersales/components/searchable_list_widget.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../widgets/common_bottom_sheet.dart';
import '../../../../widgets/common_date_picker_widget.dart';
import '../uimodels/dealer_info.dart';
import '../uimodels/electrician_info.dart';

class DropdownBSWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Icon icon;
  final String dropDownType;
  final String saleType;
  final Function(DateTime, String)? onDateSelected;
  final Function(DealerInfo, String)? onDealerSelected;
  final Function(ElectricianInfo, String)? onElectricianSelected;

  const DropdownBSWidget({
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.dropDownType,
    required this.onDateSelected,
    this.onDealerSelected,
    this.onElectricianSelected,
    required this.saleType,
    super.key,
  });

  @override
  State<DropdownBSWidget> createState() => _DropdownBSWidgetState();
}

class _DropdownBSWidgetState extends State<DropdownBSWidget> {
  TextEditingController textEditingController = TextEditingController();
  late double variablePixelHeight;
  late double variablePixelWidth;
  late double variablePixelMultiplier;
  late double variableTextMultiplier;

  void _handleTap() async {
    
      if (widget.saleType == "Secondary") {
        if (widget.dropDownType == "DatePicker") {
      CommonBottomSheet.show(
          context,
          CommonDatePickerWidget(
            onDateSelected: (selectedDate) {
              setState(() {
                widget.onDateSelected!(selectedDate, widget.dropDownType);
                textEditingController.text =
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
              });
            },
            daysToEnable: 6,
          ),
          variablePixelHeight,
          variablePixelWidth);
    } else{
        CommonBottomSheet.show(
            context,
            SearchableListWidget(
              saleType: widget.saleType,
              onDealerSelected: (selectedDealer) {
                setState(() {
                  widget.onDealerSelected!(selectedDealer, widget.dropDownType);
                  textEditingController.text = selectedDealer.toString();
                  Navigator.of(context).pop();
                });
              },
            ),
            variablePixelHeight,
            variablePixelWidth);
      }
      } else {
        if(widget.dropDownType == "DatePicker") {
          CommonBottomSheet.show(
          context,
          CommonDatePickerWidget(
            onDateSelected: (selectedDate) {
              setState(() {
                widget.onDateSelected!(selectedDate, widget.dropDownType);
                textEditingController.text =
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
              });
            },
            daysToEnable: 6,
          ),
          variablePixelHeight,
          variablePixelWidth);
        }
        else{
          CommonBottomSheet.show(
            context,
            SearchableListWidget(
              saleType: widget.saleType,
              onElectricianSelected: (selectedElectrician) {
                setState(() {
                  widget.onElectricianSelected!(
                      selectedElectrician, widget.dropDownType);
                  textEditingController.text = selectedElectrician.toString();
                  Navigator.of(context).pop();
                });
              },
            ),
            variablePixelHeight,
            variablePixelWidth);
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    variableTextMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    final OutlineInputBorder enabledOutlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(4 * variablePixelMultiplier)),
      borderSide: BorderSide(color: AppColors.dividerColor),
    );

    final OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(4 * variablePixelMultiplier)),
      borderSide: BorderSide(color: AppColors.dividerColor),
    );

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 24 * variablePixelWidth,
            vertical: 14 * variablePixelHeight),
        child: Row(
          children: [
            Expanded(
              child: Container(
                constraints:
                    BoxConstraints(maxHeight: 66 * variablePixelHeight),
                child: TextFormField(
                  style: GoogleFonts.poppins(
                    color: AppColors.darkText2,
                    fontStyle: FontStyle.normal,
                    fontSize: 14 * variableTextMultiplier,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  readOnly: true,
                  onTap: _handleTap,
                  controller: textEditingController,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        12 * variablePixelWidth,
                        6 * variablePixelHeight,
                        18 * variablePixelWidth,
                        6 * variablePixelHeight),
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                    suffixIcon: widget.icon,
                    focusedBorder: focusedOutlineInputBorder,
                    enabledBorder: enabledOutlineInputBorder,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontStyle: FontStyle.normal,
                        fontSize: 14 * variableTextMultiplier,
                        fontWeight: FontWeight.w400),
                    labelStyle: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 14 * variableTextMultiplier,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 0.15,
                      letterSpacing: 0.50,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
