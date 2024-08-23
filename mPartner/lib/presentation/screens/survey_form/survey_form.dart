import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import '../../../data/models/survey_question_model.dart';
import '../../widgets/common_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/app_colors.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../state/contoller/survey_question_controller.dart';
import '../../../state/contoller/survey_answer_controller.dart';
import '../../../state/contoller/feedback_answer_controller.dart';
import '../../../utils/localdata/language_constants.dart';
import 'components/confirmation_alert_widget.dart';
import 'components/survey_question_widget.dart';

class SurveyForm extends StatefulWidget {
  final int currentIndex;
  final List<int> selectedOptionIndexes;
  final List<String> userAnswers;

  SurveyForm({
    required this.currentIndex,
    required this.selectedOptionIndexes,
    required this.userAnswers,
  });

  @override
  State<SurveyForm> createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  UserDataController controller = Get.find();
  SurveyQuestionsController surveyQuestionsController = Get.find();
  SurveyAnswersController surveyAnswersController = Get.find();
  FeedBackAnswersController feedBackAnswersController = Get.find();
  String token = "";
  String user_Id = "";
  String selectedRadioOption = "";
  List<String> selectedOptionAlphabets = [];
  String selectedCheckboxOptions = "";
  String selectedStarOption = "";
  String selectedFeedback = "";
  List<String> responseQuestions = [];
  //List<String> responseQuestionTypes = [];
  List<QuestionType> responseQuestionTypes = [];
  List<String> responseIds = [];
  List<int> responseQuestionNos = [];
  List<List<String>> responseOptions = [];
  List<Asset> selectedImages = [];
  int currentIndex = 0;
  int totalQuestionsCount = 0;
  bool showFeedbackForm = false;
  bool isLoading = true;
  List<String> userAnswers = [];
  bool submitButtonEnabled = false;
  List<int> selectedOptionIndexes = [];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    selectedOptionIndexes = widget.selectedOptionIndexes;
    userAnswers = widget.userAnswers;
    selectedOptionAlphabets = List.generate(
        surveyQuestionsController.totalQuestionsCount, (index) => userAnswers[index]);
    initializeSurveyForm();
  }

  Future<void> initializeSurveyForm() async {
    setState(() {
      responseQuestions = surveyQuestionsController.responseQuestions;
      responseQuestionTypes = surveyQuestionsController.responseQuestionTypes;
      responseIds = surveyQuestionsController.responseIds;
      responseQuestionNos = surveyQuestionsController.responseQuestionNos;
      responseOptions = surveyQuestionsController.responseOptions;
      totalQuestionsCount = surveyQuestionsController.totalQuestionsCount;
      isLoading = surveyQuestionsController.showLoader;
    });
  }

  void handleRadioOptionSelected(String option, int selectedIndex) {
    setState(() {
      selectedRadioOption = option;
      selectedOptionIndexes[currentIndex] = selectedIndex;
      selectedOptionAlphabets[currentIndex] = option;
      userAnswers[currentIndex] = option ?? "";
    });
  }

  void handleCheckboxOptionSelected(String selectedOptions, int selectedIndex) {
    setState(() {
      selectedCheckboxOptions = selectedOptions;
      selectedOptionIndexes[currentIndex] = selectedIndex;
      selectedOptionAlphabets[currentIndex] = selectedOptions;
      userAnswers[currentIndex] = selectedOptions ?? "";
    });
  }

  void handleStarOptionSelected(String startCount, int selectedIndex) {
    setState(() {
      selectedStarOption = startCount;
      selectedOptionIndexes[currentIndex] = selectedIndex;
      selectedOptionAlphabets[currentIndex] = startCount;
      userAnswers[currentIndex] = startCount ?? "";
    });
  }

  void handleFeedbackSelected(String feedback) {
    setState(() {
      selectedFeedback = feedback;
      submitButtonEnabled = true;
    });
  }

  void handleImagesSelected(List<Asset> images) {
    setState(() {
      selectedImages = images;
      //submitButtonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Container(
      height: 720 * h,
      decoration: BoxDecoration(
        color: AppColors.lightWhite1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30 * r),
          topRight: Radius.circular(30 * r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          24 * w,
          16 * h,
          24 * w,
          16 * h
      ),
      child: Column(
        children: [
          Column(
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
              SizedBox(height: 3 * h),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO - Implement on cross alert
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationAlertWidget(
                              currentIndex: currentIndex,
                              selectedOptionIndexes: selectedOptionIndexes,
                              userAnswers: userAnswers,
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.titleColor,
                        size: 28 * r,
                      ),
                    ),
                    SizedBox(height: 6 * h),
                    Text(
                      translation(context).surveyForm,
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
              SizedBox(height: 8 * h),
              Container(
                height: 1 * h,
                color: AppColors.dividerGreyColor,
                margin: EdgeInsets.symmetric(vertical: 8 * h),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                if (isLoading)
                  Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      )
                  ),
                if (!showFeedbackForm && !isLoading)
                  SurveyQuestionWidget(
                    questionNumber: responseQuestionNos[currentIndex].toString(),
                    question: responseQuestions[currentIndex],
                    questionCount : totalQuestionsCount.toString(),
                    optionsType: responseQuestionTypes[currentIndex],
                    optionsList:  responseOptions[currentIndex],
                    onRadioOptionSelected: handleRadioOptionSelected,
                    onCheckboxOptionsSelected: handleCheckboxOptionSelected,
                    onStarOptionSelected: handleStarOptionSelected,
                    onFeedbackSelected: handleFeedbackSelected,
                    onImagesSelected: handleImagesSelected,
                    selectedIndex: selectedOptionIndexes[currentIndex],
                  ),
                if (showFeedbackForm && !isLoading)
                  SurveyQuestionWidget(
                    questionNumber: "",
                    question: translation(context).pleaseProvideYourFeedbackItHelpsUsToImprove,
                    questionCount : "",
                    optionsType: QuestionType.unknown,
                    optionsList:  [],
                    onRadioOptionSelected: handleRadioOptionSelected,
                    onCheckboxOptionsSelected: handleCheckboxOptionSelected,
                    onStarOptionSelected: handleStarOptionSelected,
                    onFeedbackSelected: handleFeedbackSelected,
                    onImagesSelected: handleImagesSelected,
                    selectedIndex: selectedOptionIndexes[currentIndex],
                  ),
              ],
            ),
          ),
          Column(
            children: [
              if(!isLoading && currentIndex == 0 && !showFeedbackForm)
                Container(
                  width: double.infinity,
                  child: CommonButton(
                    onPressed: () {
                      handleNextButtonEvent();
                      setState(() {
                        if (currentIndex < totalQuestionsCount - 1) {
                          currentIndex += 1;
                        }
                        else if (currentIndex == totalQuestionsCount - 1) {
                          setState(() {
                            showFeedbackForm = true;
                          });
                        }
                      });
                    },
                    isEnabled: (selectedOptionIndexes[currentIndex]!=-1) ? true : false,
                    buttonText: translation(context).nextButtonText,
                    backGroundColor: AppColors.lumiBluePrimary,
                    textColor: AppColors.lightWhite1,
                    defaultButton: true,
                    containerBackgroundColor: AppColors.white,
                    horizontalPadding : 0,
                  ),
                ),
              if(!isLoading && currentIndex > 0 && !showFeedbackForm)
                Container(
                  padding: EdgeInsets.only(
                    bottom: 16.0 * h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SecondaryButton(
                        buttonText: translation(context).back,
                        onPressed: () => {
                          setState(() {
                            currentIndex -= 1;
                          })
                        },
                        buttonHeight: 48 * h,
                        isEnabled: true,
                      ),
                      SizedBox(width: 10 * w),
                      PrimaryButton(
                        buttonText: translation(context).nextButtonText,
                        onPressed: () => {
                          handleNextButtonEvent(),
                          setState(() {
                            if (currentIndex < totalQuestionsCount - 1) {
                              currentIndex += 1;
                            } else if (currentIndex == totalQuestionsCount - 1) {
                              setState(() {
                                showFeedbackForm = true;
                              });
                            }
                          })
                        },
                        buttonHeight: 48 * h,
                        isEnabled: (selectedOptionIndexes[currentIndex]!=-1) ? true : false,
                      ),
                    ],
                  ),
                ),
              if(!isLoading && showFeedbackForm)
                Container(
                  width: double.infinity,
                  child: CommonButton(
                    onPressed: () {
                      handleOnSubmitButtonEvent();
                      setState(() {
                        if (currentIndex < totalQuestionsCount - 1) {
                          currentIndex += 1;
                        }
                        else if (currentIndex == totalQuestionsCount - 1) {
                          setState(() {
                            showFeedbackForm = true;
                          });
                        }
                      });
                    },
                    isEnabled: submitButtonEnabled ? true : false,
                    buttonText: translation(context).submit,
                    backGroundColor: AppColors.lumiBluePrimary,
                    textColor: AppColors.lightWhite1,
                    defaultButton: true,
                    containerBackgroundColor: AppColors.white,
                    horizontalPadding : 0,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  handleOnSubmitButtonEvent() async {
    print("pressed Submitted");
    responseIds = responseIds.sublist(0, totalQuestionsCount);
    userAnswers = userAnswers.sublist(0, totalQuestionsCount);
    responseQuestionTypes = responseQuestionTypes.sublist(0, totalQuestionsCount);
    // print(responseIds);
    // print(userAnswers);
    // print(responseQuestionTypes);
    await surveyAnswersController.fetchSurveyAnswers(responseIds, userAnswers, responseQuestionTypes);
    await feedBackAnswersController.fetchFeedBackAnswers(selectedFeedback, selectedImages);
    surveyQuestionsController.showSurveyForm = false;
    Navigator.pop(context);
  }

  handleNextButtonEvent() {
    if (responseQuestionTypes[currentIndex] == QuestionType.radioButton) {
      userAnswers[currentIndex] = selectedOptionAlphabets[currentIndex] ?? "";
    } else if (responseQuestionTypes[currentIndex] == QuestionType.starRating) {
      userAnswers[currentIndex] = selectedOptionAlphabets[currentIndex] ?? "";
    } else if (responseQuestionTypes[currentIndex] == QuestionType.checkbox) {
      userAnswers[currentIndex] = selectedOptionAlphabets[currentIndex] ?? "";
    }
  }
}