




import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpartner/lms/presentation/recorded/recorded_video_list.dart';

import '../../gem/utils/gem_default_widget/gem_header.dart';
import '../../utils/app_colors.dart';
import '../utils/ListVideoItem.dart';
import '../utils/TabHeader.dart';
import '../utils/app_text_style.dart';
import 'live/CameraGalleryOptions.dart';
import 'live/OnFileChoose.dart';

class LmsVideoCategeoryList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LmsVideoCategeoryList();
  }

  @override
  void onPicker({required XFile? file}) {
    // TODO: implement onPicker
  }

}
class _LmsVideoCategeoryList extends State<LmsVideoCategeoryList>  with SingleTickerProviderStateMixin{
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:Container(
        child:Stack(
          children: [
            new Column(
              children: [
                GemHeader("Training & Development"),
                new Container(
                    height: 250,
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/mpartner/Homepage_Assets/power.png",),
                        fit: BoxFit.cover
                      )
                    ),
                    ),
              ],
            ),
            BottomView(),
          ],
        ),


      ),
    );
  }
  Widget BottomView() {
    return DraggableScrollableSheet(
      initialChildSize: .65,
      minChildSize: .65,
      maxChildSize: .8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
            color: Colors.white
          ),
          child: Column(
            children: <Widget>[
               TabHeader(),
               TabBar(
                 indicatorSize: TabBarIndicatorSize.tab,
                 dividerColor:AppColors.lumiBluePrimary ,
                 dividerHeight: .5,
                 indicatorColor:AppColors.lumiBluePrimary ,
                 unselectedLabelStyle: AppTextStyle.getStyle(color: AppColors.grey,fontSize: 14,fontWeight: FontWeight.w600),
                 labelStyle: AppTextStyle.getStyle(color: AppColors.lumiBluePrimary,fontSize: 14,fontWeight: FontWeight.w600),
                 controller: _tabController,
                tabs: [
                  Tab(text: 'Live',),
                  Tab(text: 'Physical'),
                  Tab(text: 'Recorded'),
                ],
              ),
               Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 50,
                        padding: EdgeInsets.all(20),
                        itemBuilder: (BuildContext context, int index) {
                          return ListVideoItem(index);
                        },
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 50,
                        padding: EdgeInsets.all(20),
                        itemBuilder: (BuildContext context, int index) {
                          return ListVideoItem(index);
                        },
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 50,
                        padding: EdgeInsets.all(20),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(child: ListVideoItem(index),onTap: (){
                            Get.to(RecordedVideoList());
                          },);
                        },
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
        );

      },
    );
  }



}