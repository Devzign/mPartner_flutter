import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as htmlParser;


import '../../network/api_constants.dart';
import '../../presentation/screens/home/Homescreen/youtube_videos_model.dart';
import '../../utils/app_constants.dart';
import '../../utils/requests.dart';
import 'user_data_controller.dart';

class HomepagePromoVideosController extends GetxController {
  List<VideoModel> videos = [];
  bool showLoader = true;
  UserDataController controller = Get.find();

  @override
  void onInit() async {
    super.onInit();
    await fetchData();
  //  update();
  }

  clearState() {
    videos = [];
    showLoader = true;
  }

  /*Future<String> fetchVideoDuration(String videoId) async {
    try {
      final videoDetailsUrl = "https://www.youtube.com/watch?v=$videoId";
      final response = await http.get(Uri.parse(videoDetailsUrl));

      if (response.statusCode == 200) {
        final document = htmlParser.parse(response.body);

        // Find the duration meta tag
        final durationMetaTag = document
            .querySelector('meta[itemprop="duration"]')
            ?.attributes['content'];

        // Parse and format the duration
        if (durationMetaTag != null) {
          final duration = parseAndFormatDuration(durationMetaTag);
          return duration;
        }
      }

      throw Exception('Failed to fetch video duration for video ID: $videoId');
    } catch (error) {
      print("Error fetching video duration: $error");
      return '';
    }
  }*/

  String parseAndFormatDuration(String duration) {
    return duration
        .replaceFirst('PT', '')
        .replaceAll('H', ':')
        .replaceAll('M', ':')
        .replaceAll('S', '');
  }

  Future<void> fetchData() async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": "",
      "os_Type": Platform.isAndroid ? "android":"ios",
      "channel": "App",
    };
    try {
      final response =
          await Requests.sendPostRequest(ApiConstants.postLuminousVideos, body);
          
          Map<String, dynamic> jsonMap = json.decode(response.data);

      if (response is! DioException && response.statusCode == 200) {
        final List<dynamic> items = jsonMap['items'];

        for (var item in items) {
          final snippet = item['snippet'];
          final thumbnails = snippet['thumbnails'];
          final resourceId = snippet['resourceId'];
          //final videoId = resourceId['videoId'];
          final thumbnailURL = thumbnails.containsKey('standard')
              ? thumbnails['standard']
              : thumbnails.containsKey('default')
                  ? thumbnails['default']
                  : null;
          //final duration = await fetchVideoDuration(videoId);

          videos.add(
            VideoModel(
              videoId: resourceId['videoId'],
              thumbnail: thumbnailURL['url'],
              title: snippet['title'],
              //duration: duration.toString(),
              duration: "",
            ),
          );
        }
        showLoader = false;
        update();
      }
    } catch (error) {
      print("catch block videos ${error}");
    }
  }

}