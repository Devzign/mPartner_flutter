part of 'otp_bloc.dart';

class OTPState extends Equatable {
  final CreateOTPResponse? otpData;
  final VerifyOtpTertiarySales? otpVerified;
  final RequestState createOTPState;
  final String createOTPMessage;

  const OTPState({
    this.otpData,
    this.otpVerified,
    this.createOTPState = RequestState.loading,
    this.createOTPMessage = '',
  });

  OTPState copyWith({
    CreateOTPResponse? otpData,
    VerifyOtpTertiarySales? otpVerified,
    RequestState? createOTPState,
    String? createOTPMessage,

  }){
    return OTPState(
      otpData: otpData ?? this.otpData,
      otpVerified: otpVerified ?? this.otpVerified,
      createOTPState: createOTPState ?? this.createOTPState,
      createOTPMessage: createOTPMessage ?? this.createOTPMessage,
    );
  }
  @override
  List<Object?> get props => [
    otpData,
    otpVerified,
    createOTPState,
    createOTPMessage,
  ];
}

