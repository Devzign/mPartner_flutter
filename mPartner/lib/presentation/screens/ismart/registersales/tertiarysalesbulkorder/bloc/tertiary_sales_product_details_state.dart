part of 'tertiary_sales_product_details_bloc.dart';


class TertiarySalesProductDetailsState extends Equatable {
  final List<TertiarySaleData> productDetailsListData;
  final RequestState productDetailsListState;
  final String productDetailsListMessage;

  const TertiarySalesProductDetailsState({
    this.productDetailsListData = const [],
    this.productDetailsListState = RequestState.loading,
    this.productDetailsListMessage = '',
  });
  TertiarySalesProductDetailsState copyWith({

    List<TertiarySaleData>? productDetailsListData,
    RequestState? productDetailsListState,
    String? productDetailsListMessage,

  }){
    return TertiarySalesProductDetailsState(
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

