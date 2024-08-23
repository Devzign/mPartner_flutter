import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import '../../../../data/models/survey_question_model.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import 'checkbox_option_widget.dart';
import 'feedback_option_widget.dart';
import './radio_option_widget.dart';
import 'rating_option_widget.dart';

class SurveyQuestionWidget extends StatefulWidget {
  final String questionNumber;
  final String question;
  final String questionCount;
  final QuestionType optionsType;
  final List<String> optionsList;
  final void Function(String, int) onRadioOptionSelected;
  final void Function(String, int) onCheckboxOptionsSelected;
  final void Function(String, int) onStarOptionSelected;
  final void Function(String) onFeedbackSelected;
  final void Function(List<Asset>) onImagesSelected;
  final int selectedIndex;

  SurveyQuestionWidget({
    required this.questionNumber,
    required this.question,
    required this.questionCount,
    required this.optionsType,
    required this.optionsList,
    required this.onRadioOptionSelected,
    required this.onCheckboxOptionsSelected,
    required this.onStarOptionSelected,
    required this.onFeedbackSelected,
    required this.onImagesSelected,
    required this.selectedIndex,
  });

  @override
  State<SurveyQuestionWidget> createState() =>
      _SurveyQuestionWidgetState();
}

class _SurveyQuestionWidgetState extends State<SurveyQuestionWidget> {

  bool isLoading = false;
  String selectedRadioOption = "";
  String selectedStarOption = "";
  String selectedCheckboxOptions = "";
  String selectedFeedback = "";
  List<Asset> selectedImages = [];

  void handleRadioOptionSelected(String option, int selectedIndex) {
    setState(() {
      selectedRadioOption = option;
    });
    widget.onRadioOptionSelected(selectedRadioOption, selectedIndex);
  }

  void handleCheckboxOptionSelected(String selectedOptions, int selectedIndex) {
    setState(() {
      selectedCheckboxOptions = selectedOptions;
    });
    widget.onCheckboxOptionsSelected(selectedCheckboxOptions, selectedIndex);
  }

  void handleStarOptionSelected(String startCount, int selectedIndex) {
    setState(() {
      selectedStarOption = startCount;
    });
    widget.onStarOptionSelected(selectedStarOption, selectedIndex);
  }

  void handleFeedbackSelected(String feedback) {
    setState(() {
      selectedFeedback = feedback;
    });
    widget.onFeedbackSelected(selectedFeedback);
  }

  void handleImagesSelected(List<Asset> images) {
    setState(() {
      selectedImages = images;
    });
    widget.onImagesSelected(selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Column(
      children: [
        if (widget.optionsType != QuestionType.unknown)
          Padding(
            padding: EdgeInsets.only(top: 8 * h, bottom: 14.0 * h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${translation(context).question} ${widget.questionNumber}',
                  style: GoogleFonts.poppins(
                      color: AppColors.darkText2,
                      fontSize: 16 * f,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.10 * w
                  ),
                ),
                Text(
                  '${widget.questionNumber}/${widget.questionCount}',
                  style: GoogleFonts.poppins(
                      color: AppColors.hintColor,
                      fontSize: 14 * f,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.10 * w
                  ),
                )
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.only(right: 24.0 * w, bottom: 5 * h),
          child: Text(
            widget.question,
            style: GoogleFonts.poppins(
                color: AppColors.darkText2,
                fontSize: 16 * f,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.50 * w
            ),
          ),
        ),
        if (widget.optionsType == QuestionType.radioButton)
          Container(
              child: isLoading
                  ? Center(
                child: Container(
                  width: 20.0 * w,
                  height: 20.0 * h,
                  child: CircularProgressIndicator(),
                ),
              )
                  : RadioOptionWidget(
                optionsList: widget.optionsList,
                onOptionSelected: handleRadioOptionSelected,
                selectedIndex: widget.selectedIndex,
              )
          ),
        if (widget.optionsType == QuestionType.checkbox)
          Container(
              child: isLoading
                  ? Center(
                child: Container(
                  width: 20.0 * w,
                  height: 20.0 * h,
                  child: CircularProgressIndicator(),
                ),
              )
                  : CheckboxOptionWidget(
                optionsList: widget.optionsList,
                onOptionsSelected: handleCheckboxOptionSelected,
                selectedIndex: widget.selectedIndex,
              )
          ),
        if (widget.optionsType == QuestionType.starRating)
          Container(
              child: isLoading
                  ? Center(
                child: Container(
                  width: 20.0 * w,
                  height: 20.0 * h,
                  child: CircularProgressIndicator(),
                ),
              )
                  : RatingOptionWidget(
                onStarOptionSelected: handleStarOptionSelected,
                selectedIndex: widget.selectedIndex,
              )
          ),
        if (widget.optionsType == QuestionType.unknown)
          Container(
              child: isLoading
                  ? Center(
                child: Container(
                  width: 20.0 * w,
                  height: 20.0 * h,
                  child: CircularProgressIndicator(),
                ),
              )
                  : Padding(
                    padding: EdgeInsets.only(top: 8 * h),
                    child: FeedbackOptionWidget(
                                    onFeedbackWritten: handleFeedbackSelected,
                                    onImagesSelected: handleImagesSelected,
                                  ),
                  )
          ),
      ],
    );
  }
}