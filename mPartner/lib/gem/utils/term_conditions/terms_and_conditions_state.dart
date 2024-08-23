part of 'term_and_conditions_bloc.dart';


class TermsAndConditionsState extends Equatable {

  final RequestState gemstate;
  final String getCategoryTypeMessage;
  final TermsConditionsResponse? termsandCondtions;

  const TermsAndConditionsState({
    this.gemstate = RequestState.loading,
    this.getCategoryTypeMessage = '',
    this.termsandCondtions,

  });
  TermsAndConditionsState copyWith({
    RequestState? gemstate,
    String? getSaleTypeMessage,
    TermsConditionsResponse?termsandCondtions,

  }){
    return TermsAndConditionsState(
      gemstate: gemstate ?? this.gemstate,
      getCategoryTypeMessage: getSaleTypeMessage ?? this.getCategoryTypeMessage,
      termsandCondtions: termsandCondtions ?? this.termsandCondtions,
    );
  }
  @override
  List<Object?> get props => [
    gemstate,
    getCategoryTypeMessage,
    termsandCondtions,

  ];
}

