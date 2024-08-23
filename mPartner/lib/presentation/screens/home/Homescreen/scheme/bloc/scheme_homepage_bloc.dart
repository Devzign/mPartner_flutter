import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

import '../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../../data/models/scheme_homepage_model.dart';

import '../../../../../../../utils/enums.dart';
import '../../../../our_products/tab_scheme/components/Functions/constants/userType.dart';

part 'scheme_homepage_event.dart';
part 'scheme_homepage_state.dart';

class SchemeHomepageBloc
    extends Bloc<SchemeHomepageBlocEvent, SchemeHomepageBlocState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  SchemeHomepageBloc(this.baseMPartnerRemoteDataSource)
      : super(SchemeHomepageBlocState()) {
    on<SchemeHomepageFetchEvent>(InitialFetchEvent);
  }

  FutureOr<void> InitialFetchEvent(SchemeHomepageFetchEvent event,
      Emitter<SchemeHomepageBlocState> emit) async {
    final result = await baseMPartnerRemoteDataSource.postSchemeHomepage(
        'DISTY'); // Shreshth should get it from the shared preference

    result.fold(
      (l) => emit(state.copyWith(
        SchemeHomepageBlocScreenState: RequestState.error,
      )),
      (r) => emit(
        state.copyWith(
          SchemeHomepageBlocScreenData: r,
          SchemeHomepageBlocScreenState: RequestState.loaded,
        ),
      ),
    );
  }
}
