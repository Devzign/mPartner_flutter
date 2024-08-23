

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../state/contoller/app_setting_value_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';

class DeleteOption extends StatelessWidget{
  AppSettingValueController appSettingValueController = Get.find();
  Function()delete;
  DeleteOption({required this.delete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       delete();
      },
      child: Text(
        translation(context).deleteOptionText,

        style: GoogleFonts.poppins(
          color:appSettingValueController.getAccountDeleted.value.toString()!="1"? AppColors.red:AppColors.grey,
          fontSize: 15,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10,
        ),
      ),
    );

  }


}