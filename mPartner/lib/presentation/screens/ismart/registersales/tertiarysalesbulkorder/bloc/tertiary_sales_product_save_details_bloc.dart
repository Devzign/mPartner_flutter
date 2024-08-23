import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../../data/models/get_tertiary_bulk_details_list_model.dart';
import '../../../../../../state/contoller/warranty_controller.dart';
import '../../../../../../utils/enums.dart';
import '../../uimodels/customer_info.dart';

part 'tertiary_sales_product_save_details_event.dart';
part 'tertiary_sales_product_save_details_state.dart';

class TertiarySalesProductSaveDetailsBloc extends Bloc<
    TertiarySalesProductSaveDetailsEvent,
    TertiarySalesProductSaveDetailsState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  TertiarySalesProductSaveDetailsBloc(this.baseMPartnerRemoteDataSource)
      : super(const TertiarySalesProductSaveDetailsState()) {
    on<GetTertiaryBulkProductSaveEvent>(
        getTertiaryBulkProductSaveDetailsListEvent);
  }

  String fetchSerialsWarranty(List<TertiarySaleData> productDetailsList){
    String forWarranty = '';
    for(final item in productDetailsList){
      if((item.status.toLowerCase() == "accepted" || item.status.toLowerCase() == "pending")){
        forWarranty+='${item.serialNo},';
      }
    }
    return forWarranty;
  }

  FutureOr<void> getTertiaryBulkProductSaveDetailsListEvent(
      GetTertiaryBulkProductSaveEvent event,
      Emitter<TertiarySalesProductSaveDetailsState> emit) async {
    final result = await baseMPartnerRemoteDataSource
        .getTertiaryBulkProductSaveDetailsBySerialNo(
        event.customerInfo,
            event.serialNo, event.eW_OTP,
      event.transId,
      event.eW_ViaVerified,);

    result.fold(
      (l) => emit(state.copyWith(
        productDetailsListState: RequestState.error,
      )),
      (r) {
        WarrantyController warrantyController = Get.find();
        warrantyController.getWarrantyPdfUrl(fetchSerialsWarranty(r));
        emit(
        state.copyWith(
          productDetailsListData: r,
          productDetailsListState: RequestState.loaded,
        ),
      );}
    );
  }
}
