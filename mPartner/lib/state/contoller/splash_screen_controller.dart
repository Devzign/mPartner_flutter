import 'package:get/get.dart';
import '../../utils/enums.dart';
import 'user_data_controller.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../utils/app_constants.dart';
import '../../../services/services_locator.dart';

class SplashScreenController extends GetxController {
  var isLoading = true.obs;
  var splashScreenUrl = ''.obs;
  var welcomeScreenUrl = ''.obs;
  var isLoggedIn = false.obs;
  UserDataController controller = Get.find();
  var navigationState = NavigationState.welcomePage.obs;
  var errorMessage = ''.obs;

  fetchSplashScreenImage() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result =
          await baseMPartnerRemoteDataSource.getSplashScreenImage(AppConstants.splashScreenName);

      result.fold(
        (errorResponse) {
          isLoading(false);
          logger.d("Error fetching splash screen image: $errorResponse");
          navigationState.value = NavigationState.httpFailure;
        },
        (successResponse) {
          logger.d("successResponse fetching splash screen image***** ");
          if (successResponse.status == "200" && successResponse.data != null && successResponse.data!.isNotEmpty) {
            splashScreenUrl.value = successResponse.data![0].imageUrl;
            checkUserLoggedIn();
          } else {
            logger.d("successResponse fetching splash screen image***** ");
            errorMessage.value = successResponse.message;
            navigationState.value = NavigationState.responseFailure;
          }
        },
      );
    } catch (e) {
      logger.e("Error in cache fetching splash screen image: $e");
      navigationState.value = NavigationState.httpFailure;
    } finally {
      logger.d("IN FINAL BLOCK");
      isLoading(false);
    }
  }

  fetchWelcomeScreenImage() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result =
          await baseMPartnerRemoteDataSource.getSplashScreenImage(AppConstants.welcomeScreenName);

      result.fold(
        (errorResponse) {
          isLoading(false);
          logger.e("Error fetching splash screen image: $errorResponse");
          navigationState.value = NavigationState.httpFailure;
        },
        (successResponse) {
          if (successResponse.status == "200" && successResponse.data != null && successResponse.data!.isNotEmpty) {
            welcomeScreenUrl.value = successResponse.data![0].imageUrl;
          } else {
            errorMessage.value = successResponse.message;
            navigationState.value = NavigationState.responseFailure;
          }
        },
      );
    } catch (e) {
      logger.e("Error in cache fetching splash screen image: $e");
      navigationState.value = NavigationState.httpFailure;
    } finally {
      isLoading(false);
    }
  }

  checkUserLoggedIn() async {
    try {
      if (controller.token != '' && controller.phoneNumber != '') {
        isLoggedIn.value = true;
        await updateAppVersion();
      } else {
        isLoggedIn.value = false;
        navigationState.value = NavigationState.welcomePage;
      }
    } catch (e) {
      logger.e("Error checking user data: $e");
    }
  }

  updateAppVersion() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final updateVersionResult =
          await baseMPartnerRemoteDataSource.postUpdateAppVersion();

      updateVersionResult.fold(
        (errorResponse) {
          logger.e("Error Updating UpdateAppVersion: $errorResponse");
          navigationState.value = NavigationState.httpFailure;
        },
        (successResponse) {
          logger.d("successResponse UpdateAppVersion***** ");
          if (successResponse.status == "200" && successResponse.token.isNotEmpty && successResponse.data.isNotEmpty) {
            navigationState.value = NavigationState.homePage;
          } else {
            errorMessage.value = successResponse.message;
            navigationState.value = NavigationState.responseFailure;
          }
        },
      );
    } catch (e) {
      logger.e("Error in cache Updating UpdateAppVersion: $e");
      navigationState.value = NavigationState.httpFailure;
    } finally {
      isLoading(false);
    }
  }

  clearSplashScreenController() {
    isLoading = true.obs;
    splashScreenUrl = ''.obs;
    welcomeScreenUrl = ''.obs;
    navigationState = NavigationState.welcomePage.obs;
    errorMessage = ''.obs;
    update();
  }
}
