import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../../data/models/get_electrician_list_model.dart';
import '../../../../../../utils/enums.dart';

part 'intermediary_sales_event.dart';
part 'intermediary_sales_state.dart';

class IntermediarySalesBloc extends Bloc<IntermediarySalesEvent, IntermediarySalesState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  IntermediarySalesBloc(this.baseMPartnerRemoteDataSource) : super(const IntermediarySalesState()) {
    on<GetElectricianListEvent>(getSaleTypeEvent);
  }

  FutureOr<void> getSaleTypeEvent(GetElectricianListEvent event, Emitter<IntermediarySalesState> emit) async {

    final result = await baseMPartnerRemoteDataSource.getElectricianList();
    result.fold(
          (l) => emit(state.copyWith(
            electricianListState: RequestState.error,
      )),
          (r) => emit(
        state.copyWith(
          electricianListData: r,
          electricianListState: RequestState.loaded,
        ),
      ),
    );
  }
}
