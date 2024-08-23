


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../presentation/screens/cashredemption/widgets/continue_button.dart';
import '../../../../utils/localdata/language_constants.dart';

class Success_Sheet  extends StatelessWidget{
  String? title;
  String?message;
  Success_Sheet(this.title, this.message);

  @override
  Widget build(BuildContext context) {
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Container(
                  height: 40,
                  child:  Text(title.toString(),style: GoogleFonts.poppins(color: AppColors.darkGrey, fontSize: 17 * textMultiplier, height: 21 / 14, fontWeight: FontWeight.w700,),),
                ),
                Divider(height: 1,),
                 SizedBox(height: 20,),
                Text(
                  message.toString(),
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),margin: EdgeInsets.only(left: 25,right: 25),),
             Container(
              child: ContinueButton(
              isEnabled:true,
              containerBackgroundColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              }, buttonText: translation(context).done,
            ),margin: EdgeInsets.only(top: 50),)
          ],
        ),
      ),width: MediaQuery.of(context).size.width,);
  }

}