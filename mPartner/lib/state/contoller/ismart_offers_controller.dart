import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';

class IsmartOffersController extends GetxController {
  List<String> ismartOffersThumbnailURLs = [];

  var isLoading = false.obs;
  var error = ''.obs;


  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchIsmartOffers() async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postIsmartOffers();
      result.fold(
        (failure) {
          // Handle failure (Left)
          error('Failed to fetch ismart offers: $failure');
        },
        (ismartOffersThubnailsData) async {
          for (var option in ismartOffersThubnailsData) {
            print("OPTION ${option}");
            if (option.props.every((value) => value == 'NA')) {
              error('No ismart offers available');
            } else {
              error('');
            }
            ismartOffersThumbnailURLs = ismartOffersThubnailsData
                .map((option) => option.backgroundImage)
                .toList();
          }
        },
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }
}
