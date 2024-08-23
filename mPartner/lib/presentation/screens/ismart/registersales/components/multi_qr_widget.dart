import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../lms/utils/app_text_style.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/common_methods.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/common_bottom_sheet.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/headers/sales_header_widget.dart';
import '../../../../widgets/qr_toast_message.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../secondarysales/components/serial_number_existance_model.dart';
import '../secondarysales/sales_reg.dart';
import '../uimodels/customer_info.dart';
import '../uimodels/dealer_info.dart';
import '../uimodels/electrician_info.dart';
import 'custom_alert_widget.dart';
import 'custom_bs_header.dart';
import 'serial_number_list_widget.dart';

class MultiQRScanner extends StatefulWidget {
  final DateTime? selectedDate;
  final String? saleTime;
  final DealerInfo? selectedDealer;
  final CustomerInfo? customer;
  final ElectricianInfo? electrician;
  final String saleType;

  const MultiQRScanner(
      {this.selectedDate,
        this.saleTime,
        required this.saleType,
        this.selectedDealer,
        this.customer,
        this.electrician,
        super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class ScannerErrorWidget extends StatelessWidget {
  final MobileScannerException error;

  const ScannerErrorWidget({super.key, required this.error});

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
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  final Rect scanWindow;

  final double borderRadius = 12.0;
  ScannerOverlay(this.scanWindow);

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

class _QRViewExampleState extends State<MultiQRScanner>
    with WidgetsBindingObserver {
  static const _cameraResolution = Size(1080, 1080);

  List<SerialNumberExistanceModel> result = [];


  late final double _variablePixelWidth =
  DisplayMethods(context: context).getVariablePixelWidth();
  late final double _variablePixelHeight =
  DisplayMethods(context: context).getVariablePixelHeight();
  late final double _variablePixelMultiplier =
  DisplayMethods(context: context).getPixelMultiplier();
  late final double _variableTextMultiplier =
  DisplayMethods(context: context).getTextFontMultiplier();

  final GlobalKey<SerialNumberListWidgetState> _serialNumberListKey =
  GlobalKey();
  final FToast _fToast = FToast();

  bool isBottomSheetOpen = false;
  Uint8List? _scannedQRImage;
  Uint8List? _submitScanImage;
  bool torchEnabled = false;
  bool toCheckResults = true;

  var textFieldController = TextEditingController();
  dynamic titleEnterProductSerialNumberError;
  final FocusNode _focusNodeSerialTextField = FocusNode();
  bool isScan = true;

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

  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.all],
    returnImage: true,
    cameraResolution: _cameraResolution,
    detectionSpeed: DetectionSpeed.unrestricted,
  );

  StreamSubscription<Object?>? _subscription;

  var mPartnerRemoteDataSource = MPartnerRemoteDataSource();

  UserDataController userController = Get.find();

  late double _scanWindowWidth;
  late double _scanWindowHeight;
  final double _headerOffset = 50;

  void _bottomSheetClose() {
    setState(() {
      isBottomSheetOpen = false;
    });
  }

  void _bottomSheetOpen() {
    setState(() {
      isBottomSheetOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _scanWindowWidth = MediaQuery.of(context).size.width * 0.8;
    _scanWindowHeight = MediaQuery.of(context).size.height * 0.3;
    double offsetWidth = MediaQuery.of(context).size.width / 2;
    double offsetHeight = (MediaQuery.of(context).size.height / 2) -
        _scanWindowHeight +
        (_headerOffset * _variablePixelHeight);

    final scanWindow = Rect.fromCenter(
      center: Offset(offsetWidth, offsetHeight),
      width: _scanWindowWidth,
      height: _scanWindowHeight,
    );

    return WillPopScope(
      onWillPop: () async {
        result.isNotEmpty
            ? {
          setState(() {
            _scannedQRImage = null;
          }),
          _stopScanResults(),
          _bottomSheetOpen(),
          CommonBottomSheet.show(
              context,
              _buildConfirmationAlertBS(
                  translation(context).confirmationAlert,
                  translation(context).goingBackWillDelete,
                  translation(context).sureToContinue,
                  _onPressedBack),
              _variablePixelHeight,
              _variablePixelWidth)
              .then((_) {
            _bottomSheetClose();
            _startScanResults();
          }),
        }
            : Navigator.of(context).pop();

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Stack(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: (_scannedQRImage != null)
                        ? Image(
                      gaplessPlayback: true,
                      image: MemoryImage(_scannedQRImage!),
                      fit: BoxFit.cover,
                    )
                        : MobileScanner(
                      controller: _controller,
                      scanWindow: scanWindow,
                      errorBuilder: (context, error, child) {
                        return ScannerErrorWidget(error: error);
                      },
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      textFieldController.clear();
                      unFocus();
                      _startScanResults();
                    },
                    child: CustomPaint(
                      painter: ScannerOverlay(scanWindow),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24 * _variablePixelWidth),
                            child: Column(
                              children: [
                                const VerticalSpace(height: 24),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_outlined,
                                            color: AppColors.white,
                                            size: 24 * _variablePixelMultiplier,
                                          ),
                                          onPressed: () {
                                            setState(() {});
                                            result.isNotEmpty
                                                ? _showConfirmationBSOnBackPressed(
                                                context)
                                                : Navigator.of(context).pop();
                                          },
                                        ),
                                        Text(
                                          "${widget.saleType} Sales",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.poppins(
                                            color:  AppColors.white,
                                            fontSize: AppConstants.FONT_SIZE_LARGE * _variableTextMultiplier,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        // Toggle torch state when tapped
                                        await _controller.toggleTorch();
                                        setState(() {
                                          torchEnabled = !torchEnabled;
                                        }); // Trigger UI update
                                      },
                                      child: SizedBox(
                                        width: 24 * _variablePixelMultiplier,
                                        height: 24 * _variablePixelMultiplier,
                                        child: Icon(
                                          torchEnabled
                                              ? Icons.flash_on
                                              : Icons.flash_off,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: _scanWindowHeight +
                                      (_headerOffset / 2 * _variablePixelHeight),
                                  width: _scanWindowWidth,
                                ),
                                Text(
                                  translation(context)
                                      .centerTheBarCodeWithinTheBox,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.white,
                                    fontSize: 16 * _variableTextMultiplier,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                    height: 24 / 16,
                                  ),
                                ),
                                const VerticalSpace(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // serialNoTextFieldView(),
                        Visibility(
                          visible: result.isNotEmpty,
                          child: _buildSerialNumberListWidget(),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
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
                  textCapitalization: TextCapitalization.characters,
                  focusNode: _focusNodeSerialTextField,
                  maxLines: 1,
                  maxLength: 14,
                  onTap: () {
                    isScan = false;
                    setState(() {
                      _stopScanResults();
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

  onSerialNoSubmit() async {
    isScan = false;
    if (isValidScanner) {
      if (textFieldController.text.isEmpty) {
        setState(() {
          titleEnterProductSerialNumberError =
              translation(context).titleEnterProductSerialNumber;
        });
      } else {
        setState(() {
          titleEnterProductSerialNumberError = null;
        });

        if (result.length < 50) {
          _stopScanResults(disableScanController: false);
          String barcodeVal = textFieldController.text;
          textFieldController.clear();
          if (!_isValidQrCode(barcodeVal)) {
            _fToast.init(context);
            _showToast(_fToast, barcodeVal, false);
            if (isBottomSheetOpen == false) {
              // setState(() {
              //   _scannedQRImage = barcodeCapture.image;
              // });
              _showScanFailed();
            }
          } else if (result.isNotEmpty && result.where((model) =>model.barcodevalue.toString().toLowerCase() == barcodeVal.toString().toLowerCase()).toList().isNotEmpty) {
            if (isBottomSheetOpen == false) {
              // setState(() {
              //   _scannedQRImage = barcodeCapture.image;
              // });
              showErrorMessageBottomSheet(
                  translation(context).productAlreadyScanned);
            }
          } else {
            String errorMsg = "";
            bool serialNoExists = false;
            String modelName="";
            await checkSerialNoRequest(barcodeVal).then((value) {
              SerialNumberExistanceModel model=value;
              modelName=model.modelName;
              errorMsg = model.message;
              serialNoExists = model.status == "ok" ? true : false;
            });

            if (serialNoExists) {
              _stopScanResults();
              _fToast.init(context);
              //  _submitScanImage = barcodeCapture.image;
              //   Timer(const Duration(seconds: 2), () {
              //     barcodeCapture.barcodes.removeRange(0, barcodeCapture.barcodes.length - 1);
              //     _startScanResults();
              //   });
              setState(() {
                result.insert(0, new SerialNumberExistanceModel(status: "", modelName: modelName, message:"",barcodevalue: barcodeVal));
              });
              _showToast(_fToast, barcodeVal, true);
            } else {
              // setState(() {
              //   _scannedQRImage = barcodeCapture.image;
              // });
              showErrorMessageBottomSheet(errorMsg);
            }
          }
        }
      }
    }
  }

  Future<SerialNumberExistanceModel> checkSerialNoRequest(String code) async {
    bool isTertiary = widget.saleType == "Tertiary";

    SerialNumberExistanceModel res = await mPartnerRemoteDataSource.fetchSrNoExistance(
        code,
        isTertiary ? widget.customer!.mobileNo : userController.phoneNumber,
        isTertiary
            ? widget.customer!.saleDate
            : DateFormat('dd/MM/yyyy').format(widget.selectedDate!).toString(),
        isTertiary);
    return res;
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.resumed:
        if(isScan){
          _subscription = _controller.barcodes.listen(_onQRCaptured);
           unawaited(_controller.start());
        }
      case AppLifecycleState.inactive:
        if(isScan){
          unawaited(_subscription?.cancel());
          _subscription = null;
          unawaited(_controller.stop());
        }
    }
  }

  void unFocus() {
    setState(() {
      _focusNodeSerialTextField.unfocus();
    });
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _focusNodeSerialTextField.dispose();
    textFieldController.dispose();
    _subscription = null;
    _controller.stop(); // Stop the scanner if it's running
    await _controller.dispose();
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
  }

  @override
  void initState() {
    super.initState();

    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = _controller.barcodes.listen(_onQRCaptured);

    // Finally, start the scanner itself.
    unawaited(_controller.start());
  }

  bool _isValidQrCode(String input) {
    bool isAlphanumeric = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(input);
    bool isExactly14Chars = input.length == 14;
    return isAlphanumeric && isExactly14Chars;
  }

  void showErrorMessageBottomSheet(String errorMessage) {
    _bottomSheetOpen();
    _stopScanResults();
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      showDragHandle: true,
      isDismissible: false,
      isScrollControlled: false,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0 * _variablePixelMultiplier),
        ),
      ),
      builder: (context) => WillPopScope(
        onWillPop: () async {
          setState(() {
            _scannedQRImage = null;
          });
          _bottomSheetClose();
          Navigator.of(context).pop();
          if(isScan){
            _startScanResults();
          }
          return false;
        },
        child: Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    24 * _variablePixelWidth,
                    8 * _variablePixelHeight,
                    24 * _variablePixelWidth,
                    0 * _variablePixelHeight),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              _scannedQRImage = null;
                            });
                            Navigator.pop(context);
                            _bottomSheetClose();
                            if(isScan){
                              _startScanResults();
                            }
                          },
                          child: const Icon(
                            Icons.close,
                            color: AppColors.titleColor,
                          )),
                      SizedBox(height: 6 * _variablePixelHeight),
                      Text(
                        translation(context).scanFailed,
                        style: GoogleFonts.poppins(
                          color: AppColors.titleColor,
                          fontSize: 20 * _variableTextMultiplier,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    24 * _variablePixelWidth,
                    16 * _variablePixelHeight,
                    24 * _variablePixelWidth,
                    0 * _variablePixelHeight),
                child: Container(
                  height: 1 * _variablePixelHeight,
                  color: AppColors.bottomSheetSeparatorColor,
                  margin:
                  EdgeInsets.symmetric(vertical: 8 * _variablePixelHeight),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    24 * _variablePixelWidth,
                    24 * _variablePixelHeight,
                    16 * _variablePixelWidth,
                    16 * _variablePixelHeight),
                child: Text(
                  errorMessage,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGrey,
                    fontSize: 14 * _variableTextMultiplier,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.25,
                    height: 20 / 14,
                  ),
                ),
              ),
              CommonButton(
                  onPressed: () {
                    setState(() {
                      _scannedQRImage = null;
                    });
                    Navigator.pop(context);
                    _bottomSheetClose();
                    if(isScan){
                      _startScanResults();
                    }
                  },
                  isEnabled: true,
                  bottomPadding: 32,
                  buttonText: translation(context).okIUnderstand,
                  containerBackgroundColor: AppColors.lightWhite1,
                  containerHeight: _variablePixelHeight * 56),
            ],
          ),
        ),
      ),
    ).then((_) {
      setState(() {
        setState(() {
          _scannedQRImage = null;
        });
        _bottomSheetClose();
        if(isScan){
          _startScanResults();
        }
      });
    });
  }

  void _startScanResults({bool disableScanController = true}) {
    if (!isBottomSheetOpen) {
      setState(() {
        if (disableScanController) {
          _subscription = _controller.barcodes.listen(_onQRCaptured);
          unawaited(_controller.start());
        }
        toCheckResults = true;
      });
    }
  }

  void _stopScanResults({bool disableScanController = true}) {
    if (disableScanController) {
      unawaited(_subscription?.cancel());
      _subscription = null;

      unawaited(_controller.stop());
    }
    setState(() {
      toCheckResults = false;
    });
  }

  Widget _buildConfirmationAlertBS(title, description, promptQues, onPressedYes,
      {isSingleButton = false}) {
    return Column(
      children: [
        CustomBSHeaderWidget(
          title: title,
          onClose: () {
            _bottomSheetClose();
            Navigator.of(context).pop();
            if(isScan){
              _startScanResults();
            }
          },
        ),
        SizedBox(
          height: 8 * _variablePixelHeight,
        ),
        CustomAlertWidget(
          description: description,
          promptQues: promptQues,
          onPressedYes:  onPressedYes,
          // onPressedYes: (){
          //   _bottomSheetClose();
          //   Navigator.of(context).pop();
          //   if(isScan){
          //     _startScanResults();
          //   }
          //
          // },
          onPressedNo: () {
            _bottomSheetClose();
            Navigator.of(context).pop();
            if(isScan){
              _startScanResults();
            }
          },
          isSingleButton: isSingleButton,
        )
      ],
    );
  }

  Widget _buildConfirmationAlertFailed(title, description, promptQues, onPressedYes,
      {isSingleButton = false}) {
    return Column(
      children: [
        CustomBSHeaderWidget(
          title: title,
          onClose: () {
            _bottomSheetClose();
            Navigator.of(context).pop();
            if(isScan){
              _startScanResults();
            }
          },
        ),
        SizedBox(
          height: 8 * _variablePixelHeight,
        ),
        CustomAlertWidget(
          description: description,
          promptQues: promptQues,

          onPressedYes: (){
            _bottomSheetClose();
            Navigator.of(context).pop();
            if(isScan){
              _startScanResults();
            }

          },
          onPressedNo: () {
            _bottomSheetClose();
            Navigator.of(context).pop();
            if(isScan){
              _startScanResults();
            }
          },
          isSingleButton: isSingleButton,
        )
      ],
    );
  }

  Widget _buildConfirmationAlertdelete(title, description, promptQues, onPressedYes, SerialNumberExistanceModel item,
      {isSingleButton = false}) {
    return Column(
      children: [
        CustomBSHeaderWidget(
          title: title,
          onClose: () {
            _bottomSheetClose();
            Navigator.of(context).pop();
            if(isScan){
              _startScanResults();
            }
          },
        ),
        SizedBox(
          height: 8 * _variablePixelHeight,
        ),
        CustomAlertWidget(
          description: description,
          promptQues: promptQues,
          onPressedYes: (){
            _handleOnDelete(item);
            // _bottomSheetClose();

            if(isScan){
              _startScanResults();
            }
          },
          onPressedNo: () {
            _bottomSheetClose();
            Navigator.of(context).pop();
            if(isScan){
              _startScanResults();
            }
          },
          isSingleButton: isSingleButton,
        )
      ],
    );
  }

  Widget _buildSerialNumberListWidget() {
    return Container(
        height: MediaQuery.of(context).size.height/3,
        decoration: BoxDecoration(
          color: AppColors.lightWhite1,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28 * _variablePixelWidth),
            topRight: Radius.circular(28 * _variablePixelWidth),
          ),

        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 28 * _variablePixelWidth,
                        vertical: 16 * _variablePixelHeight),
                    decoration: BoxDecoration(
                      color: AppColors.lightButtonBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28 * _variablePixelWidth),
                        topRight: Radius.circular(28 * _variablePixelWidth),
                      ),
                    ),
                    child: Text(
                      "${translation(context).batchEntries} (${result.length})",
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        color: AppColors.blackText,
                        fontSize: 16 * _variableTextMultiplier,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SerialNumberListWidget(
                items: result,
                saletype: widget.saleType,

                onValueRemoved: (SerialNumberExistanceModel item) {
                  setState(() {
                    _scannedQRImage = null;
                  });
                  _showConfirmationBSOnDeletePressed(context, item);
                  // setState(() {});
                },
              ),
            ),
            Visibility(
              visible: (result.length + 1) > 50,
              child: Text(
                translation(context).serialNoLimitWarning,
                maxLines: 3,
                style: GoogleFonts.poppins(
                  color: AppColors.exceedRed,
                  fontSize: 12 * _variableTextMultiplier,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: CommonButton(
                onPressed: () => (_showConfirmationBSOnSubmitPressed(context)),
                buttonText: translation(context).submit,
                isEnabled: true,
                backGroundColor: AppColors.lumiBluePrimary,
                textColor: AppColors.lightWhite1,
                containerBackgroundColor: AppColors.lightWhite1,
              ),
            ),
          ],
        ));
  }

  void _handleOnDelete(SerialNumberExistanceModel serialNum) {

    setState(() {
      result.removeWhere((item) => item.barcodevalue.toString() == serialNum.barcodevalue);
      _serialNumberListKey.currentState?.updateList(result);
    });
    Navigator.of(context).pop();
    _startScanResults(disableScanController: false);
  }

  void _navigateToProductDetailsScreen() {

    unawaited(dispose());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SalesReg(
                selectedDate: widget.selectedDate,
                saleTime: widget.saleTime,
                selectedDealer: widget.selectedDealer,
                customer: widget.customer,
                electrician: widget.electrician,
                saleType: widget.saleType,
                serialNoList: result.map((barcode) => barcode.barcodevalue).join(','))))
        .then((_) => {});
  }

  void _onPressedBack() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    unawaited(dispose());
  }

  void _onQRCaptured(BarcodeCapture barcodeCapture) async {
    isScan = true;
    String qrCodes = "";
    for (Barcode codes in barcodeCapture.barcodes){
      qrCodes += "${codes.rawValue!} | ";
    }
    logger.d("MultiQR _onQRCaptured ($toCheckResults):=> $qrCodes SIZE: ${barcodeCapture.size}");
    if (toCheckResults && result.length < 50) {
      _stopScanResults(disableScanController: false);
      String barcodeVal = barcodeCapture.barcodes.last.rawValue ?? "";
      if (!_isValidQrCode(barcodeVal)) {
        _fToast.init(context);
        _showToast(_fToast, barcodeVal, false);
        if (isBottomSheetOpen == false) {
          setState(() {
            _scannedQRImage = barcodeCapture.image;
          });
          _showScanFailed();
        }
      } else if (result.isNotEmpty && result.where((model) =>model.barcodevalue.toString().toLowerCase() == barcodeVal.toString().toLowerCase()).toList().isNotEmpty) {
        if (isBottomSheetOpen == false) {
          setState(() {
            _scannedQRImage = barcodeCapture.image;
          });
          showErrorMessageBottomSheet(
              translation(context).productAlreadyScanned);
        }
      } else {
        String errorMsg = "";
        bool serialNoExists = false;
        String modelName="";
        await checkSerialNoRequest(barcodeVal).then((value) {
          SerialNumberExistanceModel model=value;
          modelName=model.modelName;
          errorMsg = model.message;
          serialNoExists = model.status == "ok" ? true : false;
        });


        if (serialNoExists) {
          _stopScanResults();
          _fToast.init(context);
          _submitScanImage = barcodeCapture.image;
          Timer(const Duration(seconds: 2), () {
            barcodeCapture.barcodes.removeRange(0, barcodeCapture.barcodes.length - 1);
            _startScanResults();
          });
          setState(() {
            result.insert(0, new SerialNumberExistanceModel(status: "", modelName: modelName, message:"",barcodevalue: barcodeVal));
          });
          _showToast(_fToast, barcodeVal, true);
        } else {
          setState(() {
            _scannedQRImage = barcodeCapture.image;
          });
          showErrorMessageBottomSheet(errorMsg);
        }
      }
    }
  }

  void _showConfirmationBSOnBackPressed(context) {
    _stopScanResults();
    _bottomSheetOpen();
    CommonBottomSheet.show(
        context,
        _buildConfirmationAlertBS(
            translation(context).confirmationAlert,
            translation(context).goingBackWillDelete,
            translation(context).sureToContinue,
            _onPressedBack),
        _variablePixelHeight,
        _variablePixelWidth)
        .then((_) {
      _bottomSheetClose();
      _startScanResults();
    });
  }

  void _showConfirmationBSOnDeletePressed(context,SerialNumberExistanceModel item) {


    _stopScanResults(disableScanController: false);
    _bottomSheetOpen();
    CommonBottomSheet.show(
        context,
        _buildConfirmationAlertdelete(
            translation(context).confirmationAlert,
            "${translation(context).productWith} S No: ${item.barcodevalue} ${translation(context).willBeRemoved}",
            translation(context).sureToContinue, () {


        },item),
        _variablePixelHeight,
        _variablePixelWidth)
        .then((_) {
      _bottomSheetClose();
      _startScanResults(disableScanController: false);
    });
  }

  void _showConfirmationBSOnSubmitPressed(context) {
    _stopScanResults();
    setState(() {
      _scannedQRImage = _submitScanImage;
    });
    _bottomSheetOpen();
    CommonBottomSheet.show(
        context,
        _buildConfirmationAlertBS(
            translation(context).confirmationAlert,
            translation(context).entriesRegCantChanged,
            translation(context).sureToContinue,
            _navigateToProductDetailsScreen),
        _variablePixelHeight,
        _variablePixelWidth)
        .then((_) {
      setState(() {
        _scannedQRImage = null;
      });
      _bottomSheetClose();
      _startScanResults();
    });
  }

  void _showScanFailed() {
    _stopScanResults();
    _bottomSheetOpen();
    CommonBottomSheet.show(
        context,
        _buildConfirmationAlertFailed(
            translation(context).scanFailed,
            translation(context).serialNoInvalid,
            translation(context).scanFailedRemarks,
                () => () {
              Navigator.of(context).pop();
              setState(() {
                _scannedQRImage = null;
              });
              _bottomSheetClose();
              _startScanResults();
            },
            isSingleButton: true),
        _variablePixelHeight,
        _variablePixelWidth)
        .then((_) {
      setState(() {
        _scannedQRImage = null;
      });
      _bottomSheetClose();
      _startScanResults();
    });
  }

  void _showToast(FToast fToast, String scanResult, bool isSuccess) {
    return fToast.showToast(
      positionedToastBuilder: (context, child) {
        double offsetPadding =
            (MediaQuery.of(context).size.width - (266 * _variablePixelWidth)) /
                2;
        return Positioned(
          top: _scanWindowHeight,
          left: offsetPadding,
          right: offsetPadding,
          child: child,
        );
      },
      child: (isSuccess)
          ? QRToastMessage(serialNo: scanResult, isSuccess: isSuccess)
          : QrToastMessageBody(serialNo: scanResult, isSuccess: isSuccess),
    );
  }
}
