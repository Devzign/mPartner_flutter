import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../data/models/get_sale_type_repsonse.dart';
import '../../../../../utils/enums.dart';

part 'register_sales_event.dart';
part 'register_sales_state.dart';

class RegisterSalesBloc extends Bloc<RegisterSalesEvent, RegisterSalesState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  RegisterSalesBloc(this.baseMPartnerRemoteDataSource) : super(const RegisterSalesState()) {
    on<GetSaleTypeEvent>(getSaleTypeEvent);
  }

  FutureOr<void> getSaleTypeEvent(GetSaleTypeEvent event, Emitter<RegisterSalesState> emit) async {

    final result = await baseMPartnerRemoteDataSource.getSaleType();
    result.fold(
          (l) => emit(state.copyWith(
            getSaleTypeState: RequestState.error,
      )),
          (r) => emit(
        state.copyWith(
          saleTypeData: r,
          getSaleTypeState: RequestState.loaded,
        ),
      ),
    );
  }
}
