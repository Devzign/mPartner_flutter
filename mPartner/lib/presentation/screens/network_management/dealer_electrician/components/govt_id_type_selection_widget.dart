import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/state_city_district_info.dart';
import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import 'search_header.dart';


class GovtIdTypeSelectOptionWidget extends StatefulWidget {
  final Function(GovtIdTypeInfo) onItemSelected;
  final String? contentTiltle;

  const GovtIdTypeSelectOptionWidget(
      { required this.onItemSelected, this.contentTiltle,super.key});

  @override
  State<GovtIdTypeSelectOptionWidget> createState() => _GovtIdTypeSelectOptionWidgetState();
}

class _GovtIdTypeSelectOptionWidgetState extends State<GovtIdTypeSelectOptionWidget> {
  TextEditingController _searchController = TextEditingController();

  String contentTiltle="";
  CreateDealerElectricianController controller=Get.find();
  @override
  void initState() {
    contentTiltle=widget.contentTiltle!;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    var textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      margin: EdgeInsets.only(left: 10*variablePixelWidth),

      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SearchHeaderWidget(
          title: contentTiltle,
          onClose: () => Navigator.of(context).pop(),
        ),

        Container(
          width: variablePixelHeight * 392,
          padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20*variablePixelHeight,),
              Container(
                height:controller.govtIdTypeList.length*50*variablePixelHeight,
                child: ListView.builder(
                    itemCount: controller.govtIdTypeList.length,
                    itemBuilder: (context,index){
                  return Container(
                    width: variablePixelWidth * 245,
                    height: variablePixelHeight * 34,
                    margin: EdgeInsets.only(top: 10*variablePixelHeight,bottom: 10*variablePixelHeight),
                    child: GestureDetector(
                      onTap: (){
                          widget.onItemSelected(controller.govtIdTypeList[index]);
                      },
                      child: Text(
                        controller.govtIdTypeList[index].name!,
                        style: GoogleFonts.poppins(
                          color: AppColors.blackText.withOpacity(0.8),
                          fontStyle: FontStyle.normal,
                          fontSize: 16 * textMultiplier,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 20 * variablePixelHeight,
              ),

            ],
          ),
        ),
      ]),
    );
  }
}
