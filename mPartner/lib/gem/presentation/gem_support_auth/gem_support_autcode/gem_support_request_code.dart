import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';

import '../../../../presentation/screens/base_screen.dart';
import '../../../../presentation/screens/ismart/ismart_homepage/components/subsection_header.dart';
import '../../../state/controller/gem_authgst_controller.dart';
import '../../../utils/gem_default_widget/gem_header.dart';
import '../gem_auth_generate/gem_auth_code_generate.dart';
import 'component_gem_support_auth/form_widget_gem_request_code.dart';
class GemSupportRequestCode extends StatefulWidget {
  const GemSupportRequestCode({super.key});
  @override
  State<GemSupportRequestCode> createState() => _GemSupportRequestCode();
}

class _GemSupportRequestCode extends BaseScreenState<GemSupportRequestCode> {
  GemAuthGstController gemAuthGstController=Get.find();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double fontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    TextStyle textStyle = GoogleFonts.poppins(
      color: AppColors.darkGrey,
      fontSize: 14 * textMultiplier,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    OutlineInputBorder focusedBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: Colors.grey),
    );
    OutlineInputBorder enabledBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: Colors.grey),
    );
    TextStyle labelTextStyle = GoogleFonts.poppins(
      color: AppColors.darkGrey,
      fontSize: 12 * textMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.40 * variablePixelWidth,
    );
    TextStyle hintTextStyle = GoogleFonts.poppins(
      color: AppColors.grayText,
      fontSize: 14 * textMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    TextStyle headingTextStyle = GoogleFonts.poppins(
      color: AppColors.titleColor,
      fontSize: 20 * textMultiplier,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    TextStyle bottomSheetListStyle = GoogleFonts.poppins(
      color: AppColors.titleColor,
      fontSize: 16 * textMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.50 * variablePixelWidth,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GemHeader(translation(context).gemRequestCode),
          SizedBox(height: 16,),
          SubsectionHeader(sectionHeader: translation(context).enterDetail),
          Expanded(
            child: GemSupportRequestForm(onFieldsUpdate: updateFieldFilledStatus,getGstNumber: (gstnumber) async {
              var res= await  Navigator.push(context,MaterialPageRoute(builder: (context) => Gem_AuthCodeGenerate(gstNumber: gstnumber,)),);
              if(res!=null){
                Navigator.pop(context,true);
              }
            },),
          )
        ],
      ),
    );
  }


  void updateFieldFilledStatus(bool p1) {
  }
}
