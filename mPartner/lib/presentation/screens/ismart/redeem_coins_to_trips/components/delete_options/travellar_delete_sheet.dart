

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpartner/presentation/screens/ismart/redeem_coins_to_trips/components/delete_options/widget_traveller_list.dart';

import '../../../../../../data/models/booked_trip_details_model.dart';

class TravellarDeleteSheet{
  static Future<dynamic> ShowTravellerDelete(BuildContext context, RxList<TravellerDetail> bookedTravellers, int tripID) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 200),
      showDragHandle: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return WidgetTravellerList(bookedTravellers,tripID);
      },
    );


  }



}