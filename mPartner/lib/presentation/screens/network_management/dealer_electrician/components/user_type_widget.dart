import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'search_header.dart';


class UserTypeWidget extends StatefulWidget {
  final Function(String) onItemSelected;
  final String stateId;
  final String? userType;

  const UserTypeWidget(
      {this.stateId = "", required this.onItemSelected, this.userType,super.key});

  @override
  State<UserTypeWidget> createState() => _UserTypeWidgetState();
}

class _UserTypeWidgetState extends State<UserTypeWidget> {
  TextEditingController _searchController = TextEditingController();

  String radioValue="";

  @override
  void initState() {
    radioValue=widget.userType!;
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
          title:  translation(context).selectUserType,
          onClose: () => Navigator.of(context).pop(),
        ),

        Container(
         // width: variablePixelHeight * 392,
         // padding: EdgeInsets.symmetric(vertical: 10 * variablePixelHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: variablePixelWidth * 245,
                height: variablePixelHeight * 40,
                child: Row(
                  children: [
                    Radio(
                      value: 'Dealer',
                      groupValue: radioValue,
                      activeColor: AppColors.lumiBluePrimary,
                      onChanged: (value) {
                        setState(() {
                         radioValue = value.toString();

                        });
                      },
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          radioValue = "Dealer";

                        });
                      },
                      child: Text(
                        translation(context).dealer,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkText2,
                          fontStyle: FontStyle.normal,
                          fontSize: 14 * textMultiplier,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                width: variablePixelWidth * 245,
                height: variablePixelHeight * 40,
                child: Row(
                  children: [
                    Radio(
                      value: 'Electrician',
                      groupValue: radioValue,
                      activeColor: AppColors.lumiBluePrimary,
                      onChanged: (value) {
                        setState(() {
                            radioValue = value.toString();

                        });
                      },
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          radioValue = "Electrician";

                        });
                      },
                      child: Text(
                        translation(context).electrician,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkText2,
                          fontStyle: FontStyle.normal,
                          fontSize: 14 * textMultiplier,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 36 * variablePixelHeight,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50 * variablePixelHeight,
                child: RawMaterialButton(
                  onPressed: () {
                    _handleStateSelected(radioValue.toString());
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100 * variablePixelHeight),
                  ),
                  fillColor: AppColors.lumiBluePrimary,

                  child:  Text(
                    translation(context).submit,
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 26 * variablePixelHeight,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
