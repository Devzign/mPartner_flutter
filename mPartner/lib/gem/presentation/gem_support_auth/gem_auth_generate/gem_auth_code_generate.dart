import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';

import '../../../../presentation/screens/cashredemption/widgets/continue_button.dart';
import '../../../state/controller/gem_auth_code_generate_controller.dart';
import '../../../utils/gem_default_widget/gem_header.dart';
import '../../../utils/gem_default_widget/loading_bar.dart';
import '../../../utils/gem_default_widget/no_data_widget.dart';
import '../gem_support_autcode/component_gem_support_auth/gst_auth_generate_detail.dart';

class Gem_AuthCodeGenerate extends StatefulWidget {
  final String gstNumber;

  Gem_AuthCodeGenerate({required this.gstNumber});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _Gem_AuthCodeGenerate();
  }
}

class _Gem_AuthCodeGenerate extends State<Gem_AuthCodeGenerate> {
  GemAuthCodeGenerateController controller = Get.find();
  @override
  void initState() {
    controller.termsConditionsChecked.value = false;
    controller.isTermsRead.value = false;
    controller.getdata(context, widget.gstNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double variablePixel =
    DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GemHeader(translation(context).gemRequestCode),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [

                        if(controller.loading==true)LoadingBar()
                        else if(controller.datalist.length == 0)NoDataWidget(message: translation(context).noRecordFound,)
                        else new GstAuthGenerateDetailItem(controller.datalist[0]),

                      ]),
                    ),
                  ),


                  if (controller.loading == false &&controller.datalist.length > 0)Container(
                    margin: EdgeInsets.fromLTRB(24 * variablePixel, 10 * variablePixel, 24 * variablePixel, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(translation(context).termsAndConditons,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkText2,
                              fontSize: 16 * textMultiplier,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: (){
                                  if(controller.isTermsRead==true){
                                    controller.termsConditionsChecked.value =!controller.termsConditionsChecked.value;
                                  }else{
                                    controller.OpenTermsAndConditions(context);
                                  }
                                },
                                child:controller.termsConditionsChecked.value==true? Icon(Icons.check_box,color: AppColors.lumiBluePrimary,):Icon(Icons.check_box_outline_blank_outlined)),
                            GestureDetector(
                              onTap: () {
                                controller.OpenTermsAndConditions(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                child: Text(
                                  translation(context).acceptTermsConditions,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.0 * textMultiplier,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.lumiLightBlue,

                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                      ],
                    ),

                  ),

                  if (controller.loading == false && controller.datalist.length > 0)
                    Container(
                      child: ContinueButton(
                        isEnabled: controller.termsConditionsChecked.value,
                        containerBackgroundColor: Colors.white,
                        onPressed: () {
                          controller.submit(context);
                        },
                        buttonText: translation(context).requestAuthorizationCode,
                      ),
                      margin: EdgeInsets.only(top: 20),
                    ),
                ],
              ),
              if (controller.submitrequest == true) LoadingBar(),
            ],
          );
        }));
  }
}

