


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'app_text_style.dart';

class WidgetRecordedVideo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Expanded(child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        padding: EdgeInsets.all(15),
        itemBuilder:(context,int index){
          return new Container(
            child: new Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(child: new Container(
                      height: 150,
                      decoration: new BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/mpartner/Homepage_Assets/power.png",),
                              fit: BoxFit.cover
                          )
                      ),
                    ),borderRadius: new BorderRadius.circular(10),),
                    Image.asset("assets/mpartner/youtube.png",height: 40,),
                  ],
                ),
                new SizedBox(height: 20,),
                new Container(child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Container(padding: EdgeInsets.all(10),height: 50,width: 50,decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.lumiBluePrimary
                    ),child: Image.asset("assets/mpartner/Homepage_Assets/luminous_logo.png",color: Colors.white,),),
                    SizedBox(width: 20,),
                    Expanded(child: new Container(child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Text("Mastering Luminous: A Comprehensive Training Guide",style: AppTextStyle.getStyle(color: AppColors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                        new SizedBox(height: 10,),
                        new Text("#Illuminating Lives • 3M views",style: AppTextStyle.getStyle(color: AppColors.grey,fontSize: 14,fontWeight: FontWeight.w500),)
                      ],
                    ),))
                  ],
                ),),


                new SizedBox(height: 10,),
                Divider(height: 1,),
                new SizedBox(height: 20,),
              ],
            ),
          );
        }));
  }

}