


import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'app_text_style.dart';

class TabHeader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(20),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           new Container(child: new Row(
            children: [
              Expanded(child: new Container(
                child: new Text("Luminous Power Inverter Overview",style: AppTextStyle.getStyle(color: AppColors.black,fontSize: 16,fontWeight: FontWeight.w600)),
              )),
              new Container(
                padding: EdgeInsets.only(top: 5,bottom: 5),
                alignment: Alignment.center,
                width: 80,child: new Text("₹ 876",style: AppTextStyle.getStyle(color: AppColors.lumiBluePrimary,fontSize: 16,fontWeight: FontWeight.w600),),decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(30),
                  color: AppColors.lumiLight4
              ),),
            ],
          ),),
           new SizedBox(height: 5,),
           new Container(child: new Text("2.5 hours",style: AppTextStyle.getStyle(color: AppColors.grey,fontSize: 14,fontWeight: FontWeight.w400),)),
           new SizedBox(height: 5,),
           new Container(child: new Text("About this course",style: AppTextStyle.getStyle(color: AppColors.black,fontSize: 14,fontWeight: FontWeight.w600))),
           new SizedBox(height: 5,),
           new Container(child: new Text("Lorem ipsum dolor sit amet consectetur. Leo id cursus urna enim est ut. Nullam massa nec utdiam sem.",style: AppTextStyle.getStyle(color: AppColors.grey,fontSize: 14,fontWeight: FontWeight.w300))),
        ],
      ),
    );
  }

}