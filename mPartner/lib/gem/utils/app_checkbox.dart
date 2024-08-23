



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppCheckBox extends StatelessWidget{
  bool Ischecked=false;
  var checkedColor;
  var UcheckedColor;
  var TextColor;
  String?text;
  Function(bool)OnChanged;


  AppCheckBox({required this.Ischecked,required this.checkedColor,required this.UcheckedColor,required this.TextColor,required this.text,required this.OnChanged});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new InkWell(child: Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 15,right: 15),
      child: new Row(
        children: [
          if(Ischecked==true)Icon(Icons.check_box,size: 30,color: checkedColor,)else Icon(Icons.check_box_outline_blank_outlined,size: 30,color: UcheckedColor,),
          new SizedBox(width: 12,),
          new Container(child: new Text(text.toString(),style: GoogleFonts.poppins(
            color: TextColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 0.09,
          )),)
        ],
      ),
    ),onTap: (){
      OnChanged(Ischecked=!Ischecked);
      print(Ischecked);

    },);
  }

}