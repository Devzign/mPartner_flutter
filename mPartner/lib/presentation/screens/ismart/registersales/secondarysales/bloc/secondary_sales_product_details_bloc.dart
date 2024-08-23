import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../../data/models/get_sale_details_list_model.dart';
import '../../../../../../utils/enums.dart';

part 'secondary_sales_product_details_event.dart';

part 'secondary_sales_product_details_state.dart';

class SecondarySalesProductDetailsBloc extends Bloc<
    SecondarySalesProductDetailsEvent, SecondarySalesProductDetailsState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  SecondarySalesProductDetailsBloc(this.baseMPartnerRemoteDataSource)
      : super(const SecondarySalesProductDetailsState()) {
    on<GetProductDetailsListEvent>(getProductDetailsListEvent);
  }

  FutureOr<void> getProductDetailsListEvent(GetProductDetailsListEvent event,
      Emitter<SecondarySalesProductDetailsState> emit) async {
    final result = await baseMPartnerRemoteDataSource
        .getProductDetailsBySerialNo(event.dealerCode,event.serialNo, event.saleDate);

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
