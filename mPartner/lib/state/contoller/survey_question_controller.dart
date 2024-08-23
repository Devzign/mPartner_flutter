import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/survey_question_model.dart';

class SurveyQuestionsController extends GetxController {
  List<String> responseQuestions = [];
  List<QuestionType> responseQuestionTypes = [];
  //List<String> responseQuestionTypes = [];
  List<String> responseIds = [];
  List<int> responseQuestionNos = [];
  List<List<String>> responseOptions = [];
  int totalQuestionsCount = 0;
  bool showLoader = true;
  bool showSurveyForm = false;

  var isLoading = false.obs;
  var error = ''.obs;

  var surveyQuestionsResponse = SurveyQuestionsResponse(
    message: '',
    status: '',
    token: '',
    data: 0,
    data1: [],
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource = MPartnerRemoteDataSource();

  Future<void> fetchSurveyQuestions() async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postSurveyQuestions();

      result.fold((failure) {
        error('Failed to fetch survey questions: $failure');
      }, (surveyQuestionsResponseData) {
        surveyQuestionsResponse(surveyQuestionsResponseData);
        List<SurveyQuestions> dataList = surveyQuestionsResponseData.data1;
        if (dataList.isNotEmpty) {
          showSurveyForm = true;
          totalQuestionsCount = dataList.length;
          for (var questionData in dataList) {
            List<String> options = [];
            responseIds.add(questionData.id.toString() ?? "");
            //responseQuestionTypes.add(questionData.type ?? "");
            responseQuestionTypes.add(questionData.type ?? QuestionType.unknown);
            responseQuestions.add(questionData.title ?? "");
            responseQuestionNos.add(questionData.questionNo ?? 0);

            if (questionData.optionA != null && questionData.optionA != "")
              options.add(questionData.optionA!);
            if (questionData.optionB != null && questionData.optionB != "")
              options.add(questionData.optionB!);
            if (questionData.optionC != null && questionData.optionC != "")
              options.add(questionData.optionC!);
            if (questionData.optionD != null && questionData.optionD != "")
              options.add(questionData.optionD!);
            if (questionData.optionE != null && questionData.optionE != "")
              options.add(questionData.optionE!);
            responseOptions.add(options);
          }
        } else {
          showSurveyForm = false;
          error("Error: Empty data list");
        }
      },
      );
    } finally {
      showLoader = false;
      isLoading(false);
    }
  }
}

