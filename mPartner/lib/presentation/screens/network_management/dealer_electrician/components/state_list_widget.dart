import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/state_city_district_info.dart';
import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';


class StateListWidget extends StatefulWidget {
  final String searchQuery;
  final Function(DistrictInfo) onDealerSelected;
  const StateListWidget({required this.searchQuery,
    required this.onDealerSelected,super.key});

  @override
  State<StateListWidget> createState() => _StateListWidgetState();
}

class _StateListWidgetState extends State<StateListWidget> {
   List<DistrictInfo> filteredStateList=[];
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
    double variableTextMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
      filteredStateList = controller.districtList.where((state) {
        String query = widget.searchQuery.toLowerCase();
        String id = state.id!.toLowerCase();
        String name = state.name!.toLowerCase();
        return name.contains(query);
      }).toList();

    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${filteredStateList.length.toString()} ${translation(context).districtListed}",
            style: GoogleFonts.poppins(
              color: AppColors.grayText,
              fontSize: 14 * variableTextMultiplier,
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
                  onTap: () => _handleOnDealerSelected(DistrictInfo(
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
                            fontSize: 14 * variableTextMultiplier,
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
      ),
    );
  }
}
