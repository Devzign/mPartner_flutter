



import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/presentation/widgets/verticalspace/vertical_space.dart';

import '../../../../../../data/models/booked_trip_details_model.dart';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../../../state/contoller/booked_trip_details_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../widgets/common_confirmation_alert.dart';
import '../../../../cashredemption/widgets/continue_button.dart';



class WidgetTravellerList extends StatefulWidget{
  RxList<TravellerDetail> bookedTravellers;
  int? tripID;
  WidgetTravellerList(this.bookedTravellers, this.tripID);



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WidgetTravellerList();
  }

}
class _WidgetTravellerList extends State<WidgetTravellerList>{
  String formattedStatusMessage(String message, BuildContext context) {
    if (message.contains("confirmed"))
      return 'Booked';
    else if (message.contains("waitlist")) {

      return message.toUpperFirstCase();
    } else
      return translation(context).bookingFailed;
  }

  Color seatStatusMessageColor(String message) {
    if (message.contains("confirmed"))
      return AppColors.successGreen;
    else if (message.contains("waitlist"))
      return AppColors.goldCoin;
    else
      return AppColors.errorRed;
  }

  List<TravellerDetail>filterList=[];
  filter_List(){
    widget.bookedTravellers.forEach((element) {
      if(element.isDelete_Show=="1"){
        filterList.add(element);
      }
    });
  }

  BookedTripDetailsController bookedTripDetailsController = Get.find();

  @override
  void initState() {
    filter_List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double f = DisplayMethods(context: context).getTextFontMultiplier();
   return Stack(
     children: [
       Column(
         children: [
           InkWell(child: new Container(
             height: 40,
             padding: EdgeInsets.only(left: 15,right: 15),
             child: new Row(
               children: [
                 Expanded(child: new Container(child: new Text(translation(context).deleteTravellar,style: GoogleFonts.poppins(color: AppColors.darkGrey, fontSize: 14 * f, height: 21 / 14, fontWeight: FontWeight.w700,)),)),
                 new SizedBox(width: 10,),
                 if(filterList.length>1)    new Text(translation(context).selectAll,style: GoogleFonts.poppins(color: AppColors.darkGrey, fontSize: 14 * f, height: 21 / 14, fontWeight: FontWeight.w700,)),
                 new SizedBox(width: 10,),
                 if(filterList.length>1) new Row(
                   children: [
                     filterList.where((model) => model.isChecked==true).toList().length==filterList.length?
                     Icon(Icons.check_box,color: AppColors.lumiBluePrimary,):Icon(Icons.check_box_outline_blank_outlined)
                   ],
                 )
               ],
             ),
           ),onTap: (){
             if(filterList.where((model) => model.isChecked==true).toList().length==filterList.length){
               filterList.forEach((element) {
                 element.isChecked=false;
               });
             }else{
               filterList.forEach((element) {
                 element.isChecked=true;
               });
             }


             setState(() {

             });

           },),
           Expanded(child: Container(
               child: ListView.separated(
                   shrinkWrap: true,
                   padding: EdgeInsets.all(15),
                   physics: AlwaysScrollableScrollPhysics(),
                   itemBuilder: (BuildContext context, int index) {
                     return Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         new Container(child: new Row(
                           children: [
                             Expanded(child: new Container(child: Text(
                               filterList[index].travellerName,
                               style: GoogleFonts.poppins(
                                 color: AppColors.darkGreyText,
                                 fontSize: 14 * f,
                                 fontWeight: FontWeight.w600,
                                 height: 24 / 16,
                               ),
                             ),)),
                             InkWell(child:filterList[index].isChecked==false? Icon(Icons.check_box_outline_blank_outlined):Icon(Icons.check_box,color: AppColors.lumiBluePrimary,),onTap: (){
                               setState(() {
                                 filterList[index].isChecked=!filterList[index].isChecked;
                               });
                             },)
                           ],
                         ),),
                         VerticalSpace(height: 4),
                         Visibility(
                           visible:filterList[index].relation.isNotEmpty,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               VerticalSpace(height: 4),
                               Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children:[
                                     Text(
                                       translation(context).relationship,
                                       style: GoogleFonts.poppins(
                                         color: AppColors.grayText,
                                         fontSize: 12 * f,
                                         fontWeight: FontWeight.w500,
                                         height: 16 / 12,
                                         letterSpacing: 0.50,
                                       ),
                                     ),
                                     Text(
                                       filterList[index].relation,
                                       style: GoogleFonts.poppins(
                                         color: AppColors.darkGreyText,
                                         fontSize: 12 * f,
                                         fontWeight: FontWeight.w500,
                                         height: 16 / 12,
                                         letterSpacing: 0.50,
                                       ),
                                     ),
                                   ]
                               ),
                             ],
                           ),
                         ),
                         Visibility(
                           visible:filterList[index].mobileNo.isNotEmpty,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               VerticalSpace(height: 4),
                               Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children:[
                                     Text(
                                       translation(context).mobileNumber,
                                       style: GoogleFonts.poppins(
                                         color: AppColors.grayText,
                                         fontSize: 12 * f,
                                         fontWeight: FontWeight.w500,
                                         height: 16 / 12,
                                         letterSpacing: 0.50,
                                       ),
                                     ),
                                     Text(
                                       filterList[index].mobileNo,
                                       style: GoogleFonts.poppins(
                                         color: AppColors.darkGreyText,
                                         fontSize: 12 * f,
                                         fontWeight: FontWeight.w500,
                                         height: 16 / 12,
                                         letterSpacing: 0.50,
                                       ),
                                     ),
                                   ]
                               ),
                             ],
                           ),
                         ),
                         Visibility(
                           visible:filterList[index].bookingDate.isNotEmpty,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               VerticalSpace(height: 4),
                               Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children:[
                                     Text(
                                       translation(context).bookingDate,
                                       style: GoogleFonts.poppins(
                                         color: AppColors.grayText,
                                         fontSize: 12 * f,
                                         fontWeight: FontWeight.w500,
                                         height: 16 / 12,
                                         letterSpacing: 0.50,
                                       ),
                                     ),
                                     Text(
                                       filterList[index].bookingDate,
                                       style: GoogleFonts.poppins(
                                         color: AppColors.darkGreyText,
                                         fontSize: 12 * f,
                                         fontWeight: FontWeight.w500,
                                         height: 16 / 12,
                                         letterSpacing: 0.50,
                                       ),
                                     ),
                                   ]
                               ),
                             ],
                           ),
                         ),
                         Visibility(
                           visible:filterList[index].transactionId.isNotEmpty,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               VerticalSpace(height: 4),
                               Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       translation(context).transactionId,
                                       style: GoogleFonts.poppins(
                                         color: AppColors.grayText,
                                         fontSize: 12 * f,
                                         fontWeight: FontWeight.w500,
                                         height: 16 / 12,
                                         letterSpacing: 0.50,
                                       ),
                                     ),
                                     Text(
                                       filterList[index].transactionId,
                                       style: GoogleFonts.poppins(
                                         color: AppColors.darkGreyText,
                                         fontSize: 12 * f,
                                         fontWeight: FontWeight.w500,
                                         height: 16 / 12,
                                         letterSpacing: 0.50,
                                       ),
                                     ),
                                   ]),
                             ],
                           ),
                         ),
                         Visibility(
                           visible:filterList[index].seatStatus.isNotEmpty,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               VerticalSpace(height: 4),
                               Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children:[
                                     Text(
                                       translation(context).bookingStatus,
                                       style: GoogleFonts.poppins(
                                         color: AppColors.grayText,
                                         fontSize: 12 * f,
                                         fontWeight: FontWeight.w500,
                                         height: 16 / 12,
                                         letterSpacing: 0.50,
                                       ),
                                     ),
                                     Text(
                                       formattedStatusMessage(filterList[index].seatStatus
                                           .toLowerCase(),
                                           context),
                                       style: GoogleFonts.poppins(
                                         color:seatStatusMessageColor(
                                             filterList[index].seatStatus
                                                 .toLowerCase()),
                                         fontSize: 12 * f,
                                         fontWeight: FontWeight.w500,
                                         height: 16 / 12,
                                         letterSpacing: 0.50,
                                       ),
                                     ),
                                   ]
                               ),
                             ],
                           ),
                         ),
                       ],
                     );
                   },
                   separatorBuilder: (BuildContext context, int index) {
                     return VerticalSpace(height: 16);
                   },
                   itemCount: filterList.length))),
           ContinueButton(
             containerBackgroundColor: Colors.white,
             isEnabled:filterList.where((model) => model.isChecked==true).toList().isNotEmpty,
             onPressed: () {
               List<String>deletedLIst=[];
               filterList.forEach((element) {
                 deletedLIst.add(element.traveller_ID);
               });
              if(!bookedTripDetailsController.isdelete.value) showModalBottomSheet(
                 context: context,
                 builder: (BuildContext context1) {
                   return CommonConfirmationAlert(
                     confirmationText1: translation(context).deleteTravellar,
                     confirmationText2:translation(context).travellerDeleteMessage,
                     onPressedYes: () async {
                       Navigator.pop(context);
                       String deletedIds = deletedLIst.join(', ');
                        await bookedTripDetailsController.delete(widget.tripID!,deletedIds,context).then((value){
                          Navigator.pop(context,value);
                      });


                     },

                   );
                 },
               );

             },
             buttonText:  translation(context).delete,
           )
         ],
       ),
       Obx((){
         if(bookedTripDetailsController.isdelete.value){
           return  Center(child: CircularProgressIndicator(),);
         }else{
           return new Container();
         }

       })
     ],
   );
  }

}