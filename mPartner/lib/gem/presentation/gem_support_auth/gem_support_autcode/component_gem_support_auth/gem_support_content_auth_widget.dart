import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';
import 'package:mpartner/presentation/screens/home/widgets/section_headings.dart';
import 'package:mpartner/presentation/widgets/verticalspace/vertical_space.dart';

import '../../../../../../../state/contoller/homepage_promo_videos_controller.dart';
import '../../../../../../../utils/localdata/language_constants.dart';

class GemSupportContentAuthWidget extends StatefulWidget {
  GemSupportContentAuthWidget({super.key,required this.onclick});
  Function()onclick;

  @override
  State<GemSupportContentAuthWidget> createState() =>
      _GemSupportContentWidgetWidgetState();
}

class _GemSupportContentWidgetWidgetState extends State<GemSupportContentAuthWidget> {
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
    double pixelMultipler = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return InkWell(child:  Container(
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
                 text: translation(context).gemSupportAuthorizationCode,
                 fontWeight: FontWeight.w500,
                 //onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => LuminousVideos()));},
               )),
           VerticalSpace(height: 16),

         ],
       ),
     ),onTap: (){
       widget.onclick();

     },);

    /*return GetBuilder<HomepagePromoVideosController>(
      builder: (_) {
        if(_controller.showLoader) {
          return Container();
        }
        return Container(
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
                    text: translation(context).promotionalVideos,
                    fontWeight: FontWeight.w500,
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LuminousVideos()));
                    },
                  )),
              VerticalSpace(height: 16),
              Text(
                translation(context).discoverNewFeaturesAndLatestProducts,
                style: GoogleFonts.poppins(
                  color: AppColors.grayText,
                  fontSize: 12 * textMultiplier,
                  fontWeight: FontWeight.w400,
                  height: 0.09 * variablePixelHeight,
                ),
              ),
              VerticalSpace(height: 16),
              if (_controller.videos != null && _controller.videos.isNotEmpty)
                Container(
                    height: variablePixelHeight * 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _controller.videos.length,
                      itemBuilder: (context, index) {
                        return VideoCard(
                            imagePath: _controller.videos[index].thumbnail,
                            text: _controller.videos[index].title,
                            videoId: _controller.videos[index].videoId);
                      },
                    ))
              else
                Container(
                  child: Center(child: CircularProgressIndicator()),
                )
            ],
          ),
        );
      }
    );*/
  }
}
