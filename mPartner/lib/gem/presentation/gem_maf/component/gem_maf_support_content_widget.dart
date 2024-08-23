import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';
import 'package:mpartner/presentation/screens/home/widgets/section_headings.dart';
import 'package:mpartner/presentation/widgets/verticalspace/vertical_space.dart';

import '../../../../../../../state/contoller/homepage_promo_videos_controller.dart';
import '../../../../../../../utils/localdata/language_constants.dart';

class GemMafSupportContentAuthWidget extends StatefulWidget {
  GemMafSupportContentAuthWidget({super.key,required this.onclick});
  Function()onclick;

  @override
  State<GemMafSupportContentAuthWidget> createState() =>
      _GemSupportContentWidgetWidgetState();
}

class _GemSupportContentWidgetWidgetState extends State<GemMafSupportContentAuthWidget> {
  HomepagePromoVideosController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    if(_controller.showLoader) {
      _controller.fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    return

      InkWell(child:  Container(
        padding: EdgeInsets.only(
          left: variablePixelWidth * 24,
          top: variablePixelHeight * 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(right: 24 * variablePixelWidth),
                child: SectionHeading(
                  text: translation(context).mafauthorizationform,
                  fontWeight: FontWeight.w600,
                  //onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => LuminousVideos()));},
                )),

          ],
        ),
      ),onTap: (){
        widget.onclick();

      },);

  }
}
