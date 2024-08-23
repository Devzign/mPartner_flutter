import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../widgets/common_button.dart';
import '../../../base_screen.dart';
import '../../../userprofile/user_profile_widget.dart';
import '../components/dropdown_bs.dart';
import '../../../../widgets/headers/sales_header_widget.dart';
import '../uimodels/dealer_info.dart';
import '../components/multi_qr_widget.dart';

class SecondarySales extends StatefulWidget {
  const SecondarySales({super.key});

  @override
  State<SecondarySales> createState() => _SecondarySalesState();
}

class _SecondarySalesState extends BaseScreenState<SecondarySales> {
  DateTime selectedDate = DateTime.now();
  String saleTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  DealerInfo? selectedDealer;
  bool isButtonEnabled = false;
  DateTime selectedDateValue=DateTime.now();
  String currentDateFormatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  late TextEditingController _dateController =
  TextEditingController(text: currentDateFormatted);
  void _handleDateSelected(DateTime value, String type) {
    print('date is $value');
    setState(() {
      selectedDate = value;
      saleTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
      print('secondary saleTime is $saleTime');
      isButtonEnabled = (selectedDealer != null);
    });
  }

  void _handleDealerSelected(DealerInfo value, String type) {
    setState(() {
      selectedDealer = value;
      isButtonEnabled = (selectedDealer != null);
    });
  }

  void _navigateToQRScanner() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MultiQRScanner(
                    saleType: 'Secondary',
                    selectedDate: selectedDate,
                    saleTime:saleTime,
                    selectedDealer: selectedDealer!)));
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                HeadingRegisterSales(
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.iconColor,
                    size: 24 * variablePixelMultiplier,
                  ),
                  heading: translation(context).secondarySale,
                  headingSize: AppConstants.FONT_SIZE_LARGE,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                UserProfileWidget(top: 8*variablePixelHeight,),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24 * variablePixelWidth),
                  width: variablePixelWidth * 393,
                  child: Text(
                    translation(context).saleToDealer,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontStyle: FontStyle.normal,
                      fontSize: 16 * variablePixelMultiplier,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(height: variablePixelHeight * 14),
                Column(
                  children: [
                    Column(
                      children: [
                        DropdownBSWidget(
                            saleType: "Secondary",
                            labelText: "${translation(context).dealerName} (Code)",
                            hintText: translation(context).selectDealer,
                            icon: Icon(Icons.keyboard_arrow_down),
                            dropDownType: "SearchableList",
                            onDateSelected: (value, type) {
                              _handleDateSelected(value, type);
                            },
                            onDealerSelected: (value, type) {
                              _handleDealerSelected(value, type);
                            }),
        
                        Container(
                          height: 60* variablePixelHeight,
                          padding: EdgeInsets.only(left: 24*variablePixelWidth,right: 24* variablePixelWidth,top: 10*variablePixelHeight),
                          child: CustomCalendarView(
                            labelText: translation(context).dateOfPurchase,
                            hintText: translation(context).selectDateFormat,
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.grey,
                            ),
                            calendarType:
                            AppConstants.singleSelectionCalenderType,
                            dateFormat: "dd/MM/yyyy",
                            initialDateSelection:selectedDateValue,
                            errorText: "",
                            calendarStartDate: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day-6),
                            calendarEndDate: DateTime.now(),
                            singleDateEditController:
                            _dateController,
                            onDateSelected: (selectedDate) {
                              print("view1 ${selectedDate}");
                              setState(() {
                                _dateController.text =selectedDate;
                                var inputFormat = DateFormat('dd/MM/yyyy');
                                var currentSelctedDate = inputFormat.parse(selectedDate);
                                selectedDateValue=currentSelctedDate;
                                _handleDateSelected(currentSelctedDate, "DatePicker");
                              });
        
                            },
                            onDateRangeSelected: (startDate, endDate) {
                              print("view2 ${startDate}- ${endDate}");
                            },
                          ),
                        ),
                       /* DropdownBSWidget(
                          saleType: "Secondary",
                          labelText: translation(context).dateOfPurchase,
                          hintText: DateFormat('dd/MM/yyyy')
                              .format(DateTime.now())
                              .toString(),
                          icon: Icon(Icons.calendar_month),
                          dropDownType: "DatePicker",
                          onDateSelected: (value, type) {
                            _handleDateSelected(value, type);
                          },
<<<<<<< HEAD
                          onDealerSelected: (value, type) {
                            _handleDealerSelected(value, type);
                          }),

                      Container(
                        height: 60* variablePixelHeight,
                        padding: EdgeInsets.only(left: 24*variablePixelWidth,right: 24* variablePixelWidth,top: 10*variablePixelHeight),
                        child: CustomCalendarView(
                          labelText: translation(context).dateOfPurchase,
                          hintText: translation(context).selectDateFormat,
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.grey,
                          ),
                          calendarType:
                          AppConstants.singleSelectionCalenderType,
                          dateFormat: "dd/MM/yyyy",
                          initialDateSelection:selectedDateValue,
                          errorText: "",
                          calendarStartDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day-6),
                          calendarEndDate: DateTime.now(),
                          singleDateEditController:
                          _dateController,
                          onDateSelected: (selectedDate) {
                            print("view1 ${selectedDate}");
                            setState(() {
                              _dateController.text =selectedDate;
                              var inputFormat = DateFormat('dd/MM/yyyy');
                              var currentSelctedDate = inputFormat.parse(selectedDate);
                              selectedDateValue=currentSelctedDate;
                              _handleDateSelected(currentSelctedDate, "DatePicker");
                            });
                          },
                          onDateRangeSelected: (startDate, endDate) {
                            print("view2 ${startDate}- ${endDate}");
                          },
                        ),
                      ),
                     /* DropdownBSWidget(
                        saleType: "Secondary",
                        labelText: translation(context).dateOfPurchase,
                        hintText: DateFormat('dd/MM/yyyy')
                            .format(DateTime.now())
                            .toString(),
                        icon: Icon(Icons.calendar_month),
                        dropDownType: "DatePicker",
                        onDateSelected: (value, type) {
                          _handleDateSelected(value, type);
                        },
                        onDealerSelected: null,
                      ),*/
                    ],
                  ),
                  SizedBox(
                    height: 384 * variablePixelHeight,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CommonButton(
                        containerBackgroundColor: AppColors.lightWhite1,
                        backGroundColor: isButtonEnabled
                            ? AppColors.lumiBluePrimary
                            : AppColors.lightButtonBackground,
                        onPressed: isButtonEnabled
                            ? _navigateToQRScanner
                            : null,
                        isEnabled: isButtonEnabled,
                        buttonText: translation(context).continueButtonText),
                  )
                ],
              ),
            ]),
=======
                          onDealerSelected: null,
                        ),*/
                      ],
                    ),
                    SizedBox(
                      height: 384 * variablePixelHeight,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CommonButton(
                          containerBackgroundColor: AppColors.lightWhite1,
                          backGroundColor: isButtonEnabled
                              ? AppColors.lumiBluePrimary
                              : AppColors.lightButtonBackground,
                          onPressed: isButtonEnabled
                              ? _navigateToQRScanner
                              : null,
                          isEnabled: isButtonEnabled,
                          buttonText: translation(context).continueButtonText),
                    )
                  ],
                ),
              ]),
        ),

      ),
    );
  }
}
