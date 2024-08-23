part of 'tertiary_sales_product_save_details_bloc.dart';


class TertiarySalesProductSaveDetailsState extends Equatable {
  final List<TertiarySaleData> productDetailsListData;
  final RequestState productDetailsListState;
  final String productDetailsListMessage;

  const TertiarySalesProductSaveDetailsState({
    this.productDetailsListData = const [],
    this.productDetailsListState = RequestState.loading,
    this.productDetailsListMessage = '',
  });
  TertiarySalesProductSaveDetailsState copyWith({

    List<TertiarySaleData>? productDetailsListData,
    RequestState? productDetailsListState,
    String? productDetailsListMessage,

  }){
    return TertiarySalesProductSaveDetailsState(
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

