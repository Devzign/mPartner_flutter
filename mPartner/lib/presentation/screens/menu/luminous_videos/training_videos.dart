import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/coming_soon_widget.dart';


class TrainingVideos extends StatefulWidget {
  const TrainingVideos({super.key});

  @override
  State<TrainingVideos> createState() => _TrainingVideosVideos();
}

class _TrainingVideosVideos extends State<TrainingVideos> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();

    return
      Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ComingSoonWidget(navigateHomeLogin: true,),
          ],
        ),
      ),
    );
  }

}
