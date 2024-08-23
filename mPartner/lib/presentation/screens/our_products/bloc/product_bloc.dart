import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../utils/enums.dart';
import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../data/models/catalogue_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  ProductBloc(this.baseMPartnerRemoteDataSource) : super(ProductState()) {
    on<CatalogFetchEvent>(InitialFetchEvent);
  }
  // on<ChangeMonthType>(
  //     (event, emit) => emit(MonthState(month: event.currMonth)));
  // }

  FutureOr<void> InitialFetchEvent(
      CatalogFetchEvent event, Emitter<ProductState> emit) async {
    final result = await baseMPartnerRemoteDataSource.postCatalog("ALL");
    print(result);
    result.fold(
      (l) => emit(state.copyWith(
        catalogScreenState: RequestState.error,
      )),
      (r) {
        if (r.isNotEmpty) {
          emit(
            state.copyWith(
              catalogScreenData: r,
              catalogScreenState: RequestState.loaded,
            ),
          );
        } else {
          emit(
            state.copyWith(
              catalogScreenMessage: "no_data",
              catalogScreenState: RequestState.error,
            ),
          );
        }
      }
    );
  }
}







// class SplashBloc extends Bloc<SplashEvent, SplashState> {
//   final GetSplashScreenUseCase getSplashScreenUseCase;

//   SplashBloc(this.getSplashScreenUseCase) : super(const SplashState()) {
//     on<SplashInitialFetchEvent>(splashInitialFetchEvent);
//   }

//   FutureOr<void> splashInitialFetchEvent(SplashInitialFetchEvent event, Emitter<SplashState> emit) async {

//     final result = await getSplashScreenUseCase(const NoParameters());
//     print(result);
//     result.fold(
//           (l) => emit(state.copyWith(
//             splashScreenState: RequestState.error,
//       )),
//           (r) => emit(
//         state.copyWith(
//           splashScreenData: r,
//           splashScreenState: RequestState.loaded,
//         ),
//       ),
//     );
//   }
// }
