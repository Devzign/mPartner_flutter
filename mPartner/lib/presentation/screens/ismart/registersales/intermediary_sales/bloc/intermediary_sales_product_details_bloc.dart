import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../../data/models/get_sale_details_list_model.dart';
import '../../../../../../utils/enums.dart';

part 'intermediary_sales_product_details_event.dart';

part 'intermediary_sales_product_details_state.dart';

class IntermediarySalesProductDetailsBloc extends Bloc<
    IntermediarySalesProductDetailsEvent, IntermediarySalesProductDetailsState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  IntermediarySalesProductDetailsBloc(this.baseMPartnerRemoteDataSource)
      : super(const IntermediarySalesProductDetailsState()) {
    on<GetIntermediaryProductDetailsListEvent>(getIntermediaryProductDetailsListEvent);
  }

  FutureOr<void> getIntermediaryProductDetailsListEvent(
      GetIntermediaryProductDetailsListEvent event,
      Emitter<IntermediarySalesProductDetailsState> emit) async {
    final result = await baseMPartnerRemoteDataSource
        .getIntermediaryProductDetailsBySerialNo(event.electricianCode,event.serialNo, event.saleDate);

    result.fold(
      (l) => emit(state.copyWith(
        productDetailsListState: RequestState.error,
      )),
      (r) => emit(
        state.copyWith(
          productDetailsListData: r,
          productDetailsListState: RequestState.loaded,
        ),
      ),
    );
  }
}
