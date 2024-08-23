import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../solar/data/datasource/solar_remote_data_source.dart';
import '../../../../utils/internet_utils.dart';
import '../model/purchase_product_history_request_model.dart';
import '../model/purchase_product_history_response_model.dart';
import 'product_history_tnc_state.dart';

class ProductHistoryTncBloc extends Cubit<ProductHistoryTncState> {
  var previouslyPurchasedProduct = PurchaseProductHistoryResponseModel();
  dynamic termsConditionsResponse;

  List<PastProductData> pastProductData = [];
  bool isPageLoading = false;
  int lastItemCount = 0;

  ProductHistoryTncBloc() : super(InitialState());

  Future<void> getPreviouslyPurchasedProductLoadMore(
      PurchaseProductHistoryRequestModel requestModel,
      MPartnerRemoteDataSource baseMPartnerRemoteDataSource,
      SolarRemoteDataSource baseSolarRemoteDataSource) async {
    var isConnected = await InternetUtil.getInstance().isInternetConnected();
    if (isConnected) {
      emit(NewDataState());
      isPageLoading = true;
      try {
        var result = await baseMPartnerRemoteDataSource
            .getPreviouslyPurchasedProduct(requestModel);
        result.fold(
          (failure) {
            lastItemCount = 0;
            isPageLoading = false;
          },
          (previouslyPurchasedProduct) async {
            lastItemCount = previouslyPurchasedProduct.data1?.length ?? 0;
            pastProductData.addAll(previouslyPurchasedProduct.data1!);
            emit(ProductHistoryTncResponseState(
                previouslyPurchasedProduct, termsConditionsResponse));
          },
        );
      } catch (e) {
        lastItemCount = 0;
        isPageLoading = false;
      }
    } else {
      lastItemCount = 0;
      isPageLoading = false;
      emit(NoInternetConnection());
    }
  }

  Future<void> getPreviouslyPurchasedProduct(
      PurchaseProductHistoryRequestModel requestModel,
      MPartnerRemoteDataSource baseMPartnerRemoteDataSource,
      SolarRemoteDataSource baseSolarRemoteDataSource) async {
    emit(LoadingState());
    pastProductData.clear();
    var isConnected = await InternetUtil.getInstance().isInternetConnected();
    if (isConnected) {
      try {
        var result = await baseMPartnerRemoteDataSource
            .getPreviouslyPurchasedProduct(requestModel);
        result.fold(
          (failure) {
            fetchTermsAndCondition(
                baseSolarRemoteDataSource, previouslyPurchasedProduct);
          },
          (previouslyPurchasedProduct) async {
            lastItemCount = previouslyPurchasedProduct.data1?.length ?? 0;
            pastProductData.addAll(previouslyPurchasedProduct.data1!);
            fetchTermsAndCondition(
                baseSolarRemoteDataSource, previouslyPurchasedProduct);
          },
        );
      } catch (e) {
        fetchTermsAndCondition(
            baseSolarRemoteDataSource, previouslyPurchasedProduct);
      }
    } else {
      emit(NoInternetConnection());
    }
  }

  Future<void> fetchTermsAndCondition(
      SolarRemoteDataSource baseSolarRemoteDataSource,
      PurchaseProductHistoryResponseModel previouslyPurchasedProduct) async {
    var isConnected = await InternetUtil.getInstance().isInternetConnected();
    if (isConnected) {
      try {
        final result = await baseSolarRemoteDataSource
            .getTermsAndConditionList("mPartnerTertiary");
        result.fold(
          (failure) {},
          (tncResponse) async {
            termsConditionsResponse = tncResponse;
            emit(ProductHistoryTncResponseState(
                previouslyPurchasedProduct, tncResponse));
          },
        );
      } catch (e) {
        //  emit(const ErrorState("Failed to fetch data"));
      }
    } else {
      emit(NoInternetConnection());
    }
  }
}
