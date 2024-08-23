




import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../presentation/lms_video_categeory_list.dart';
import '../presentation/training_course_list.dart';
import 'app_text_style.dart';

class TrainingListView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(child: ListView.builder(
         shrinkWrap: true,
         itemCount: 10,
         padding: EdgeInsets.all(15),
         itemBuilder:(context,int index){
         return new
         InkWell(child: Container(
           padding: EdgeInsets.all(10),
           margin: EdgeInsets.all(10),
           decoration: new BoxDecoration(
             borderRadius: new BorderRadius.circular(5),
             border: new Border.all(width: .5,color: AppColors.grey),

           ),
           child: new Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               new Container(
                 child: new Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     new Container(
                     decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(3),
                     border: new Border.all(width: .5,color: AppColors.grey)
                     ),
                     child: Image.asset("assets/mpartner/warrantyPlaceholder.png"),width: 60,height: 60,),
                     new SizedBox(width: 10,),
                     Expanded(child: new Container(
                       child: new Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           new Text("Understanding Solar System",style: AppTextStyle.getStyle(color: AppColors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                           new SizedBox(height: 3,),
                           new Text("2.5 hours | 2 Sessions",style: AppTextStyle.getStyle(color: AppColors.grey,fontSize: 13,fontWeight: FontWeight.w400),),

                         ],),)),
                     new SizedBox(width: 10,),
                     new Container(
                       alignment: Alignment.center,
                       width: 80,height: 35,child: new Text("₹ 876",style: AppTextStyle.getStyle(color: AppColors.lumiBluePrimary,fontSize: 16,fontWeight: FontWeight.w600),),decoration: new BoxDecoration(
                         borderRadius: new BorderRadius.circular(30),
                         color: AppColors.lumiLight4
                     ),)
                   ],
                 ),
               ),
               new Container(margin: EdgeInsets.only(top: 10,bottom: 10),child: new Text("Available session options",style: AppTextStyle.getStyle(color: AppColors.grey,fontSize: 12,fontWeight: FontWeight.w400),),),
               new Container(child: new Row(
                 children: [
                   Expanded(child: new Container(
                     height: 30,
                     alignment: Alignment.center,
                     decoration: new BoxDecoration(
                         borderRadius: new BorderRadius.circular(30),
                         border: new Border.all(width: .5,color: AppColors.grey)
                     ),
                     child: new Text("Live",textAlign: TextAlign.center,style: AppTextStyle.getStyle(color: AppColors.black,fontSize: 12,fontWeight: FontWeight.w500),),
                   )),
                   new SizedBox(width: 10,),
                   Expanded(child: new Container(
                     height: 30,
                     alignment: Alignment.center,
                     decoration: new BoxDecoration(
                         borderRadius: new BorderRadius.circular(30),
                         border: new Border.all(width: .5,color: AppColors.grey)
                     ),
                     child: new Text("Physical",textAlign: TextAlign.center,style: AppTextStyle.getStyle(color: AppColors.black,fontSize: 12,fontWeight: FontWeight.w500),),
                   )),
                   new SizedBox(width: 10,),
                   Expanded(child: new Container(
                     height: 30,
                     alignment: Alignment.center,
                     decoration: new BoxDecoration(
                         borderRadius: new BorderRadius.circular(30),
                         border: new Border.all(width: .5,color: AppColors.grey)
                     ),
                     child: new Text("Recorded",textAlign: TextAlign.center,style: AppTextStyle.getStyle(color: AppColors.black,fontSize: 12,fontWeight: FontWeight.w500),),
                   )),
                 ],
               ),)





             ],

           ),
         ),onTap: (){
             Get.to(LmsVideoCategeoryList());


         },)  ;


    }));
  }

}