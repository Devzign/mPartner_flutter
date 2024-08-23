part of 'scheme_homepage_bloc.dart';

class SchemeHomepageBlocState extends Equatable {
  final List<SchemeHomepage> SchemeHomepageBlocScreenData;
  final RequestState SchemeHomepageBlocScreenState;
  final String SchemeHomepageBlocScreenMessage;

  SchemeHomepageBlocState({
    this.SchemeHomepageBlocScreenData = const [],
    this.SchemeHomepageBlocScreenState = RequestState.loading,
    this.SchemeHomepageBlocScreenMessage = '',
  });
  SchemeHomepageBlocState copyWith({
    List<SchemeHomepage>? SchemeHomepageBlocScreenData,
    RequestState? SchemeHomepageBlocScreenState,
    String? SchemeHomepageBlocScreenMessage,
  }) {
    return SchemeHomepageBlocState(
      SchemeHomepageBlocScreenData:
          SchemeHomepageBlocScreenData ?? this.SchemeHomepageBlocScreenData,
      SchemeHomepageBlocScreenState:
          SchemeHomepageBlocScreenState ?? this.SchemeHomepageBlocScreenState,
      SchemeHomepageBlocScreenMessage:
          SchemeHomepageBlocScreenMessage ?? this.SchemeHomepageBlocScreenMessage,
    );
  }

  @override
  List<Object?> get props => [
        SchemeHomepageBlocScreenData,
        SchemeHomepageBlocScreenState,
        SchemeHomepageBlocScreenMessage,
      ];
}


