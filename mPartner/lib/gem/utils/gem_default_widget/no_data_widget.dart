


import 'package:flutter/cupertino.dart';

class NoDataWidget extends StatelessWidget{
  final String message;
  NoDataWidget({required this.message});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(child: new Center(child: new Text(message.toString()),),);
  }

}