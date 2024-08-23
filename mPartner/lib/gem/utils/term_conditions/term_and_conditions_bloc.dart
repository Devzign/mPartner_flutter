import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:mpartner/utils/enums.dart';

import '../../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../data/models/terms_condition_model.dart';
import '../../data/datasource/gem_remote_data_source.dart';


part 'terms_and_conditions_event.dart';
part 'terms_and_conditions_state.dart';
class TermsAndConditionsBloc extends Bloc<TermsAndCondtionsEvent, TermsAndConditionsState> {
  final BaseGemRemoteDataSource baseMPartnerRemoteDataSource;
  TermsAndConditionsBloc(this.baseMPartnerRemoteDataSource) : super(const TermsAndConditionsState()) {
    on<TermsAndCondtionsEvent>(getAuthList);
  }
  FutureOr<void> getAuthList(TermsAndCondtionsEvent event, Emitter<TermsAndConditionsState> emit) async {
    final result = await baseMPartnerRemoteDataSource.fetchTermConditionDetails(event.dynamicPage.toString());
    result.fold(
          (l) => emit(state.copyWith(gemstate: RequestState.error,
      )),
          (r) => emit(state.copyWith(gemstate: RequestState.loaded,termsandCondtions:r
      ),
      ),
    );

  }
}