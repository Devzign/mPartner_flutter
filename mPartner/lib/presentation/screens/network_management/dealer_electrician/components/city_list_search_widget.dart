import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/state_city_district_info.dart';
import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';

class CityListSearchWidget extends StatefulWidget {
  final String searchQuery;
  final Function(CityInfo) onDealerSelected;
  const CityListSearchWidget({required this.searchQuery,
    required this.onDealerSelected,super.key});

  @override
  State<CityListSearchWidget> createState() => _CityListSearchWidgetState();
}

class _CityListSearchWidgetState extends State<CityListSearchWidget> {
  List<CityInfo> filteredStateList=[];
  void _handleOnDealerSelected(state){
    widget.onDealerSelected(state);
  }

  CreateDealerElectricianController controller=Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    var textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    filteredStateList = controller.cityList.where((state) {
      String query = widget.searchQuery.toLowerCase();
      String id = state.id!.toLowerCase();
      String name = state.name!.toLowerCase();
      return name.contains(query);
    }).toList();

    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${filteredStateList.length.toString()} ${translation(context).cityListed}",
          style: GoogleFonts.poppins(
            color: AppColors.grayText,
            fontSize: 14 * textMultiplier,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        Container(
          height: variablePixelHeight * 400,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: filteredStateList.length,
            itemBuilder: (context, index) {
              final stateList = filteredStateList[index];
              return InkWell(
                onTap: () => _handleOnDealerSelected(CityInfo(
                  id: stateList.id,
                  name: stateList.name,)),
                child: Container(
                  width: variablePixelHeight * 392,
                  padding: EdgeInsets.symmetric(vertical: 10 * variablePixelMultiplier),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${stateList.name}",
                        style: GoogleFonts.poppins(
                          color: AppColors.darkText2,
                          fontStyle: FontStyle.normal,
                          fontSize: 14 * textMultiplier,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.start,
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
