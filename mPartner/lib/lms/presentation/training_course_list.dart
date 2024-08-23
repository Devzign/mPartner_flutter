




import 'package:flutter/material.dart';

import '../../gem/utils/gem_default_widget/gem_header.dart';
import '../../utils/localdata/language_constants.dart';
import '../utils/lms_course_heading.dart';
import '../utils/trainingListView.dart';

class TrainingCourseList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _TrainingCourceList();
  }
}
class _TrainingCourceList extends State{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Column(
        children: [
          GemHeader("Training & Development"),
          LmsCourceHeading(heading: "Select Course",),
          TrainingListView(),
        ],
      ),
    );
  }
  
  
  
}
