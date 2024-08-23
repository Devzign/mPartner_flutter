part of 'user_profile_bloc.dart';

@immutable

class UserProfileState extends Equatable {

  final List<UserProfile> userProfileData;
  final RequestState userProfileScreenState;
  final String userProfileScreenMessage;

  const UserProfileState({
    this.userProfileData = const [],
    this.userProfileScreenState = RequestState.loading,
    this.userProfileScreenMessage = '',

  });

  UserProfileState copyWith({

    List<UserProfile>? userProfileData,
    RequestState? userProfileScreenState,
    String? userProfileScreenMessage,

  }){
    return UserProfileState(
      userProfileData: userProfileData ?? this.userProfileData,
      userProfileScreenState: userProfileScreenState ?? this.userProfileScreenState,
      userProfileScreenMessage: userProfileScreenMessage ?? this.userProfileScreenMessage,
    );
  }
  @override
  List<Object?> get props => [
    userProfileData,
    userProfileScreenState,
    userProfileScreenMessage,

  ];
}
