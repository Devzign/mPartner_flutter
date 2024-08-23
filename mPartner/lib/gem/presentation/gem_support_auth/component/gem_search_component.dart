


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class GemSearchComponent extends StatelessWidget{
  Function()filterClick;
  Function(String)onTyped;
  String title;
  GemSearchComponent({required this.filterClick,required this.onTyped,  required this.title});
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double fontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    return new
     Container(
        margin: EdgeInsets.fromLTRB(24.0 * variablePixelWidth,0, 24.0 * variablePixelWidth,10 * variablePixelHeight),
        height: 50,
      child: Row(
      children: [
           Expanded(child: TextFormField(onChanged: (String){
             onTyped(String);
           },decoration:InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 5),hintText: title,border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.white_234)),focusedBorder: OutlineInputBorder(borderSide:BorderSide(color: AppColors.white_234) ),enabledBorder: OutlineInputBorder(borderSide:BorderSide(color: AppColors.white_234) ),prefixIcon: Icon(Icons.search,color: AppColors.grey,)),)),
           new SizedBox(width: 10,),
           InkWell(onTap: (){
             filterClick();
           },child:new Container(padding: EdgeInsets.all(12),height: 50,decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(10), border: new Border.all(width: 1,color: AppColors.white_234,
           )), width: 50, child: new SvgPicture.asset("assets/mpartner/network/filter.svg",color:AppColors.black),),)
      ],
    ));
  }

}