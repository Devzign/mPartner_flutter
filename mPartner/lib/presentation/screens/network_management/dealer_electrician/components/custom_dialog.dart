
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';

class CustomDialog{
  static ProgressDialog? pr=null;


  static initLoadingDialog(BuildContext context){

    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double variableTextMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
   pr = ProgressDialog(context,type: ProgressDialogType.normal, isDismissible: false, showLogs: true,customBody: Container(
     height: 80*variablePixelHeight,
     width:300*variablePixelWidth,
     child: Center(child: Row(
       mainAxisAlignment:MainAxisAlignment.center,children: [
       CircularProgressIndicator(),
       SizedBox(width: 20,),
       Text(translation(context).submitData, style:GoogleFonts.poppins(
         fontSize: 14.0 ,
         letterSpacing: 0.10,
         height: 0.10,
         fontWeight: FontWeight.w400,
         color: AppColors.blackText,
       ),)
     ],),),
   ));

  }

 /* static dialogStyle(String message){
    pr?.style(
        message: translation(context).submitData,
        borderRadius: 5.0,
        backgroundColor: AppColors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 50.0,
        progressTextStyle:GoogleFonts.poppins(
      fontSize: 14.0 ,
      letterSpacing: 0.10,
      height: 0.10,
      fontWeight: FontWeight.w400,
      color: AppColors.blackText,
    ),
        messageTextStyle: GoogleFonts.poppins(
      fontSize: 14.0,
      letterSpacing: 0.10,
      height: 0.10,
      fontWeight: FontWeight.w400,
      color: AppColors.blackText,
    )
    );
  }*/

  static showLoadingDialog() async{
     pr?.show();
  }
  static hideDialog()async {
    await pr?.hide();
  }
}