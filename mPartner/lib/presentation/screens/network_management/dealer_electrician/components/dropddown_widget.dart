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
import 'search_list_widget.dart';
import 'user_type_widget.dart';
DateTime selectedDate=DateTime.now();
class DropdownWidget extends StatefulWidget {
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

  const DropdownWidget({required this.labelText,
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
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  TextEditingController textEditingController = TextEditingController();
  late double variablePixelHeight;
  late double variablePixelWidth;
  late double variablePixelMultiplier;
  late double variableTextMultiplier;
  late String userType;
  DateTime initialSelectedDate= DateTime(DateTime.now().year-18, DateTime.now().month, DateTime.now().day);
  CreateDealerElectricianController controller= Get.find();


  @override
  void initState() {
    if(widget.dropDownType=="user_type") {
      userType = widget.userType!;
      textEditingController.text = widget.userType.toString();
    }
    super.initState();
  }


  void _handleTap() async {
    if(widget.dropDownType=="user_type"){
      CommonBottomSheet.show(
          context,
          UserTypeWidget(onItemSelected: (selectedState) {
            setState(() {
              widget.onDropDownSelected!(selectedState,widget.dropDownType);
              textEditingController.text = selectedState.toString();
              userType=selectedState;
              Navigator.of(context).pop();
            });
          } ,userType:userType),
          variablePixelHeight,
          variablePixelWidth
      );
    }
    else if (widget.dropDownType=="dob"){
   /* await showCustomDateRangePicker(
        context: context,
        initialDateRange:DateTimeRange(start: DateTime.now(),end: DateTime.now()),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime.now(),
        helpText: translation(context).selectDateValue,
        onSelectStartEndDate:(DateTimeRange onSelectStartEndDate){
            print("#### ${onSelectStartEndDate.start} ### ${onSelectStartEndDate.end}");
        },

      );*/
      await showCustomDatePicker(
        context: context,
        initialDate:initialSelectedDate,
        firstDate: DateTime(1950, 1,1),
        lastDate: DateTime(DateTime.now().year-18, DateTime.now().month, DateTime.now().day),
        helpText: translation(context).selectDateValue,
        onSelectedDate:(DateTime onSelectedDate){
          print("#### ${onSelectedDate}");
        },
      );
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
    else if (widget.dropDownType == "district") {
      CommonBottomSheet.show(
          context,
          SearchListWidget(onItemSelected: (selectedState) async{
            widget.textEditController!.text = selectedState.name!;
            controller.districtController.text=selectedState.name!;
            controller.selectedCity = null;
            controller.cityController.text = "";
            controller.cityList.clear();
            controller.isLoading.value=true;
            Navigator.of(context).pop();
            await controller.getCityList(selectedState);
            widget.onDropDownSelected!(selectedState,widget.dropDownType);
           /* setState(() {

            });*/
          } ,),

          variablePixelHeight,
          variablePixelWidth
      );
    }
    else if (widget.dropDownType == "govt_id_type") {
      CommonBottomSheet.show(
          context,
          GovtIdTypeSelectOptionWidget(
            contentTiltle: translation(context).govtIdType,
            onItemSelected: (selectedIdType) {
            setState(() {
              widget.onDropDownSelected!(selectedIdType,widget.dropDownType);
              textEditingController.text = selectedIdType.name!;
              controller.govtIdTypeController.text=selectedIdType.name!;
              Navigator.of(context).pop();
            });
          } ,),

          variablePixelHeight,
          variablePixelWidth
      );
    }

    else {
      if(controller.cityList.isNotEmpty) {
        CommonBottomSheet.show(
            context,
            CityListWidget(onItemSelected: (selectedCity) {
              setState(() {
                controller.selectedCity = selectedCity;
                widget.textEditController!.text = selectedCity.name!;
                controller.cityController.text = selectedCity.name!;
                widget.onDropDownSelected!(selectedCity, widget.dropDownType);
                Navigator.of(context).pop();
              });
            },),
            variablePixelHeight,
            variablePixelWidth
        );
      }
    }
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

    if(widget.dropDownType=="district"&&controller.districtController.text.trim().isNotEmpty){
      textEditingController.text=controller.districtController.text.trim();
    }
    if(widget.dropDownType=="city"&&controller.cityController.text.trim().isNotEmpty){
      textEditingController.text=controller.cityController.text.trim();
    }

    if(widget.dropDownType=="govt_id_type"&&controller.govtIdTypeController.text.trim().isNotEmpty){
      textEditingController.text=controller.govtIdTypeController.text.trim();
    }
  var  textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
        height: (widget.errorText!.isNotEmpty ? (85*variablePixelHeight) : (60 * variablePixelHeight)),
        child:(widget.dropDownType=="user_type")? TextFormField(
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
        contentPadding: widget.dropDownType=="user_type"? EdgeInsets.only(top: 5*variablePixelHeight,left: 10*variablePixelWidth):null,
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
    ):
   Obx(() =>
        TextFormField(
      readOnly: true,
      onTap: _handleTap,
      style: GoogleFonts.poppins(
        fontSize: 14 * variableTextMultiplier,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.50,
      ),
      controller:  widget.textEditController!,
      decoration: InputDecoration(
        errorText: widget.errorText!.isNotEmpty ? widget.errorText : null,
        label: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.labelText,
                style: GoogleFonts.poppins(
                  color: AppColors.blackText,
                  fontSize: 14 * textFontMultiplier,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.40,
                ),
              ),

                  TextSpan(
                text: '*',
                style: GoogleFonts.poppins(
                  color: AppColors.errorRed,
                  fontSize: 14 * textFontMultiplier,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.40,
                ),
              )
                 ,
            ],
          ),
        ),
        hintText: widget.hintText,
       suffixIcon: (controller.isLoading.value&&widget.dropDownType=="city")?Container(
          padding:EdgeInsets.all(12),
          height: 15,width: 15,
          child: CircularProgressIndicator()):widget.icon,
        contentPadding: widget.dropDownType=="user_type"? EdgeInsets.only(top: 5*variablePixelHeight,left: 10*variablePixelWidth):null,
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
    )
    ));
  }
}
