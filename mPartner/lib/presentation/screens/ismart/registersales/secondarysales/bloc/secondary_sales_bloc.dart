import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../../data/models/get_dealer_list_model.dart';
import '../../../../../../utils/enums.dart';

part 'secondary_sales_event.dart';
part 'secondary_sales_state.dart';

class SecondarySalesBloc extends Bloc<SecondarySalesEvent, SecondarySalesState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  SecondarySalesBloc(this.baseMPartnerRemoteDataSource) : super(const SecondarySalesState()) {
    on<GetDealerListEvent>(getSaleTypeEvent);
  }

  FutureOr<void> getSaleTypeEvent(GetDealerListEvent event, Emitter<SecondarySalesState> emit) async {

    final result = await baseMPartnerRemoteDataSource.getDealerList();
    result.fold(
          (l) => emit(state.copyWith(
            dealerListState: RequestState.error,
      )),
          (r) => emit(
        state.copyWith(
          dealerListData: r,
          dealerListState: RequestState.loaded,
        ),
      ),
    );
  }
}
