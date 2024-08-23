import 'package:get/get.dart';
import '../../../services/services_locator.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/luminous_videos_model.dart';

class LuminousVideosController extends GetxController {
  var isLoading = true.obs;
  var luminousVideosList = <LuminousVideoModel>[].obs;
  var youtubeChannelIconUrl = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  fetchLuminousVideos() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getLuminousVideos();
      print(result);
      result.fold(
        (l) => print("Error: $l"),
        (r) async {
          luminousVideosList.addAll(r);
          String videoId = '';
          for (var video in luminousVideosList) {
            videoId += '${video.videoId},';
          }
          await fetchVideoDetails(videoId.substring(0,videoId.length-1));
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    }
  }

  Future<void> fetchVideoDetails(String videoId) async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
      sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getLuminousVideosViewCount(videoId);
      print(result);
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
              for (int i = 0; i < r.length; i++) {
                final viewCount = r[i].viewCount;
                luminousVideosList[i].viewCount = viewCount;
              }
        },
      );
    }catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  fetchChannelIcon() async {
    try {
   //   isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result =
          await baseMPartnerRemoteDataSource.getLuminousYoutubeChannelIcon();
      result.fold(
        (l) => print("Error: $l"),
        (r) async {
         youtubeChannelIconUrl.value = r[0].thumbnail;
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
    //  isLoading(false);
    }
  }

  clearLuminousVideosController() {
    isLoading = true.obs;
    luminousVideosList = <LuminousVideoModel>[].obs;
    youtubeChannelIconUrl = ''.obs;
    update();
  }
}
