



import 'package:flutter/material.dart';

import '../../../gem/utils/gem_default_widget/gem_header.dart';
import '../../utils/trainingListView.dart';
import '../../utils/widget_recorded_video.dart';

class RecordedVideoList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RecordedVideoList();
  }
  
}
class _RecordedVideoList extends State{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Column(
        children: [
          GemHeader("Training & Development"),
          WidgetRecordedVideo(),
        ],
      ),
    );
  }
  
}