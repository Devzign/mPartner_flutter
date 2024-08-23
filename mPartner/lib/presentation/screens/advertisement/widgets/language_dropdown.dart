import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/language_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
class LanguageDropDown extends StatelessWidget {
  
  final List<Language> options;
  final String selectedValue;
  final Function(Language) onChanged;
  final TextEditingController languageController;

  const LanguageDropDown({
    Key? key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.languageController,
  }) : super(key: key);

  void showLanguagesBottomSheet(BuildContext context,
      double variablePixelHeight, double variablePixelWidth, double textMultiplier, double pixelMultiplier){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0 * pixelMultiplier),
        ),
      ),
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  8 * variablePixelWidth,
                  8 * variablePixelHeight,
                  8 * variablePixelWidth,
                  8 * variablePixelHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Container(
                        height: 5 * variablePixelHeight,
                        width: 50 * variablePixelWidth,
                        decoration: BoxDecoration(
                          color: AppColors.dividerGreyColor,
                          borderRadius: BorderRadius.circular(12 * pixelMultiplier),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.black,
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0 *variablePixelWidth),
                    child: Text(
                      translation(context).selectlanguage,
                      style: GoogleFonts.poppins(
                        color: AppColors.titleColor,
                        fontSize: 20 * textMultiplier,
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                        letterSpacing: 0.50 * variablePixelWidth,
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                    child: const CustomDivider(color: AppColors.dividerColor),
                  ),
                  Container(
                    width: 345 * variablePixelWidth,
                    height: 560 * variablePixelHeight,
                    child: SingleChildScrollView(
                      child: Column(
                        children: options.map((Language language) {
                          final isSelected=language.language==selectedValue;
                          return ListTile( 
                            dense: true,
                            visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
                            contentPadding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelHeight, top: 0, bottom: 0),
                            title: Text(language.language, style: GoogleFonts.poppins(
                              fontSize: 16 * textMultiplier,
                              height: 24/16,
                              letterSpacing: 0.5 * variablePixelWidth,
                              color: isSelected?AppColors.lumiBluePrimary :AppColors.darkGrey,
                              fontWeight: FontWeight.w500,
                            ),),
                            onTap: () {
                              onChanged(language);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Padding(
      padding: EdgeInsets.only(
        left: 24 * variablePixelWidth,
        right: 24 * variablePixelWidth,
        top: 10 * variablePixelHeight,
        bottom: 10 * variablePixelHeight,
      ),
      child: Container(
        child: TextField(
          
          onTap: () {
            showLanguagesBottomSheet(
                context, variablePixelHeight, variablePixelWidth, textMultiplier, pixelMultiplier);
          },
          controller: languageController..text=selectedValue,
          keyboardType: TextInputType.number,
          style: GoogleFonts.poppins(
            fontSize: 14 * textMultiplier,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.50 ,
          ),
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
            contentPadding:
                EdgeInsets.fromLTRB(16 * variablePixelWidth, 0, 0, 0),
            labelText: translation(context).language,
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(4.0 * variablePixelWidth)),
              borderSide: const BorderSide(color: AppColors.lumiBluePrimary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(4.0 * variablePixelWidth)),
              borderSide: const BorderSide(color: AppColors.lightGreyBorder),
            ),
            labelStyle: GoogleFonts.poppins(
              color: AppColors.darkGrey,
              fontSize: 16 * textMultiplier,
              fontWeight: FontWeight.w400,
              height: 0.11,
              letterSpacing: 0.40,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14 * textMultiplier,
              fontWeight: FontWeight.w400,
              height: 0.12,
              letterSpacing: 0.50,
            ),
            prefixStyle: GoogleFonts.poppins(
              fontSize: 14 * textMultiplier,
              fontWeight: FontWeight.w500,
              height: 0.12,
              letterSpacing: 0.50,
            ),
          ),
        ),
      ),
    );
  }
}
