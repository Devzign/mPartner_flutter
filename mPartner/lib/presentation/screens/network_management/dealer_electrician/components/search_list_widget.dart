import 'package:flutter/material.dart';

import '../../../../../data/models/network_management_model/state_city_district_info.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'search_header.dart';
import 'state_list_widget.dart';

class SearchListWidget extends StatefulWidget {
  final Function(DistrictInfo) onItemSelected;
  const SearchListWidget( {required this.onItemSelected,super.key});

  @override
  State<SearchListWidget> createState() => _SearchListWidgetState();
}

class _SearchListWidgetState extends State<SearchListWidget> {
  TextEditingController _searchController = TextEditingController();

  void _handleStateSelected( stateInfo) {
    widget.onItemSelected(stateInfo); // Invoke the callback passed from the parent
  }

  @override
  Widget build(BuildContext context) {
    var variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus
                                    ?.unfocus(),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchHeaderWidget(
              title:translation(context).chooseDistrict,
              onClose: ()=>Navigator.of(context).pop(),),
            SizedBox(height: variablePixelHeight*10,),
      
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              constraints: BoxConstraints(maxHeight: variablePixelHeight * 100),
              height: variablePixelHeight * 50,
              decoration: BoxDecoration(
                color: AppColors.lumiBlue,
                borderRadius: BorderRadius.circular(8*variablePixelMultiplier),
              ),
              child: TextField(
                controller: _searchController,
                maxLength: 50,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  counterText: "",
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.iconColor,),
                  hintText: translation(context).search,
                  border: InputBorder.none, // Remove the default border
                ),
              ),
            ),
            SizedBox(height: variablePixelHeight*24,),
            StateListWidget(searchQuery: _searchController.text,
              onDealerSelected: _handleStateSelected)
          ]),
    );
  }
}
