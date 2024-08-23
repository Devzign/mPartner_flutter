


import 'package:flutter/cupertino.dart';

import '../../presentation/screens/home/widgets/section_headings.dart';
import '../../utils/displaymethods/display_methods.dart';
import '../../utils/localdata/language_constants.dart';

class LmsCourceHeading extends StatelessWidget{
  final String heading;
  LmsCourceHeading({required this.heading});
  @override
  Widget build(BuildContext context) {
    double variablePixelWidth =DisplayMethods(context: context).getVariablePixelWidth();
    return new Container(
      child:  Container(
          padding: EdgeInsets.only(left: 24),
          child: SectionHeading(
            text: heading,
            fontWeight: FontWeight.w500,
            showChevronRight: false,
          )),
    );
  }

}