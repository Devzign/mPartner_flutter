import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import '../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../data/models/pricelist_model.dart';
import '../../../../../../utils/enums.dart';
import '../../../../../state/contoller/user_data_controller.dart';

part 'pricelist_event.dart';
part 'pricelist_state.dart';

class PricelistBloc extends Bloc<PricelistEvent, PricelistState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;
  UserDataController userDataController = Get.find();

  PricelistBloc(this.baseMPartnerRemoteDataSource) : super(const PricelistState()) {
    on<PriceListFetchEvent>(InitialFetchEvent);
  }

  FutureOr<void> InitialFetchEvent(
      PriceListFetchEvent event, Emitter<PricelistState> emit) async {
    final result = await baseMPartnerRemoteDataSource.postPricelist(userDataController.userType, false);
    print(result);
    result.fold(
      (l) => emit(state.copyWith(
        pricelistScreenState: RequestState.error,
      )),
      (r) {
        if(r.isNotEmpty) {
          emit(
            state.copyWith(
              pricelistScreenData: r,
              pricelistScreenState: RequestState.loaded,
            ),
          );
        } else {
          emit(
            state.copyWith(
              pricelistScreenMessage: "no_data",
              pricelistScreenState: RequestState.error,
            ),
          );
        }
      }
    );
  }
}
