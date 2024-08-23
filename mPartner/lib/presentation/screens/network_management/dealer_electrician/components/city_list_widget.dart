import 'package:flutter/material.dart';
import '../../../../../data/models/network_management_model/state_city_district_info.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'city_list_search_widget.dart';
import 'search_header.dart';

class CityListWidget extends StatefulWidget {
  final Function(CityInfo) onItemSelected;
  const CityListWidget( {required this.onItemSelected,super.key});

  @override
  State<CityListWidget> createState() => _CityListWidgetState();
}

class _CityListWidgetState extends State<CityListWidget> {
  TextEditingController _CityController = TextEditingController();

  void _handleStateSelected( cityInfo) {
    widget.onItemSelected(cityInfo); // Invoke the callback passed from the parent
  }

  @override
  Widget build(BuildContext context) {
    var variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),

      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchHeaderWidget(
              title:translation(context).chooseCity,
              onClose: ()=>Navigator.of(context).pop(),),
            Container(
              constraints: BoxConstraints(maxHeight: variablePixelHeight * 100),
              height: variablePixelHeight * 50,
              decoration: BoxDecoration(
                color: AppColors.lumiBlue,
                borderRadius: BorderRadius.circular(8*variablePixelMultiplier),
              ),
              child: TextField(
                controller: _CityController,
                maxLength: 50,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  counterText: "",
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.iconColor,),
                  hintText: translation(context).searchCity,
                  border: InputBorder.none, // Remove the default border
                ),
              ),
            ),
            SizedBox(height: variablePixelHeight*10,),
            CityListSearchWidget(searchQuery: _CityController.text,
                onDealerSelected: _handleStateSelected)
          ]),
    );
  }
}
