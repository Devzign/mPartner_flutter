import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/survey_answer_model.dart';
import '../../data/models/survey_question_model.dart';

class SurveyAnswersController extends GetxController {
  List<String> responseIds = [];
  List<String> userAnswers = [];
  //List<String> responseQuestionTypes = [];
  List<QuestionType> responseQuestionTypes = [];

  var isLoading = false.obs;
  var error = ''.obs;

  var surveyAnswersResponse = SurveyAnswersResponse(
    message: '',
    status: '',
    token: '',
    data: 0,
    data1: [],
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource = MPartnerRemoteDataSource();

  Future<void> fetchSurveyAnswers(List<String> responseIds, List<String> userAnswers, List<QuestionType> responseQuestionTypes) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postSurveyAnswers(responseIds, userAnswers, responseQuestionTypes);

      result.fold((failure) {
        error('Failed to fetch survey Answers: $failure');
      }, (surveyAnswersResponseData) {
        surveyAnswersResponse(surveyAnswersResponseData);
      },
      );
    } finally {
      isLoading(false);
    }
  }
}