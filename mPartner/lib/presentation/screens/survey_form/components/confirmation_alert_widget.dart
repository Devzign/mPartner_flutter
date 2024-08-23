import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/buttons/secondary_button.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../survey_form.dart';
import '../../../../utils/localdata/language_constants.dart';

class ConfirmationAlertWidget extends StatefulWidget {
  final int currentIndex;
  final List<int> selectedOptionIndexes;
  final List<String> userAnswers;

  ConfirmationAlertWidget({
    required this.currentIndex,
    required this.selectedOptionIndexes,
    required this.userAnswers,
  });

  @override
  State<ConfirmationAlertWidget> createState() => _ConfirmationAlertWidgetState();
}

class _ConfirmationAlertWidgetState extends State<ConfirmationAlertWidget> {
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Container(
      padding: EdgeInsets.fromLTRB(24 * w, 16 * h, 24 * w, 32 * h),
      decoration: BoxDecoration(
        color: AppColors.lightWhite1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30 * r),
          topRight: Radius.circular(30 * r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: 0.40,
            child: Container(
              width: 32 * w,
              height: 4 * h,
              margin: EdgeInsets.only(bottom: 16 * h),
              decoration: ShapeDecoration(
                color: AppColors.lightGrey3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100 * r),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpace(height: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.titleColor,
                          size: 28 * r,
                        )),
                    SizedBox(height: 6 * h),
                    Text(
                      translation(context).confirmationAlert,
                      style: GoogleFonts.poppins(
                        color: AppColors.titleColor,
                        fontSize: 20 * f,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1 * h,
                color: AppColors.dividerGreyColor,
                margin: EdgeInsets.symmetric(vertical: 8 * h),
              ),
              const VerticalSpace(height: 20),
              Text(
                translation(context).surveyFormOnceClosedWillNotSaveYourResponses,
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                ),
              ),
              const VerticalSpace(height: 4),
              Text(
                translation(context).areYouSureYouWantToClose,
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 16 * f,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
              ),
              const VerticalSpace(height: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SecondaryButton(
                    buttonText: translation(context).no,
                    onPressed: () => {
                      Navigator.pop(context),
                      showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        enableDrag: true,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SurveyForm(
                            currentIndex: widget.currentIndex,
                            selectedOptionIndexes: widget.selectedOptionIndexes,
                            userAnswers: widget.userAnswers,
                          );
                        },
                      ),
                    },
                    buttonHeight: 48 * h,
                    isEnabled: true,
                  ),
                  const HorizontalSpace(width: 16),
                  PrimaryButton(
                    buttonText: translation(context).yes,
                    onPressed: () => {
                      Navigator.pop(context),
                    },
                    buttonHeight: 48 * h,
                    isEnabled: true,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}