import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../data/models/get_sale_type_repsonse.dart';
import '../../../../../utils/enums.dart';
import '../../../data/datasource/gem_remote_data_source.dart';
import '../../../data/models/get_category_sale_type.dart';

part 'category_type_event.dart';
part 'category_type_state.dart';

class CategoryTypeBloc extends Bloc<CategoryTypeEvent, CategoryTypeState> {
  final BaseGemRemoteDataSource baseMPartnerRemoteDataSource;

  CategoryTypeBloc(this.baseMPartnerRemoteDataSource)
      : super(const CategoryTypeState()) {
    on<GetCategoryTypeEvent>(getCategoryTypeEvent);
  }

  FutureOr<void> getCategoryTypeEvent(
      GetCategoryTypeEvent event, Emitter<CategoryTypeState> emit) async {
    final result =await baseMPartnerRemoteDataSource.getGemSupportCategoryType();
    result.fold(
      (l) => emit(state.copyWith(
          getSaleTypeState: RequestState.error, getSaleTypeMessage: l.message)),
      (r) => emit(
        state.copyWith(
          saleTypeData: r,
          getSaleTypeState: RequestState.loaded,
        ),
      ),
    );
  }
}
