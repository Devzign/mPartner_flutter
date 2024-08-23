// import 'package:flutter/material.dart';
// import 'package:mobile_number/mobile_number.dart';
// import 'package:mpartner/mpartner/state/contoller/user_data_controller.dart';
// import 'package:get/get.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';

// class SimInformationService{

//   static Future<List<SimCard>> getMobileInfo() async{
//     List<SimCard> simCards=<SimCard>[];

//     MobileNumber.listenPhonePermission((isPermissionGranted) async {
//       if(isPermissionGranted){
//         if (!await MobileNumber.hasPhonePermission) {
//       await MobileNumber.requestPhonePermission;
//       return;
//     }
//     try {
//       simCards = (await MobileNumber.getSimCards)!;
//     } on PlatformException catch (e) {
//       debugPrint("Failed to get mobile number because of '${e.message}'");
//     }
//       }
//       else{}
//     });
//     return simCards;
//   }

//   static Future<bool> checkIfSimValid() async{
//      UserDataController controller = Get.find();

//     String accountPhoneNumber=controller.phoneNumber;
//     List<String> devicePhoneNumbers=[];

//     List<SimCard> simCards=await getMobileInfo();
//     if(simCards.isNotEmpty){
//       for(final sim in simCards){
//         devicePhoneNumbers.add(sim.number!);
//       }
//     }
//     return devicePhoneNumbers.contains(accountPhoneNumber);
//   }
// }