import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/displaymethods/display_methods.dart';

import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../data/models/gem_auth_detail_model.dart';
import '../../../../state/controller/gem_auth_code_generate_controller.dart';
import '../../../../utils/levelwithvalue.dart';

class GstAuthGenerateDetailItem extends StatelessWidget{
  GstAuthGenerateDetailItem(this.model);
  GemCustomerDetailModel?model;
  GemAuthCodeGenerateController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixel = DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return Card(
      elevation: 0,
      shadowColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0 *r),
      ),
      color: AppColors.grey97,
      margin: EdgeInsets.fromLTRB(24 * variablePixelWidth,0, 24 * variablePixelWidth, 24 * variablePixelHeight),
      child:Padding(
        padding: EdgeInsets.all(12.0 * r),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(translation(context).authorizationcodeDetails,
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 16 * textMultiplier,
                  fontWeight: FontWeight.w600,)),
            SizedBox(height: 15,),
            Divider(height: 1,color: AppColors.white_234,),

            LevelWithValue(lavel:translation(context).firmName, value:model!.firmName.toString(),),
            LevelWithValue(lavel:translation(context).mobileNumber, value:model!.mobileNumber.toString(),),
            LevelWithValue(lavel:translation(context).emailId, value:model!.emailId.toString(),),
            LevelWithValue(lavel:translation(context).address, value:model!.address.toString(),),
            LevelWithValue(lavel:translation(context).state, value:model!.state.toString(),),
            LevelWithValue(lavel:translation(context).city, value:model!.city.toString(),),
            LevelWithValue(lavel:translation(context).gstinnumber, value:controller.gstNumber!=""?controller.gstNumber.toString():model!.gstNumber.toString(),),


          ],
        ),
      ));




  }

}