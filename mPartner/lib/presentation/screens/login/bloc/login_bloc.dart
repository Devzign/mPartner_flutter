import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../data/models/otp_model.dart';
import 'package:meta/meta.dart';

import '../../../../state/contoller/auth_contoller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_string.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;
  String? getId;
  String? message;
  String? timerData;
  String? maxAttemptMsg;
  bool isActiveOtp = false;
  UserDataController controller = Get.find();


  LoginBloc(this.baseMPartnerRemoteDataSource) : super(LoginInitial()) {
    on<LoginInitialActionEvent>(loginInitialActionEvent);
  }

  Future<FutureOr<void>> loginInitialActionEvent(
      LoginInitialActionEvent event, Emitter<LoginState> emit) async {
    emit(LoginShowLoader(true));
    AuthController authController = Get.find();
    final parameters = GetOtpParameters(phoneNumber: event.number);
    final activeOtpResult = await baseMPartnerRemoteDataSource.activeOTP(parameters.phoneNumber);
    activeOtpResult.fold((error) {
      emit(LoginShowLoader(false));
      logger.e("Error: $error");
    }, (response) {
      if (response.status == LoginFlowStrings.successStatus) {
        emit(LoginShowLoader(false));
        getId = response.data;
        message = response.message;
        timerData = response.data1;
        authController.updateUniqueCode(response.token);
        emit(NavigateToFillingOtpActionState(getId!, message!, timerData!));
      }
      else{
        isActiveOtp = true;
      }
    });

    if(isActiveOtp){
      isActiveOtp = false;
      final result =
      await baseMPartnerRemoteDataSource.createOTP(parameters.phoneNumber);
      print(result);
      result.fold((l) {
        emit(LoginShowLoader(false));
        logger.e("Error: $l");
      }, (response){
        emit(LoginShowLoader(false));
        if (response.status == LoginFlowStrings.errorStatus && response.data.isNotEmpty) {
          emit(LoginShowLoader(false));
          emit(LoginMaxAttemptState(response.message));
        }
        if (response.data1 == '' && response.status == LoginFlowStrings.errorStatus && response.data == '') {
          emit(LoginShowLoader(false));
          maxAttemptMsg = response.message;
          emit(LoginUnregisterNotState(maxAttemptMsg!));
        }
        if (response.status == LoginFlowStrings.successStatus) {
          emit(LoginShowLoader(false));
          getId = response.data;
          message = response.message;
          timerData = response.data1;
          controller.updatePhoneNumber(parameters.phoneNumber);
          controller.updateIncorrectOtpLimit(0);
          authController.updateUniqueCode(response.token);
          emit(NavigateToFillingOtpActionState(getId!, message!, timerData!));
        }
      });
    }
  }
}
