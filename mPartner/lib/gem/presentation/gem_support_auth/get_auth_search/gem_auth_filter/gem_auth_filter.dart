import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/localdata/language_constants.dart';

import '../../../../../presentation/screens/base_screen.dart';
import '../../../../../presentation/widgets/common_button.dart';
import '../../../../data/models/auth_filter_model.dart';

import '../../../../utils/app_checkbox.dart';
import '../../../../utils/gem_default_widget/gem_header.dart';
import '../gem_auth_search.dart';

class GemAuthFilter extends StatefulWidget{
  Rx<AuthFilterModel>? filterModel;
  GemAuthFilter(this.filterModel);


  @override
  State<StatefulWidget> createState() {
    return _GemAuthFilter();
  }

}
class _GemAuthFilter extends BaseScreenState<GemAuthFilter>{

  @override
  Widget baseBody(BuildContext context) {
    // TODO: implement baseBody
    return  Scaffold(
      backgroundColor: Colors.white,
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           GemHeader(translation(context).filter),
           Container(child: Text(translation(context).authorizationcodestatus,
              style: GoogleFonts.poppins(
                color: AppColors.darkText2,
                fontSize: 16,
                fontWeight: FontWeight.w600,)),padding: EdgeInsets.only(left: 15,right: 15),),
             AppCheckBox(Ischecked: widget.filterModel!.value.received, checkedColor: AppColors.lumiBluePrimary, UcheckedColor: AppColors.grey, TextColor: AppColors.black, text: translation(context).received,OnChanged: (bool){
            setState(() {
              widget.filterModel!.value.received=bool;
            });

          },),
             AppCheckBox(Ischecked: widget.filterModel!.value.inprogress, checkedColor: AppColors.lumiBluePrimary, UcheckedColor: AppColors.grey, TextColor: AppColors.black, text: translation(context).inProgress,OnChanged: (bool){
               setState(() {
                 widget.filterModel!.value.inprogress=bool;
            });
          }),
            AppCheckBox(Ischecked: widget.filterModel!.value.rejected, checkedColor: AppColors.lumiBluePrimary, UcheckedColor: AppColors.grey, TextColor: AppColors.black, text:translation(context).rejected,OnChanged: (bool){
            setState(() {
              widget.filterModel!.value.rejected=bool;
            });
          }),
           Spacer(),
           Container(
            margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
            child:  Row(
            children: [
                 Expanded(child: CommonButtonWithBorder(
                 onPressed: () {
                   widget.filterModel!.value.rejected=false;
                   widget.filterModel!.value.inprogress=false;
                   widget.filterModel!.value.received=false;
                   Navigator.pop(context,widget.filterModel!.value);
                 },
                 isEnabled: true,
                 textColor: AppColors.lumiBluePrimary,
                 buttonText: translation(context).reset,
                 withContainer: false)),
                  SizedBox(width: 20,),
                  Expanded(child: CommonButton(
                  onPressed: () {
                    Navigator.pop(context,widget.filterModel!.value);
                  },
                  isEnabled: true,
                  buttonText: translation(context).apply,
                  withContainer: false

              ))
            ],
          ),)
        ],
      ),
    );
  }

}