import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'search_header.dart';


class PictureSelectOptionWidget extends StatefulWidget {
  final Function(String) onItemSelected;
  final String? contentTiltle;

  const PictureSelectOptionWidget(
      { required this.onItemSelected, this.contentTiltle,super.key});

  @override
  State<PictureSelectOptionWidget> createState() => _PictureSelectOptionWidgetState();
}

class _PictureSelectOptionWidgetState extends State<PictureSelectOptionWidget> {
  TextEditingController _searchController = TextEditingController();

  String contentTiltle="";

  @override
  void initState() {
    contentTiltle=widget.contentTiltle!;
    super.initState();
  }
  void _handleStateSelected(String stateInfo) {
    widget.onItemSelected(
        stateInfo); // Invoke the callback passed from the parent
  }


  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    var textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      margin: EdgeInsets.only(left: 10*variablePixelWidth),

      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SearchHeaderWidget(
          title: contentTiltle,
          onClose: () => Navigator.of(context).pop(),
        ),

        Container(
           width: variablePixelHeight * 392,
           padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20*variablePixelHeight,),
              Container(
                width: variablePixelWidth * 245,
                height: variablePixelHeight * 40,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                    widget.onItemSelected("Camera");

                    });
                  },
                  child: Text(
                    translation(context).camera,
                    style: GoogleFonts.poppins(
                      color: AppColors.blackText.withOpacity(0.8),
                      fontStyle: FontStyle.normal,
                      fontSize: 16 * textMultiplier,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              SizedBox(height: 5*variablePixelHeight,),

              Container(
                width: variablePixelWidth * 245,
                height: variablePixelHeight * 40,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      widget.onItemSelected("Choose files");

                    });
                  },
                  child: Text(
                    translation(context).chooseFiles,
                    style: GoogleFonts.poppins(
                      color: AppColors.blackText.withOpacity(0.8),
                      fontStyle: FontStyle.normal,
                      fontSize: 16 * textMultiplier,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),

              SizedBox(
                height: 36 * variablePixelHeight,
              ),

            ],
          ),
        ),
      ]),
    );
  }
}
