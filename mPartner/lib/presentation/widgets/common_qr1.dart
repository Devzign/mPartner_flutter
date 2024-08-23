import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/serial_no_existance_model.dart';
import '../../lms/utils/app_text_style.dart';
import '../../state/contoller/tertiary_sales_combo_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_string.dart';
import '../../utils/common_methods.dart';
import '../../utils/displaymethods/display_methods.dart';
import '../../utils/localdata/language_constants.dart';
import '../../utils/routes/app_routes.dart';
import '../screens/our_products/components/title_bottom_modal.dart';
import 'buttons/primary_button.dart';
import 'headers/back_button_header_widget.dart';
import 'horizontalspace/horizontal_space.dart';
import 'qr_toast_message.dart';
import 'verticalspace/vertical_space.dart';

class BarcodeAndQRScanner extends StatefulWidget {
  BarcodeAndQRScanner({
    super.key,
    this.useFunction = false,
    this.isScanInverter = false,
    required this.routeWidget,
    this.subtitle,
    this.title,
    required this.showBottomModal,
    required this.onBackButtonPressedWithController,
    required this.onBackButtonPressed,
  });

  final bool useFunction, isScanInverter;
  final String? subtitle, title;
  VoidCallback onBackButtonPressed;
  void Function(Function stopScanResults, Function startScanResults)
  onBackButtonPressedWithController;


  final Widget routeWidget;
  final bool showBottomModal;
  bool isApiLoading = false;
  @override
  _BarcodeAndQRScannerState createState() => _BarcodeAndQRScannerState();
}

class _BarcodeAndQRScannerState extends State<BarcodeAndQRScanner>
    with WidgetsBindingObserver {
  String overlayText = "Please scan QR Code";
  bool isCamActive = false;
  // bool toCheckResults = true;
  FToast fToast = FToast();
  BarcodeCapture? barcodeForImage;
  bool isErrorToastShowing = false;
  StreamSubscription<Object?>? _subscription;
  bool torchEnabled = false;
  var textFieldController = TextEditingController();
  dynamic titleEnterProductSerialNumberError;
  final FocusNode _focusNodeSerialTextField = FocusNode();
  bool isScan = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        if(isScan){
          _subscription = controller.barcodes.listen(onBarcodeDetect);
          unawaited(controller.start());
        }
      case AppLifecycleState.inactive:
        if(isScan){
          unawaited(_subscription?.cancel());
          _subscription = null;
          unawaited(controller.stop());
        }
    }
  }

  void stopScanResults() async {
    controller.stop();
    setState(() {
      AppConstants.toCheckResults = false;
    });
  }

  static const _cameraResolution = Size(1080, 1080);

  void startScanResults() {
    controller.start();
    setState(() {
      AppConstants.toCheckResults = true;
    });
  }

  MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.all],
    returnImage: true,
    cameraResolution: _cameraResolution,
    detectionSpeed: DetectionSpeed.unrestricted,
  );

  Future<void> onScreenApiCallAndLogic(String serialNo) async {
    setState(() {
      widget.isApiLoading = true;
    });
    TertiarySalesHKVAcombo comboController = Get.find();
    ApiResponse checkSerialNoExistense = await MPartnerRemoteDataSource()
        .checkSerialNoExistence(serialNo, AppConstants.tertiaryComboSaleType);

    if (checkSerialNoExistense.data[0].wrsEntryStatus != "ok") {
      setState(() {
        widget.isApiLoading = false;
      });
      wrongScan(checkSerialNoExistense.data[0].wrsEntryStatus, null);
    } else {
      try {
        final result = await MPartnerRemoteDataSource().getHkvaCombo(serialNo);
        result.fold((failure) {
          wrongScan(translation(context).somethingWentWrong, null);
        }, (r) {
          comboController.messageToDisplay(r.message);
          comboController.hkvaItemModels(r.data);
          if (r.message.isNotEmpty) {
            wrongScan(comboController.messageToDisplay.value,
                translation(context).wrongProductScan);
          } else {
            fToast.removeCustomToast();
            popAndPushRoutingLogic();
          }
        });
      } catch (e) {
        wrongScan(translation(context).somethingWentWrong, null);
      } finally {
        setState(() {
          widget.isApiLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);
    AppConstants.toCheckResults = true;


    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(onBarcodeDetect);

    // Finally, start the scanner itself.
    unawaited(controller.start());

  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    _focusNodeSerialTextField.dispose();
    textFieldController.dispose();
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    await controller.dispose();
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
  }

  bool screenStatus() {
    if (AppConstants.toCheckResults) {
      return true;
    } else {
      if (barcodeForImage == null) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool _basicSerialNumberCheck(String input) {
    bool isAlphanumeric = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(input);
    bool isExactly14Chars = input.length == 14;
    return isAlphanumeric && isExactly14Chars;
  }

  void directRoutingLogic(String result) {
    fToast.removeCustomToast();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(arguments: result),
        builder: (context) => widget.routeWidget,
      ),
    );
  }

  void onBarcodeDetect(BarcodeCapture barcodeCapture) {
    isScan = true;
    String qrCodes = "";
    for (Barcode codes in barcodeCapture.barcodes) {
      qrCodes += "${codes.rawValue!} | ";
    }
    logger.d(
        "CommonQr onBarcodeDetect(${AppConstants.toCheckResults}):=> $qrCodes SIZE: ${barcodeCapture.size}");

    if (AppConstants.toCheckResults) {
      stopScanResults();
      final barcode = barcodeCapture.barcodes.last;
      overlayText = barcodeCapture.barcodes.last.displayValue ??
          barcode.rawValue ??
          'Barcode has no displayable value';
      barcodeForImage = barcodeCapture;
      setState(() {
        fToast.init(context);
        if (_basicSerialNumberCheck(overlayText)) {
          _showToast(fToast, overlayText, true);
          setState(() {
            isErrorToastShowing = false;
          });
        } else {
          if (isErrorToastShowing == false) {
            _showToast(fToast, overlayText, false);
          }
        }
        barcodeForImage=null;
      //  controller.start();
        //  toCheckResults= true;
        if (widget.showBottomModal) {
          bottomSheetLogic(overlayText);
        } else if (widget.useFunction) {
          onScreenApiCallAndLogic(overlayText);
        } else {
          directRoutingLogic(overlayText);
        }
      });
    }
  }

  void wrongScan(String message, String? title) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        useSafeArea: true,
        showDragHandle: false,
        isDismissible: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28 * r),
                topRight: Radius.circular(28 * r))),
        backgroundColor: AppColors.white,
        context: context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 32 * h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 36 * h,
                    child: Center(
                      child: Opacity(
                        opacity: 0.40,
                        child: Container(
                          width: 32 * w,
                          height: 4 * h,
                          decoration: ShapeDecoration(
                            color: AppColors.bottomSheetDragHandleColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100 * r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  titleBottomModal(
                      title: title ?? translation(context).scanFailed,
                      onPressed: ()  {
                        if(isScan){
                          startScanResults();
                        }
                        Navigator.pop(context);
                      }),
                  const VerticalSpace(height: 20),
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGrey,
                      fontSize: 14 * f,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.25,
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    PrimaryButton(
                        buttonText: translation(context).titleRetry,
                        buttonHeight: 48,
                        onPressed: ()  {
                          if(isScan){
                            startScanResults();
                          }
                          Navigator.pop(context);
                        },
                        isEnabled: true),
                  ])
                ],
              ),
            ),
          );
        });
  }

  void popAndPushRoutingLogic() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.comboScreen,
    );
  }

  Future<void> bottomSheetLogic(String result) async {
    double r = DisplayMethods(context: context).getPixelMultiplier();
   await showModalBottomSheet(
        routeSettings: RouteSettings(arguments: result),
        isScrollControlled: true,
        enableDrag: false,
        useSafeArea: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28 * r),
                topRight: Radius.circular(28 * r))),
        backgroundColor: AppColors.white,
        context: context,
        builder: (BuildContext context) {
          return PopScope(canPop: false, child: widget.routeWidget);
        }).then((onValue){
          if(isScan)
     controller.start();
   });
  }

  void setErrorToastBooleanFalse() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isErrorToastShowing = false;
        });
      }
    });
  }

  void _showToast(FToast fToast, String scanResult, bool isSuccess) {
    setState(() {
      isErrorToastShowing = true;
    });
    setErrorToastBooleanFalse();
    return fToast.showToast(
      positionedToastBuilder: (context, child) {
        double offsetPadding =
            (MediaQuery.of(context).size.width - (266 * w)) / 2;
        return Positioned(
          top: _scanWindowHeight,
          left: offsetPadding,
          right: offsetPadding,
          child: child,
        );
      },
      child: QrToastMessageBody(serialNo: scanResult, isSuccess: isSuccess),
    );
  }

  late double _scanWindowWidth;
  late double _scanWindowHeight;
  final double _headerOffset = 60;
  late final double _textOffSet = widget.subtitle.isNull ? 22 : 36;
  late double h = DisplayMethods(context: context).getVariablePixelHeight();
  late double w = DisplayMethods(context: context).getVariablePixelWidth();
  late double f = DisplayMethods(context: context).getTextFontMultiplier();
  late double r = DisplayMethods(context: context).getPixelMultiplier();
  final OutlineInputBorder focusedOutlineInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(color: AppColors.lumiBluePrimary),
  );

  final OutlineInputBorder enabledOutlineInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(color: AppColors.dividerColor),
  );

  final OutlineInputBorder errorOutlineInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(color: AppColors.errorRed),
  );

  RegExp regexQR = RegExp(r'^[a-zA-Z0-9]+$');
  bool isValidScanner = false;

  void validateQR(String qrSerialNumber) {
    if (qrSerialNumber.isEmpty) {
      setState(() {
        titleEnterProductSerialNumberError =
            translation(context).titleEnterProductSerialNumber;
        isValidScanner = false;
      });
    } else if (!regexQR.hasMatch(qrSerialNumber)) {
      setState(() {
        titleEnterProductSerialNumberError = translation(context).titleEnterNumber;
        isValidScanner = false;
      });
    } else if (qrSerialNumber.length < 14) {
      setState(() {
        titleEnterProductSerialNumberError = translation(context).titleEnterNumber;
        isValidScanner = false;
      });
    } else {
      setState(() {
        titleEnterProductSerialNumberError = null;
        isValidScanner = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _scanWindowWidth = MediaQuery.of(context).size.width * 0.8;
    _scanWindowHeight = MediaQuery.of(context).size.height * 0.3;
    double offsetWidth = MediaQuery.of(context).size.width / 2;
    double offsetHeight = (MediaQuery.of(context).size.height / 2) -
        _scanWindowHeight +
        ((_headerOffset - _textOffSet) * h + _textOffSet * f);

    final scanWindow = Rect.fromCenter(
      center: Offset(offsetWidth, offsetHeight),
      width: _scanWindowWidth,
      height: _scanWindowHeight,
    );

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          barcodeForImage = null;
        });
        if (widget.useFunction) {
          widget.onBackButtonPressedWithController(
              stopScanResults, startScanResults);
        }
        return !widget.useFunction;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  textFieldController.clear();
                  unFocus();
                  startScanResults();
                },
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: screenStatus(),
                      replacement: Expanded(
                        child: barcodeForImage?.image != null
                            ? Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Image(
                                gaplessPlayback: true,
                                image:
                                MemoryImage(barcodeForImage!.image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            CustomPaint(
                              painter: ScannerOverlay(scanWindow),
                              child: _customPaintChild(),
                            ),
                          ],
                        )
                            : Stack(
                          children: [
                            CustomPaint(
                              painter: ScannerOverlay(scanWindow),
                              child: _customPaintChild(),
                            ),
                          ],
                        ),
                      ),
                      child: Expanded(
                        child: Stack(
                          children: [
                            MobileScanner(
                              // onDetect: onBarcodeDetect,
                              controller: controller,
                              scanWindow: scanWindow,
                              errorBuilder: (context, error, child) {
                                return ScannerErrorWidget(error: error);
                              },
                            ),
                            CustomPaint(
                              painter: ScannerOverlay(scanWindow),
                              child: _customPaintChild(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Add the circular loader
              if (widget.isApiLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.white),
                ),
              Positioned(
                  bottom: 0, left: 0, right: 0, child: serialNoTextFieldView())
            ],
          ),
        ),
      ),
    );
  }

  void unFocus() {
    setState(() {
      _focusNodeSerialTextField.unfocus();
    });
  }

  Widget serialNoTextFieldView() {
    return Container(
      alignment: Alignment.center,
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          color: AppColors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vSpace(25),
          Text(
            translation(context).titleUnableScan,
            style: AppTextStyle.getStyle(
                color: AppColors.darkGreyText,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          vSpace(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: getMobileWidth(context) * 0.7,
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.allow(regexQR)],
                  focusNode: _focusNodeSerialTextField,
                  textCapitalization: TextCapitalization.characters,
                  maxLines: 1,
                  maxLength: 14,
                  onTap: () {
                    isScan = false;
                    setState(() {
                      stopScanResults();
                    });
                  },
                  onChanged: (value) {
                    validateQR(value);
                    // if (textFieldController.text.isNotEmpty) {
                    //   setState(() {
                    //     titleEnterProductSerialNumberError = null;
                    //   });
                    // }
                  },
                  controller: textFieldController,
                  textInputAction: TextInputAction.none,
                  decoration: InputDecoration(
                    counterText: "",
                    label: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                            translation(context).titleEnterProductSerialNumber,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.40,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.poppins(
                              color: AppColors.errorRed,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: focusedOutlineInputBorder,
                    enabledBorder: enabledOutlineInputBorder,
                    errorBorder: errorOutlineInputBorder,
                    focusedErrorBorder: errorOutlineInputBorder,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    hintText: translation(context).titleEnterNumber,
                    errorText: titleEnterProductSerialNumberError,
                    hintStyle: AppTextStyle.getStyle(
                        color: AppColors.hintColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                  ),
                ),
              ),
              hSpace(10),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: isValidScanner
                        ? AppColors.lumiBluePrimary
                        : AppColors.lumiLight4),
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onSerialNoSubmit();
                  },
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  onSerialNoSubmit() {
    isScan = false;
    if (isValidScanner) {
      if (textFieldController.text.isEmpty) {
        setState(() {
          titleEnterProductSerialNumberError =
              translation(context).titleEnterProductSerialNumber;
        });
      } else {
        var serialNumber = textFieldController.text;
        textFieldController.clear();
        setState(() {
          titleEnterProductSerialNumberError = null;
        });
        setState(() {
          fToast.init(context);
          if (_basicSerialNumberCheck(serialNumber)) {
            _showToast(fToast, serialNumber, true);
            setState(() {
              isErrorToastShowing = false;
            });
          } else {
            if (isErrorToastShowing == false) {
              _showToast(fToast, serialNumber, false);
            }
          }

          if (widget.showBottomModal) {
            bottomSheetLogic(serialNumber);
          } else if (widget.useFunction) {
            onScreenApiCallAndLogic(serialNumber);
          } else {
            directRoutingLogic(serialNumber);
          }
        });
      }
    }
  }

  Widget _customPaintChild() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24 * w),
      child: Column(
        children: [
          const VerticalSpace(height: 24),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderWidgetWithBackButton(
                onPressed: () => {
                  setState(() {
                    barcodeForImage = null;
                  }),
                  !widget.useFunction
                      ? widget.onBackButtonPressed()
                      : widget.onBackButtonPressedWithController(
                      stopScanResults, startScanResults),
                },
                heading: widget.title ?? translation(context).scanBarCode,
                textColor: AppColors.white,
                iconColor: AppColors.white,
                topPadding: 0,
                leftPadding: 0,
              ),
              GestureDetector(
                onTap: () async {
                  // Toggle torch state when tapped
                  await controller.toggleTorch();
                  setState(() {
                    torchEnabled = !torchEnabled;
                  }); // Trigger UI update
                },
                child: SizedBox(
                  width: 24 * w,
                  height: 24 * h,
                  child: Icon(
                    torchEnabled ? Icons.flash_on : Icons.flash_off,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          if (widget.subtitle != null) ...{
            const VerticalSpace(height: 4),
            Row(
              children: [
                const HorizontalSpace(width: 38),
                Text(
                  widget.subtitle ?? "",
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 14 * f,
                    height: 24 / 14,
                    fontWeight: FontWeight.w300,
                    // letterSpacing: 0.50,
                  ),
                ),
              ],
            ),
          },
          SizedBox(
            height: _scanWindowHeight + (_headerOffset * h),
            width: _scanWindowWidth,
          ),
          Column(
            children: [
              Text(
                translation(context).centerTheBarCodeWithinTheBox,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 16 * f,
                  height: 24 / 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.50,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpace(height: 8),
              Visibility(
                visible: widget.isScanInverter,
                child: Text(
                  translation(context).scanAnInverterFirst,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 16 * f,
                    height: 24 / 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;
  final double borderRadius = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: AppColors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: AppColors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
