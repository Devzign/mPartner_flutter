import 'package:get/get.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/feedback_answer_model.dart';

class FeedBackAnswersController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;

  var feedBackAnswersResponse = FeedBackAnswersResponse(
    message: '',
    status: '',
    token: '',
    data: null,
    data1: null,
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource = MPartnerRemoteDataSource();

  Future<void> fetchFeedBackAnswers(String feedback, List<Asset> selectedImages) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postFeedBackAnswers(feedback, selectedImages);

      result.fold((failure) {
        error('Failed to post feedback answers: $failure');
      }, (feedbackAnswersResponseData) {
        feedBackAnswersResponse(feedbackAnswersResponseData);
      });
    } finally {
      isLoading(false);
    }
  }
}

