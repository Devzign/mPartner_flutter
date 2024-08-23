import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/localdata/language_constants.dart';

import '../../../../utils/displaymethods/display_methods.dart';

import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../presentation/widgets/common_button.dart';
import '../../data/models/maf_filter_model.dart';
import '../../utils/app_checkbox.dart';
import '../gem_tender/component/headingGemSupportCategory.dart';

class MafFilterPage extends StatefulWidget {
  Rx<MafFilterModel>? filterModel;

  MafFilterPage(this.filterModel);

  @override
  State<StatefulWidget> createState() {
    return _GemMafFilterPage();
  }
}

class _GemMafFilterPage extends BaseScreenState<MafFilterPage> {
  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    // TODO: implement baseBody
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: 14 * variablePixelWidth, top: 45 * variablePixelHeight),
              child: HeadingGemSupportCategory(
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.iconColor,
                  size: 24 * variablePixelMultiplier,
                ),
                heading: translation(context).filter,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          UserProfileWidget(
            top: 8 * variablePixelHeight,
          ),
          Container(
            child: Text(translation(context).mafreqstatus,
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
            padding: EdgeInsets.only(left: 15, right: 15),
          ),
          AppCheckBox(
            Ischecked: widget.filterModel!.value.received,
            checkedColor: AppColors.lumiBluePrimary,
            UcheckedColor: AppColors.grey,
            TextColor: AppColors.black,
            text: translation(context).approved,
            OnChanged: (bool) {
              setState(() {
                widget.filterModel!.value.received = bool;
              });
            },
          ),
          AppCheckBox(
              Ischecked: widget.filterModel!.value.inprogress,
              checkedColor: AppColors.lumiBluePrimary,
              UcheckedColor: AppColors.grey,
              TextColor: AppColors.black,
              text: translation(context).pending,
              OnChanged: (bool) {
                setState(() {
                  widget.filterModel!.value.inprogress = bool;
                });
              }),
          AppCheckBox(
              Ischecked: widget.filterModel!.value.rejected,
              checkedColor: AppColors.lumiBluePrimary,
              UcheckedColor: AppColors.grey,
              TextColor: AppColors.black,
              text: translation(context).rejected,
              OnChanged: (bool) {
                setState(() {
                  widget.filterModel!.value.rejected = bool;
                });
              }),
          const SizedBox(height: 25),
          Container(
            child: Text(translation(context).bidstatus,
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
            padding: EdgeInsets.only(left: 15, right: 15),
          ),
          AppCheckBox(
            Ischecked: widget.filterModel!.value.win,
            checkedColor: AppColors.lumiBluePrimary,
            UcheckedColor: AppColors.grey,
            TextColor: AppColors.black,
            text: translation(context).win,
            OnChanged: (bool) {
              setState(() {
                if (bool) {
                  widget.filterModel!.value.win = true;
                  widget.filterModel!.value.lost = false;
                } else {
                  widget.filterModel!.value.win = false;
                }
              });
            },
          ),
          AppCheckBox(
              Ischecked: widget.filterModel!.value.lost,
              checkedColor: AppColors.lumiBluePrimary,
              UcheckedColor: AppColors.grey,
              TextColor: AppColors.black,
              text: translation(context).lost,
              OnChanged: (bool) {
                setState(() {
                  if (bool) {
                    widget.filterModel!.value.lost = true;
                    widget.filterModel!.value.win = false;
                  } else {
                    widget.filterModel!.value.lost = false;
                  }
                });
              }),
          const Spacer(),
          Container(
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                    child: CommonButtonWithBorder(
                        onPressed: () {
                          widget.filterModel!.value.rejected = false;
                          widget.filterModel!.value.inprogress = false;
                          widget.filterModel!.value.received = false;
                          widget.filterModel!.value.win = false;
                          widget.filterModel!.value.lost = false;
                          Navigator.pop(context, widget.filterModel!.value);
                        },
                        isEnabled: true,
                        textColor: AppColors.lumiBluePrimary,
                        buttonText: translation(context).reset,
                        withContainer: false)),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: CommonButton(
                        onPressed: () {
                          Navigator.pop(context, widget.filterModel!.value);
                        },
                        isEnabled: true,
                        buttonText: translation(context).apply,
                        withContainer: false))
              ],
            ),
          )
        ],
      ),
    );
  }
}
