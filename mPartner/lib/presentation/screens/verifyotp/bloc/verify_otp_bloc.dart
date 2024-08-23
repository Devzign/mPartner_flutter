import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/localdata/shared_preferences_util.dart';
import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../data/models/otp_model.dart';
import '../../../../data/models/user_data_model.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../data/models/verify_otp_model.dart';
import '../../../../state/contoller/auth_contoller.dart';
import '../../../../state/contoller/homepage_banners_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/fcm/notification_services.dart';

part 'verify_otp_event.dart';

part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;
  UserDataController controller = Get.find();
  AuthController authController = Get.find();
  HomepageBannersController homepageBannersController = Get.find();
  String? maxAttemptMsg;
  String? otpVerifiedMsg;
  final List<UserData> splashScreenData = [];
  bool getUserData = false;
  int incorrectOtpAttempts = 0;
  bool getProfileInfo = false;

  VerifyOtpBloc(this.baseMPartnerRemoteDataSource) : super(VerifyOtpInitial()) {
    on<VerifyOtpInitialActionEvent>(verifyOtpInitialActionEvent);
    on<VerifyOtpResendActionEvent>(verifyOtpResendActionEvent);
    on<SAPIDSelectionActionEvent>(sapIDSelectionActionEvent);
    on<GetProfileInfoEvent>(getProfileInfoEvent);
  }

  Future<FutureOr<void>> verifyOtpInitialActionEvent(
      VerifyOtpInitialActionEvent event, Emitter<VerifyOtpState> emit) async {
    emit(LoginShowLoader(true));
    incorrectOtpAttempts = controller.incorrectOtpLimit;
    final parameters =
        VerifyOtpParameters(getId: event.getId, getOTP: event.getOtp);
    final result = await baseMPartnerRemoteDataSource.verifyOTP(
        parameters.getId, parameters.getOTP);
    String token = controller.token;

    result.fold(
      (left) {
        logger.e("Verify OTP Error: $left");
        emit(LoginShowLoader(false));
      },
      (right) async {
        if (right.message == AppString.verifiedSuccessfully) {
          controller.updatePhoneNumber(event.phoneNo);
          otpVerifiedMsg = AppString.otpVerified;
          getUserData = true;
        } else {
          emit(LoginShowLoader(false));
          incorrectOtpAttempts++;
          if (incorrectOtpAttempts <= 4) {
            controller.updateIncorrectOtpLimit(incorrectOtpAttempts);
          }
          if (incorrectOtpAttempts < 4) {
            emit(VerifyOtpErrorState(right.message));
          }
          if (controller.incorrectOtpLimit == 4) {
            emit(ShowIncorrectOtpMaxLimitAlertState(
                AppString.incorrectOtpMaxAttempt));
          }
        }
      },
    );
    if (getUserData) {
      final userParameters = GetUserDataParameters(
          phoneNumber: event.phoneNo,
          userId: event.getId,
          token: token.toString());
      final userResult = await baseMPartnerRemoteDataSource.getUserData(
          userParameters.phoneNumber,
          userParameters.userId,
          userParameters.token);
      print(userResult);
      userResult.fold(
        (left) {
          logger.e("Get User Data Error: $left");
          emit(LoginShowLoader(false));
        },
        (right) {
          splashScreenData.addAll(right);
          if (splashScreenData.isNotEmpty) {
            UserData firstDisty = splashScreenData[0];
            SharedPreferencesUtil.saveUserType(firstDisty.type);
          }
          Map<String, String> sapIdImageMap = {};
          for (UserData ud in splashScreenData) {
            sapIdImageMap[ud.id] = ud.profileImage;
          }
          controller.updateSapIdImageMap(sapIdImageMap);
          UserData firstDisty = splashScreenData[0];
          SharedPreferencesUtil.saveUserType(firstDisty.type);
          if(splashScreenData.length > 1){
            emit(LoginShowLoader(false));
          }
          emit(NavigateToVerifyOtpActionState(
              splashScreenData, otpVerifiedMsg!));
        },
      );
    }
  }

  Future<FutureOr<void>> verifyOtpResendActionEvent(
      VerifyOtpResendActionEvent event, Emitter<VerifyOtpState> emit) async {
    final parameters = GetOtpParameters(phoneNumber: event.phoneNo);
    final result =
        await baseMPartnerRemoteDataSource.createOTP(parameters.phoneNumber);
    print(result);
    result.fold(
      (left) {
        logger.e("Error: $left");
        emit(LoginShowLoader(false));
        },
      (right) async {
        if (right.data1 == '' && right.status == 'ERROR') {
          maxAttemptMsg = right.message;
          emit(VerifyOtpResendState(maxAttemptMsg!));
        }
        if (right.status == 'SUCCESS') {
          controller.updateIncorrectOtpLimit(0);
          emit(OtpSuccessResendState(right.data1));
        }
      },
    );
  }

  Future<FutureOr<void>> sapIDSelectionActionEvent(
      SAPIDSelectionActionEvent event, Emitter<VerifyOtpState> emit) async {
    emit(LoginShowLoader(true));
    controller.updateSapId(splashScreenData[event.userDataIndex].id);
    controller.updateUserType(splashScreenData[event.userDataIndex].type);
    final List<UserProfile> userProfileDta = [];
    final patchUpdateUser =
        await baseMPartnerRemoteDataSource.patchUpdateUser();
    patchUpdateUser.fold(
      (left) {
        logger.e("Error: $left");
        emit(LoginShowLoader(false));
        },
      (right) async {
        if (right.message == AppString.dataUpdateSuccessfully) {
          getProfileInfo = true;
        }
      },
    );
    if (getProfileInfo) {
      getProfileInfo = false;
      final getUserProfileResult =
          await baseMPartnerRemoteDataSource.getUserProfile();
      String fcmToken = await FireBaseMessagingService().fetchDeviceToken();
      logger.i('FCM TOKEN-> $fcmToken');
      final fcmTokenResponse =
          await baseMPartnerRemoteDataSource.updateFcmToken(fcmToken);
      logger.i('FCM TOKEN fcmTokenResponse-> $fcmTokenResponse');
      getUserProfileResult.fold(
        (left) {
          logger.e("[RA_LOG] getUserProfile()... Error: $left");
          emit(LoginShowLoader(false));
          },
        (right) async {
          userProfileDta.addAll(right);
          for (var record in right) {
            if (controller.phoneNumber == record.secondaryDevice1) {
              controller.updateSecondaryDeviceInfo("secondaryDevice1");
              break;
            } else if (controller.phoneNumber == record.secondaryDevice2) {
              controller.updateSecondaryDeviceInfo("secondaryDevice2");
              break;
            }
          }

          final userProfileJson = jsonEncode(userProfileDta);
          if (controller.phoneNumber == userProfileDta[0].phone) {
            logger.d("This is Primary");
            controller.updateIsPrimaryNumberLogin(true);
          } else {
            logger.d("This is Not Primary");
            controller.updateIsPrimaryNumberLogin(false);
          }
          controller.updateUserProfile(userProfileJson);
          emit(LoginShowLoader(false));
        },
      );
    }
    logger.i('-----------------------> HERE');
    emit(NavigateToVerifyOtpSuccessActionState());
  }

  Future<FutureOr<void>> getProfileInfoEvent(
      GetProfileInfoEvent event, Emitter<VerifyOtpState> emit) async {
    final List<UserProfile> userProfileDta = [];
    controller.updateSapId(splashScreenData[0].id);
    controller.updateUserType(splashScreenData[0].type);
    final patchUpdateUser =
        await baseMPartnerRemoteDataSource.patchUpdateUser();
    patchUpdateUser.fold(
      (left) => logger.e("Error: $left"),
      (right) async {
        if (right.message == AppString.dataUpdateSuccessfully) {
          getProfileInfo = true;
        }
      },
    );
    if (getProfileInfo) {
      getProfileInfo = false;
      final getUserProfileResult =
          await baseMPartnerRemoteDataSource.getUserProfile();
      String fcmToken = await FireBaseMessagingService().fetchDeviceToken();
      logger.i('FCM TOKEN-> $fcmToken');
      final fcmTokenResponse =
          await baseMPartnerRemoteDataSource.updateFcmToken(fcmToken);
      logger.i('FCM TOKEN fcmTokenResponse-> $fcmTokenResponse');
      getUserProfileResult.fold(
        (left) {
          logger.e("[RA_LOG] get Profile Error: $left");
          emit(LoginShowLoader(false));
          },
        (right) async {
          logger.e("[RA_LOG] get Profile Success: $right");
          userProfileDta.addAll(right);
          for (var record in right) {
            if (controller.phoneNumber == record.secondaryDevice1) {
              controller.updateSecondaryDeviceInfo("secondaryDevice1");
              break;
            } else if (controller.phoneNumber == record.secondaryDevice2) {
              controller.updateSecondaryDeviceInfo("secondaryDevice2");
              break;
            }
          }

          final userProfileJson = jsonEncode(userProfileDta);
          if (controller.phoneNumber == userProfileDta[0].phone) {
            logger.d("This is Primary");
            controller.updateIsPrimaryNumberLogin(true);
          } else {
            logger.d("This is Not Primary");
            controller.updateIsPrimaryNumberLogin(false);
          }
          controller.updateUserProfile(userProfileJson);
          emit(LoginShowLoader(false));
        },
      );
    }
    emit(NavigateToDummyScreenSuccessActionState());
  }
}
