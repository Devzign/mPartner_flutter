part of 'product_bloc.dart';

// sealed class ProState extends Equatable {
//   const ProductState();

//   @override
//   List<Object> get props => [];
// }

// class ProductInitial extends ProductState {}

// class UserTypeInitialState extends ProductInitial {
//   UserTypeInitialState({required this.state});
//   int state;
// }

// class MonthState extends ProductState {
//   MonthState({required this.month});
//   final month;
// }

class ProductState extends Equatable {
  final List<Catalog> catalogScreenData;
  final RequestState catalogScreenState;
  final String catalogScreenMessage;

  const ProductState({
    this.catalogScreenData = const [],
    this.catalogScreenState = RequestState.loading,
    this.catalogScreenMessage = '',
  });
  ProductState copyWith({
    List<Catalog>? catalogScreenData,
    RequestState? catalogScreenState,
    String? catalogScreenMessage,
  }) {
    return ProductState(
      catalogScreenData: catalogScreenData ?? this.catalogScreenData,
      catalogScreenState: catalogScreenState ?? this.catalogScreenState,
      catalogScreenMessage: catalogScreenMessage ?? this.catalogScreenMessage,
    );
  }

  @override
  List<Object?> get props => [
        catalogScreenData,
        catalogScreenState,
        catalogScreenMessage,
      ];
}
