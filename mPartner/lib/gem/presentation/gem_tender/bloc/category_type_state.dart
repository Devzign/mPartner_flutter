part of 'category_type_bloc.dart';

class CategoryTypeState extends Equatable {

  final List<CategorySaleType> categoryTypeData;
  final RequestState getCategoryTypeState;
  final String getCategoryTypeMessage;

  const CategoryTypeState({
    this.categoryTypeData = const [],
    this.getCategoryTypeState = RequestState.loading,
    this.getCategoryTypeMessage = '',
  });
  CategoryTypeState copyWith({
    List<CategorySaleType>? saleTypeData,
    RequestState? getSaleTypeState,
    String? getSaleTypeMessage,
  }){
    return CategoryTypeState(
      categoryTypeData: saleTypeData ?? this.categoryTypeData,
      getCategoryTypeState: getSaleTypeState ?? this.getCategoryTypeState,
      getCategoryTypeMessage: getSaleTypeMessage ?? this.getCategoryTypeMessage,
    );
  }
  @override
  List<Object?> get props => [
    categoryTypeData,
    getCategoryTypeState,
    getCategoryTypeMessage,
  ];
}