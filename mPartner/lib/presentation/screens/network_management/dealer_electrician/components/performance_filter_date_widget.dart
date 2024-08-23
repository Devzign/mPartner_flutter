import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/common_bottom_sheet.dart';
import '../../../../widgets/common_date_picker_widget.dart';
import '../../../ismart/registersales/uimodels/dealer_info.dart';
import '../../../../../data/models/network_management_model/state_city_district_info.dart';
import 'city_list_widget.dart';
import 'common_network_utils.dart';
import 'custom_calender.dart';
import 'govt_id_type_selection_widget.dart';
DateTime selectedDate=DateTime.now();
class DateRangeFilterWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Icon icon;
  final String stateId;
  final String dropDownType;
  final String? userType;
  final String? errorText;
  final  TextEditingController? textEditController;
  final Function(String, String)? onDateSelected;
  final Function(dynamic, String)? onDropDownSelected;
  final Function(String, String)? onDobSelected;
  final Function(DistrictInfo, String)? onDealerSelected;

  const DateRangeFilterWidget({required this.labelText,
    required this.hintText,
    required this.icon,
    required this.dropDownType,
    required this.onDateSelected,
    required this.onDealerSelected,
    this.stateId="",
    this.userType,
    this.onDropDownSelected,
    this.onDobSelected,
    this.textEditController,
    this. errorText,
    super.key});

  @override
  State<DateRangeFilterWidget> createState() => _DateRangeFilterWidgetState();
}

class _DateRangeFilterWidgetState extends State<DateRangeFilterWidget> {
  TextEditingController textEditingController = TextEditingController();
  late double variablePixelHeight;
  late double variablePixelWidth;
  late double variablePixelMultiplier;
  late double variableTextMultiplier;
  late String userType;
  DateTime initialSelectedDate=DateTime.now();
  CreateDealerElectricianController controller= Get.find();


  @override
  void initState() {
    super.initState();
  }


  void _handleTap() async {

     /* await showCustomDateRangePicker(
        context: context,
        initialDateRange:DateTimeRange(start: DateTime.now(),end: DateTime.now()),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime.now(),
        helpText: translation(context).selectDateValue,
      );*/
      if(selectedDate!=null) {
        initialSelectedDate = selectedDate;
        List<String> splitDate = selectedDate.toString().split(" ")[0].split("-");
        controller.dobTextEditController.text="${splitDate[2]}/${splitDate[1]}/${splitDate[0]}";
        textEditingController.text =
        "${splitDate[2]}/${splitDate[1]}/${splitDate[0]}";
        widget.onDateSelected!(selectedDate.toString(), widget.dropDownType);

      }
      /* final DateTime? newDate = await showCustomDatePicker(
        context: context,
        initialDate:initialSelectedDate,
        firstDate: DateTime(1950, 1),
        lastDate: DateTime.now(),
        helpText: 'Select date',

      );
      if(newDate!=null) {
        initialSelectedDate = newDate!;
        List<String> splitDate = newDate.toString().split(" ")[0].split("-");
        widget.onDateSelected!(newDate.toString(), widget.dropDownType);
        textEditingController.text =
        "${splitDate[2]}/${splitDate[1]}/${splitDate[0]}";
      }*/



  }

  @override
  Widget build(BuildContext context) {
    variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    variablePixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    variableTextMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    final OutlineInputBorder enabledOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4 * variablePixelMultiplier)),
      borderSide: BorderSide(color: AppColors.dividerColor),
    );

    final OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4 * variablePixelMultiplier)),
      borderSide: BorderSide(color: AppColors.dividerColor),
    );

    return TextFormField(
      readOnly: true,
      onTap: _handleTap,
      style: GoogleFonts.poppins(
        fontSize: 14 * variableTextMultiplier,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.50,
      ),
      controller: textEditingController,
      decoration: InputDecoration(
        errorText: widget.errorText!.isNotEmpty ? widget.errorText : null,
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
            fontWeight: FontWeight.w400
        ),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.darkGreyText,
          fontSize: 14 * variableTextMultiplier,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          height: 0.15,
          letterSpacing: 0.50,
        ),
      ),
    );
  }
}
