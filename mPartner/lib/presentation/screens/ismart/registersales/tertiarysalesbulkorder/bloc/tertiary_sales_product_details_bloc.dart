import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../../data/models/get_tertiary_bulk_details_list_model.dart';
import '../../../../../../utils/enums.dart';
import '../../uimodels/customer_info.dart';

part 'tertiary_sales_product_details_event.dart';

part 'tertiary_sales_product_details_state.dart';

class TertiarySalesProductDetailsBloc extends Bloc<
    TertiarySalesProductDetailsEvent, TertiarySalesProductDetailsState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  TertiarySalesProductDetailsBloc(this.baseMPartnerRemoteDataSource)
      : super(const TertiarySalesProductDetailsState()) {
    on<GetTertiaryBulkProductDetailsListEvent>(
        getTertiaryBulkProductDetailsListEvent);
  }

  FutureOr<void> getTertiaryBulkProductDetailsListEvent(
      GetTertiaryBulkProductDetailsListEvent event,
      Emitter<TertiarySalesProductDetailsState> emit) async {
    final result = await baseMPartnerRemoteDataSource
        .getTertiaryBulkProductDetailsBySerialNo(
            event.customerInfo, event.serialNo);

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
