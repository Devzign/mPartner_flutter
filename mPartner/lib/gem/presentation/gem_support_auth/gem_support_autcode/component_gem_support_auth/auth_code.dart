import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';
import 'package:mpartner/presentation/widgets/verticalspace/vertical_space.dart';

class AuthCodeGem extends StatefulWidget {
  //final String imagePath;
  final String text;
  //final String? route;

  AuthCodeGem({Key? key, required this.text}) : super(key: key);

  @override
  State<AuthCodeGem> createState() => _AuthCodeGemState();
}

class _AuthCodeGemState extends State<AuthCodeGem> {
  @override
  Widget build(BuildContext context) {
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          // Check if a route is provided before navigating
         /* if (widget.route != null) {
            Navigator.pushNamed(context, widget.route!);
          }*/
        },
        child: Container(
          width: 90 * variablePixelWidth,
          height: 110 * variablePixelWidth,
           /* decoration: new BoxDecoration(
              color: AppColors.lightGrey2,
              shape:
              BoxShape.rectangle ,
              borderRadius:
                   BorderRadius.all(Radius.circular(8.0))

            ),*/
        decoration: BoxDecoration(
        border: Border.all(width:1,color: AppColors.lightGreyOval), // 0.1 to 0.9
        color: AppColors.statusBarColor,
        borderRadius: BorderRadius.circular(10.0),
        ),



          padding: EdgeInsets.symmetric(horizontal: variablePixelWidth * 8),
          child: Column(
            children: [
              Container(
                width: 48 * variablePixelWidth,
                height: 48 * variablePixelWidth,
                padding: EdgeInsets.all(10 * variablePixelWidth),
               /* decoration: ShapeDecoration(
                  color: AppColors.lumiLight4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50 * pixelMultiplier),
                  ),
                ),*/
                //child: Image.asset(widget.imagePath),
              ),
              VerticalSpace(height: 10),
              Column(
                children: [
                  Text(
                    widget.text.split(' ')[0],
                    softWrap: true,
                    style: GoogleFonts.poppins(
                      color: AppColors.blackText,
                      fontSize: 12 * textMultiplier,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.25,
                    ),
                  ),
                 /* Text(
                    widget.text.split(' ')[1],
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.blackText,
                      fontSize: 14 * textMultiplier,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.25,
                    ),
                  ),*/
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
