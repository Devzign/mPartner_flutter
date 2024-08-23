




import 'package:flutter/material.dart';

class LoadingBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
      margin: EdgeInsets.only(top: 100),
    );
  }


}