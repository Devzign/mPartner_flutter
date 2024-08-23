import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/new_warranty_model.dart';
import '../../utils/utils.dart';

class WarrantyController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  var isLengthValid = false.obs;
  var urlToDownload = "".obs;
  var pdfExist = false.obs;
  var isPdfLoading = false.obs;
  RxString primarySaleDate = "".obs;
  RxString secondarySaleDate = "".obs;
  RxString intermediarySaleDate = "".obs;
  RxString tertiarySaleDate = "".obs;

  var newWarranty = NewWarranty(
    status: "",
    message: "",
    serialNo: "",
    imgUrl: "",
    modelName: "",
    primaryDate: "",
    primarySoldTo: "",
    secondaryDate: "",
    secondarySoldTo: "",
    intermediateDate: "",
    intermediateSoldBy: "",
    intermediateSoldTo: "",
    tertiaryDate: "",
    tertiarySoldBy: "",
    tertiarySoldTo: "",
    finalStatus: "",
    mfgDate: "",
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  void fetchWarranty(String serialNumber) async {
    try {
      isLoading(true);

      final result =
          await mPartnerRemoteDataSource.getWarrantyDetails(serialNumber);
      result.fold(
        (failure) {
          error('Failed to fetch warranty information: $failure');
          newWarranty(NewWarranty(
            status: "",
            message: "",
            serialNo: "",
            imgUrl: "",
            modelName: "",
            primaryDate: "",
            primarySoldTo: "",
            secondaryDate: "",
            secondarySoldTo: "",
            intermediateDate: "",
            intermediateSoldBy: "",
            intermediateSoldTo: "",
            tertiaryDate: "",
            tertiarySoldBy: "",
            tertiarySoldTo: "",
            finalStatus: "",
            mfgDate: "",
          ));
        },
        (warrantyData) {
          newWarranty.value = warrantyData;
        },
      );
    } finally {
      isLoading(false);
    }
  }

  void getWarrantyPdfUrl(String serialNumber) async {
    try {
      isPdfLoading.value = true;
      final result =
          await mPartnerRemoteDataSource.getWarrantyPdf(serialNumber);

      result.fold(
        (failure) {
          error('Failed to fetch warranty information: $failure');
          urlToDownload.value = "";
          pdfExist.value = false;
        },
        (r) async {
          if (await canLaunchUrlString(r)) {
            pdfExist.value = true;
            urlToDownload.value = r;
          } else {
            pdfExist.value = false;
            urlToDownload.value = "";
          }
        },
      );
    } finally {
      isPdfLoading.value = false;
    }
  }

  void fetchSalesDates(String serialNumber) async {
    try {
      // isPdfLoading.value = true;
      final result =
          await mPartnerRemoteDataSource.fetchSellingDate(serialNumber);

      result.fold(
        (failure) {
          error('Failed to fetch warranty information: $failure');
          urlToDownload.value = "";
          pdfExist.value = false;
        },
        (resultResponse) async {
          primarySaleDate.value = convertDateStringToFormatDate(
              resultResponse[0]['primarySaleDate'] ?? "");
          secondarySaleDate.value = convertDateStringToFormatDate(
              resultResponse[0]['secondarySaleDate'] ?? "");
          intermediarySaleDate.value = convertDateStringToFormatDate(
              resultResponse[0]['intermediarySaleDate'] ?? "");
          tertiarySaleDate.value = convertDateStringToFormatDate(
              resultResponse[0]['tertiarySaleDate'] ?? "");
        },
      );
    } catch (e) {
      print(e);
    } finally {
      // isPdfLoading.value = false;
    }
  }

  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    textController.addListener(_isLengthValid);
  }

  void _isLengthValid() {
    final text = textController.text;
    isLengthValid.value = textController.text.length == 14;
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
