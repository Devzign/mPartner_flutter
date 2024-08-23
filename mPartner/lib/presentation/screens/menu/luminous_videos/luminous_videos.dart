import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/headers/back_button_header_widget.dart';
import '../../../widgets/tab_widget.dart';
import '../../base_screen.dart';
import '../../userprofile/user_profile_widget.dart';
import 'promotional_videos.dart';

class LuminousVideos extends StatefulWidget {
  LuminousVideos({super.key, this.videoId = '-1'});

  String videoId;

  @override
  State<LuminousVideos> createState() => _LuminousVideos();
}

class _LuminousVideos extends BaseScreenState<LuminousVideos> {
  late List<TabData> tabs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget baseBody(BuildContext context) {
    tabs = [
      TabData(translation(context).promotional,
          PromotionalVideos(videoId: widget.videoId)),
      // TabData(translation(context).training, const TrainingVideos()),
    ];
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidgetWithBackButton(heading: "Luminous ${translation(context).videos}", onPressed: (){Navigator.pop(context);}),
            UserProfileWidget(),
            Expanded(child: PromotionalVideos(videoId: widget.videoId)),
            // TabWidget(
            //   initialIndex: 0,
            //   tabs: tabs,
            // ),
          ],
        ),
      ),
    );
  }
}
