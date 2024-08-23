import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../utils/localdata/language_constants.dart';

import '../../../state/controller/gem_auth_detail_controller.dart';
import '../../../utils/gem_default_widget/gem_header.dart';
import '../../../utils/gem_default_widget/loading_bar.dart';
import '../../../utils/gem_default_widget/no_data_widget.dart';
import '../component/gem_auth_detail_widget.dart';

class GemAuthDetails extends StatefulWidget{
  final int id;
  final String authcode;
  GemAuthDetails({required this.id,required this.authcode});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _GemAuthDetails();
  }

}

class _GemAuthDetails extends State<GemAuthDetails>{
  GemAuthDetailController controller=Get.find();
  @override
  void initState() {
    controller.getdata(context,widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Obx(() {
        return  Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GemHeader(translation(context).gemSupportAuthorizationCode),
            if(controller.loading==true)LoadingBar()
            else if(controller.datalist.length==0)NoDataWidget(message: translation(context).noRecordFound,)
            else GemAuthDetailWidget(controller.datalist[0],widget.authcode),

          ],
        );

      }),
    );
  }

}