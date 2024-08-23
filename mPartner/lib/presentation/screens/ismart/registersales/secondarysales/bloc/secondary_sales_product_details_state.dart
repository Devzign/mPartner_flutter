part of 'secondary_sales_product_details_bloc.dart';


class SecondarySalesProductDetailsState extends Equatable {
  final List<SaleData> productDetailsListData;
  final RequestState productDetailsListState;
  final String productDetailsListMessage;

  const SecondarySalesProductDetailsState({
    this.productDetailsListData = const [],
    this.productDetailsListState = RequestState.loading,
    this.productDetailsListMessage = '',
  });
  SecondarySalesProductDetailsState copyWith({

    List<SaleData>? productDetailsListData,
    RequestState? productDetailsListState,
    String? productDetailsListMessage,

  }){
    return SecondarySalesProductDetailsState(
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

