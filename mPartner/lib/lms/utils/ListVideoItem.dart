


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart';
import 'app_text_style.dart';

class ListVideoItem extends StatelessWidget{
  int? index;
  ListVideoItem(this.index);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new
      Card(
      elevation: .3,
      color: Colors.white,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(top: 10),
      child: Container(
      padding: EdgeInsets.all(10),
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(10),
          color: AppColors.white
      ),
      child: new Row(
        children: [
          new Container(
            height: 50,
            width: 50,
            child: Icon(Icons.play_arrow,color: Colors.white,size: 30,),decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(100),
              color: AppColors.lumiBluePrimary
          ),),
          new SizedBox(width: 20,),
          Expanded(child: new Container(child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Text("Introduction to Power Inverter",style: AppTextStyle.getStyle(color: AppColors.black,fontSize: 14,fontWeight: FontWeight.w500),),
              new SizedBox(height: 3,),
              new Text("82 mins",style: AppTextStyle.getStyle(color: AppColors.grey,fontSize: 13,fontWeight: FontWeight.w400),),

            ],
          ),)),
          new SizedBox(width: 20,),
          SvgPicture.asset("assets/mpartner/check_circle.svg",color: AppColors.greenTick,)
        ],
      ),
    ),);
  }

}