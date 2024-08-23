
part of 'language_bloc.dart';

class LanguageState extends Equatable {

  final List<Language> languageScreenData;
  final RequestState languageScreenState;
  final String languageScreenMessage;

  const LanguageState({
    this.languageScreenData = const [],
    this.languageScreenState = RequestState.loading,
    this.languageScreenMessage = '',

  });
  LanguageState copyWith({

    List<Language>? languageScreenData,
    RequestState? languageScreenState,
    String? languageScreenMessage,

  }){
    return LanguageState(
      languageScreenData: languageScreenData ?? this.languageScreenData,
      languageScreenState: languageScreenState ?? this.languageScreenState,
      languageScreenMessage: languageScreenMessage ?? this.languageScreenMessage,
    );
  }
  @override
  List<Object?> get props => [

    languageScreenData,
    languageScreenState,
    languageScreenMessage,

  ];
}

