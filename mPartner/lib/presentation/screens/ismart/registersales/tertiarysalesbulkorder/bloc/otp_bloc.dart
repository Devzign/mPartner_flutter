import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import '../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../../data/models/create_otp_response.dart';
import '../../../../../../data/models/verify_otp_tertiary_sales_model.dart';
import '../../../../../../state/contoller/verify_otp_controller.dart';
import '../../../../../../utils/enums.dart';
import '../../uimodels/customer_info.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OTPBloc extends Bloc<
    OTPEvent, OTPState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;
  VerifyOtpController controller = Get.find();

  OTPBloc(this.baseMPartnerRemoteDataSource)
      : super(const OTPState()) {
    on<OTPEvent>(createOTPEvent);
    on<VerifyOTPEvent>(_onVerifyOTPEvent);
    on<ResendOTPEvent>(_onResendOTPEvent);
  }

  FutureOr<void> createOTPEvent(OTPEvent event,
      Emitter<OTPState> emit) async {
    final result = await baseMPartnerRemoteDataSource
        .postCreateOTPTertiaryBulk(event.customerInfo,event.serialNo);

    result.fold(
      (l) => emit(state.copyWith(
        createOTPState: RequestState.error,
      )),
      (r) => emit(
        state.copyWith(
          otpData: r,
          createOTPState: RequestState.loaded,
        ),
      ),
    );
  }

  FutureOr<void> _onVerifyOTPEvent(
      VerifyOTPEvent event, Emitter<OTPState> emit) async {
    final result = await baseMPartnerRemoteDataSource
        .postVerifyOtpTertiaryBulk(
        event.customerInfo,
        event.serialNo,
        event.otp,
      event.transId
    );

    result.fold(
          (l) => emit(state.copyWith(
        createOTPState: RequestState.error,
      )),
          (r) => emit(
        state.copyWith(
          otpVerified: r,
          createOTPState: RequestState.loaded,
        ),
      ),
    );

  }

  FutureOr<void> _onResendOTPEvent(
      ResendOTPEvent event, Emitter<OTPState> emit) async {
    controller.updateIsResendOtpResponsePending(true);
    final result = await baseMPartnerRemoteDataSource
        .postCreateOTPTertiaryBulk(
        event.customerInfo,
        event.serialNo);
    controller.updateIsResendOtpResponsePending(false);

    result.fold(
          (l) => emit(state.copyWith(
        createOTPState: RequestState.error,
      )),
          (r) => emit(
        state.copyWith(
          otpData: r,
          createOTPState: RequestState.loaded,
        ),
      ),
    );
  }

}
