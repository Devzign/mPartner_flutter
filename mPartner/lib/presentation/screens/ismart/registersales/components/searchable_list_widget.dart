import 'package:flutter/material.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../intermediary_sales/components/electrician_list_widget.dart';
import '../secondarysales/components/dealer_list_widget.dart';
import '../uimodels/dealer_info.dart';
import '../uimodels/electrician_info.dart';
import 'custom_bs_header.dart';

class SearchableListWidget extends StatefulWidget {
  final Function(DealerInfo)? onDealerSelected;
  final Function(ElectricianInfo)? onElectricianSelected;
  final String saleType;

  const SearchableListWidget({
    this.onDealerSelected,
    this.onElectricianSelected,
    required this.saleType,
    super.key,
   });

  @override
  State<SearchableListWidget> createState() => _SearchableListWidgetState();
}

class _SearchableListWidgetState extends State<SearchableListWidget> {
  TextEditingController _searchController = TextEditingController();

  void _handleDealerSelected(DealerInfo dealerInfo) {
    widget.onDealerSelected!(dealerInfo); // Invoke the callback passed from the parent
  }

  void _handleElectricianSelected(ElectricianInfo electricianInfo) {
    widget.onElectricianSelected!(electricianInfo); // Invoke the callback passed from the parent
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBSHeaderWidget(
            title: '${translation(context).chooseYour} ${widget.saleType=="Secondary"?
            translation(context).dealer:translation(context).electrician}',
            onClose: ()=>Navigator.of(context).pop(),),
          SizedBox(height: 10*variablePixelHeight,),
          Container(
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
          SizedBox(height: variablePixelHeight*10,),
          widget.saleType == "Intermediary"?
            ElectricianListWidget(searchQuery: _searchController.text,
                onElectricianSelected: _handleElectricianSelected):
          DealerListWidget(searchQuery: _searchController.text,
            onDealerSelected: _handleDealerSelected,)
        ]);
  }
}
