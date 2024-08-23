import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/enums.dart';
import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../utils/app_constants.dart';

part 'user_profile_event.dart';

part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  UserProfileBloc(this.baseMPartnerRemoteDataSource)
      : super(const UserProfileState(
          userProfileData: [],
          userProfileScreenState: RequestState.loading,
          userProfileScreenMessage: '',
        )) {
    on<UserProfileInitialFetchEvent>(userProfileInitialFetchEvent);
  }

  Future<FutureOr<void>> userProfileInitialFetchEvent(
      UserProfileInitialFetchEvent event,
      Emitter<UserProfileState> emit) async {
    final result = await baseMPartnerRemoteDataSource.getUserProfile();
    result.fold(
      (l) {
        logger.d("[RA_LOG] : getUserProfile() left ");
        emit(state.copyWith(
          userProfileScreenState: RequestState.error,
        ));
      },
      (r) {
        logger.d("[RA_LOG] : getUserProfile() right ");
        emit(
          state.copyWith(
            userProfileData: r,
            userProfileScreenState: RequestState.loaded,
          ),
        );
      },
    );
  }
}
