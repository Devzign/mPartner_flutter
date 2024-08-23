


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/localdata/language_constants.dart';

import '../../../state/controller/gem_bid_controller.dart';
import '../../../utils/gem_default_widget/gem_header.dart';
import '../../../utils/gem_default_widget/loading_bar.dart';
import '../../../utils/gem_default_widget/no_data_widget.dart';
import '../component/gem_bid_details.dart';
import '../gem_support_autcode/component_gem_support_auth/gem_support_content_auth_widget.dart';
import '../get_auth_search/gem_auth_search.dart';

class GemBidDetails extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GemBidDetails();
  }

}
class _GemBidDetails extends State{
  GemBidController controller=Get.find();

  @override
  void initState() {
    controller.getdata(context);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Obx((){
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GemHeader(translation(context).gemSupport),
                GemSupportContentAuthWidget(onclick: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GemAuthSearch(
                            Status: "",

                          )));
                },),
                if(controller.loading==true)LoadingBar()
                else if(controller.datalist.length==0)NoDataWidget(message: translation(context).noRecordFound)
                else Gem_Bid_Details(controller.datalist[0],onClick: (status ) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GemAuthSearch(
                              Status: status,

                            )));

                  },requestCode: () async {
                     controller.checkGstExist(context,false);

                  },),
              ],
            ),
            if(controller.checkgst==true)LoadingBar(),


          ],
        );


      }),


    );
  }

}