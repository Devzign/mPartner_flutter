part of 'intermediary_sales_product_details_bloc.dart';


class IntermediarySalesProductDetailsState extends Equatable {
  final List<SaleData> productDetailsListData;
  final RequestState productDetailsListState;
  final String productDetailsListMessage;

  const IntermediarySalesProductDetailsState({
    this.productDetailsListData = const [],
    this.productDetailsListState = RequestState.loading,
    this.productDetailsListMessage = '',
  });
  IntermediarySalesProductDetailsState copyWith({

    List<SaleData>? productDetailsListData,
    RequestState? productDetailsListState,
    String? productDetailsListMessage,

  }){
    return IntermediarySalesProductDetailsState(
      productDetailsListData: productDetailsListData ?? this.productDetailsListData,
      productDetailsListState: productDetailsListState ?? this.productDetailsListState,
      productDetailsListMessage: productDetailsListMessage ?? this.productDetailsListMessage,
    );
  }
  @override
  List<Object?> get props => [
    productDetailsListData,
    productDetailsListState,
    productDetailsListMessage,
  ];
}

