import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/utils.dart';
import '../../../data/models/gem_auth_detail_model.dart';
import '../../../utils/levelwithvalue.dart';

class GemAuthDetailWidget extends StatelessWidget{
  GemAuthDetailModel? datalist;
  String? authcode;
  GemAuthDetailWidget(this.datalist,this. authcode);

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    //datalist!.validity = "Expired";

    return Card(
      elevation: 0,
      shadowColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0 *r),
      ),
      color: AppColors.grey97,
      margin: EdgeInsets.fromLTRB(24 * variablePixelWidth,0, 24 * variablePixelWidth, 24 * variablePixelHeight),

      child:Padding(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
            Text(translation(context).authorizationcodeDetails,
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 16 * textMultiplier,
                  fontWeight: FontWeight.w600,)),
            SizedBox(height: 15,),
            Divider(height: 1,color: AppColors.white_234,),
            SizedBox(height: 15,),
            new Container(
              child: new Row(
                children: [
                  Expanded(child: Container(child: new Text(authcode.toString()!="null"&&authcode.toString()!=""?authcode.toString():"Code not created",style: GoogleFonts.poppins(color: AppColors.black, fontSize: 14 * textMultiplier, fontWeight: FontWeight.w600,)),)),
                  if(authcode.toString()!="null"&&authcode.toString()!="" && authcode.toString()!="Code not created" && datalist!.validity != "Expired") InkWell(child: new Container(
                    height: 30,
                    width: 30,decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(100),
                      border: new Border.all(width: 1,color: AppColors.grey)
                  ),
                    child: new Icon(Icons.copy,color: AppColors.grey,size: 15,),),onTap: (){
                    Utils().copyText(authcode.toString(), context);
                  },),

                ],
              ),margin: EdgeInsets.only(top: 0,bottom: 5),),

             LevelWithValue(lavel: translation(context).validity, value: Utils().getFormattedDateMonth(datalist!.validity.toString())),
            LevelWithValue(lavel: translation(context).firmName, value: datalist!.firmName.toString()),
            LevelWithValue(lavel: translation(context).mobileNumber, value: datalist!.mobile_Number.toString(),),
            LevelWithValue(lavel: translation(context).emailId, value: datalist!.email_ID.toString(),),
            LevelWithValue(lavel: translation(context).address, value: datalist!.address.toString(),),
            LevelWithValue(lavel: translation(context).state, value: datalist!.state.toString(),),
            LevelWithValue(lavel: translation(context).city, value: datalist!.city.toString(),),
            LevelWithValue(lavel: translation(context).gstinnumber, value: datalist!.gstiN_Number.toString(),),
            Container(child: Row(
              children: [
                Expanded(child: new Container(child:  Text(translation(context).authorizationcodestatus,style: GoogleFonts.poppins(color: AppColors.darkGreyText, fontSize: 12 * textMultiplier, fontWeight: FontWeight.w400,)),)),
                if(datalist!.authCodeStatus.toString()=="Rejected")SvgPicture.asset("assets/mpartner/cancel.svg",height: 20,),
                if(datalist!.authCodeStatus.toString()=="In Progress")SvgPicture.asset("assets/mpartner/pending.svg",height: 20,),
                if(datalist!.authCodeStatus.toString()=="Received" && datalist!.validity != "Expired") SvgPicture.asset("assets/mpartner/check_circle.svg",height: 20,),
                new SizedBox(width: 10,),
                Text(datalist!.authCodeStatus.toString(), style: GoogleFonts.poppins(
                  color:datalist!.authCodeStatus.toString()=="In Progress"? AppColors.pendingYellow:datalist!.authCodeStatus.toString()=="Received"&& datalist!.validity != "Expired"? AppColors.green:datalist!.authCodeStatus.toString()=="Rejected"?AppColors.red:AppColors.black,
                  fontSize: 13 * textMultiplier,
                  fontWeight: FontWeight.w500,)),

              ],
            ),margin: EdgeInsets.only(top: 10,bottom: 10),),

            if(datalist!.authCodeStatus.toString()=="Recieved" && datalist!.validity != "Expired")  LevelWithValue(lavel: translation(context).codevaliditydate, value: datalist!.validity.toString(),)
            else LevelWithValue(lavel: translation(context).reason, value: datalist!.reason.toString(),)




          ],
        ),padding: EdgeInsets.all(12.0 * r),),);
  }


}