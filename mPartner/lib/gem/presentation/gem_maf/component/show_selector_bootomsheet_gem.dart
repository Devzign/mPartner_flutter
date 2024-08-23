import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/gem/state/controller/maf_registrationform_controller.dart';

import '../../../../../presentation/widgets/common_divider.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/app_colors.dart';
import '../../../data/models/gem_option.dart';

void ShowSelectorBottomSheetGem(
    bool isSolutionType,//if isSolutionType = true -> solutionType and isSolutionType = false -> average energy consumption
    BuildContext context,
    double variablePixelHeight,
    double variablePixelWidth,
    double textMultiplier,
    double pixelMultiplier,
    String? selectedValue,
    TextEditingController controller,
    String title,
    List<GemOption> options,[TextEditingController? subCategoryController,bool? isSubCategory]){

  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0 * pixelMultiplier),
        )
    ),
    builder: (context) => Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(8 * variablePixelWidth,
              8 * variablePixelHeight,
              8 * variablePixelWidth,
              8 * variablePixelHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: ()=> Navigator.of(context).pop(),
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
              ],),),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              color: AppColors.black,
            ),
          ),
          const VerticalSpace(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 16.0 *variablePixelWidth),
            child: Text(
              title,
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
          SingleChildScrollView(
            child:  Column(
              children: options.map((GemOption solution) {
                final isSelected=solution.name==selectedValue;
                return ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
                  contentPadding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelHeight, top: 0, bottom: 0),
                  title: Text(solution.name, style: GoogleFonts.poppins(
                    fontSize: 16 * textMultiplier,
                    height: 24/16,
                    letterSpacing: 0.5 * variablePixelWidth,
                    color: isSelected?AppColors.lumiBluePrimary :AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),),
                  onTap: () {
                    //need to save this value in getx controller
                    MafRegistrationFormController formController = Get.find();
                    if(isSolutionType==true) {
                     // formController.participantType = solution.name;
                      formController.participantType = solution.name;
                    }
                    controller.text=solution.name;
                    if(isSubCategory==true)
                    {
                      subCategoryController?.text="";
                    }
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          const VerticalSpace(height: 24),
        ],
      ),
    ),
  );
}