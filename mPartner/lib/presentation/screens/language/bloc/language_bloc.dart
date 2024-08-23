import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mpartner/data/datasource/mpartner_remote_data_source.dart';
import 'package:mpartner/data/models/language_model.dart';

import '../../../../../utils/enums.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  LanguageBloc(this.baseMPartnerRemoteDataSource)
      : super(const LanguageState()) {
    on<LanguageInitialFetchEvent>(languageInitialFetchEvent);
  }

  FutureOr<void> languageInitialFetchEvent(
      LanguageInitialFetchEvent event, Emitter<LanguageState> emit) async {
    final result = await baseMPartnerRemoteDataSource.getLanguageData();
    print(result);
    result.fold(
      (l) => emit(state.copyWith(
        languageScreenState: RequestState.error,
      )),
      (r) => emit(
        state.copyWith(
          languageScreenData: r,
          languageScreenState: RequestState.loaded,
        ),
      ),
    );
  }
}
