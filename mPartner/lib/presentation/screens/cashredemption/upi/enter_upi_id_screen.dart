import 'package:flutter/material.dart';
import '../../../../data/models/upi_beneficiary_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/textfield_input_handler.dart';
import '../../../widgets/common_button.dart';
import '../../base_screen.dart';
import '../../userprofile/components/form_field_widget.dart';
import '../../userprofile/user_profile_widget.dart';
import '../../../widgets/headers/header_widget_with_cash_info.dart';
import 'enter_amount_screen_upi.dart';

class EnterUPIIDScreen extends StatefulWidget {
  const EnterUPIIDScreen({super.key});

  @override
  State<EnterUPIIDScreen> createState() {
    return _EnterUPIScreen();
  }
}

class _EnterUPIScreen extends BaseScreenState<EnterUPIIDScreen> {
  TextEditingController _upiID = TextEditingController();
  TextEditingController _confirmUPIID = TextEditingController();
  bool isLoading = false;
  bool isVerified = false;
  bool showUPITagsForUPIID = false;
  bool showUPITagsForConfirmUPIID = false;
  bool confirmUPIEnabled = false;
  String selectedUPISuffix = '';
  String upiVerifyValidationMessage = '';
  String errorUPISelection = '';
  UPIBeneficiaryModel beneficiaryDetails = UPIBeneficiaryModel.empty();

  @override
  void initState() {
    super.initState();
    _upiID.addListener(() {
      setState(() {
        if (_upiID.text.contains('@') && selectedUPISuffix.isEmpty) {
          showUPITagsForUPIID = true;
        } else {
          showUPITagsForUPIID = false;
        }
      });
    });

    _confirmUPIID.addListener(() {
      setState(() {
        if (_confirmUPIID.text.contains('@')) {
          showUPITagsForConfirmUPIID = true;
          showUPITagsForUPIID = false;  // Hide UPI list for the first field
        } else {
          showUPITagsForConfirmUPIID = false;
        }
      });
    });
  }

  void _updateUPI(String suffix) {
    String currentText = _upiID.text;

    if (currentText.contains('@')) {
      currentText = currentText.split('@')[0];
    }

    _upiID.text = "$currentText$suffix";
    selectedUPISuffix = suffix;

    _upiID.selection = TextSelection.fromPosition(
      TextPosition(offset: _upiID.text.length),
    );

    setState(() {
      confirmUPIEnabled = true; // Enable confirm UPI after selection
    });
  }

  void _verifyUPIsMatch() {
    if (_upiID.text == _confirmUPIID.text) {
      setState(() {
        isVerified = true;
        upiVerifyValidationMessage = '';
      });
    } else {
      setState(() {
        isVerified = false;
        upiVerifyValidationMessage = 'UPI IDs do not match. Check again.';
      });
    }
  }

  void _resetConfirmUPI() {
    setState(() {
      _confirmUPIID.clear();
      confirmUPIEnabled = false;
      showUPITagsForConfirmUPIID = false;
      selectedUPISuffix = '';
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidgetWithCashInfo(
              heading: translation(context).upi,
              onPressBack: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: AppColors.iconColor,
                size: 24 * pixelMultiplier,
              ),
            ),
            UserProfileWidget(top: 8 * variablePixelHeight),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormFieldWidget(
                          controller: _upiID,
                          keyboardType: TextInputType.text,
                          inputFormatter: [
                            HandleFirstSpaceAndDotInputFormatter(),
                            HandleMultipleDotsInputFormatter(),
                          ],
                          textCapitalization: TextCapitalization.words,
                          labelText: translation(context).upiId,
                          hintText: translation(context).enterUpiId,
                          errorText: errorUPISelection.isNotEmpty
                              ? errorUPISelection
                              : null,
                          onChanged: (value) {
                            setState(() {
                              if (!value.contains('@')) {
                                _resetConfirmUPI();
                              }
                              showUPITagsForUPIID = value.contains('@') &&
                                  selectedUPISuffix.isEmpty;
                            });
                          },
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        if (showUPITagsForUPIID) _buildUPITagSelection(false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (confirmUPIEnabled)
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormFieldWidget(
                            controller: _confirmUPIID,
                            keyboardType: TextInputType.text,
                            inputFormatter: [
                              HandleFirstSpaceAndDotInputFormatter(),
                              HandleMultipleDotsInputFormatter(),
                            ],
                            textCapitalization: TextCapitalization.words,
                            labelText: translation(context).confirmUPIID,
                            hintText: translation(context).enterConfirmUPIid,
                            errorText: upiVerifyValidationMessage.isNotEmpty
                                ? upiVerifyValidationMessage
                                : null,
                            onChanged: (value) {
                              _verifyUPIsMatch();
                            },
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                          if (showUPITagsForConfirmUPIID)
                            _buildUPITagSelection(true),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  1 * variablePixelWidth, 0, 1 * variablePixelWidth, 0),
              alignment: Alignment.center,
              child: CommonButton(
                onPressed: isVerified
                    ? () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EnterAmountUPIScreen(
                        beneficiaryDetails: beneficiaryDetails,
                      )));
                }
                    : null,
                isEnabled: isVerified,
                containerBackgroundColor: AppColors.white,
                buttonText: translation(context).continueButtonText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUPITagSelection(bool isConfirmField) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildUPITag('@BARODAMPAY', isConfirmField),
          _buildUPITag('@ybl', isConfirmField),
          _buildUPITag('@axl', isConfirmField),
          _buildUPITag('@pthdfc', isConfirmField),
          // Add more UPI tags here if needed
        ],
      ),
    );
  }

  Widget _buildUPITag(String tag, bool isConfirmField) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: () {
          if (isConfirmField) {
            String currentText = _confirmUPIID.text;
            if (currentText.contains('@')) {
              currentText = currentText.split('@')[0];
            }
            _confirmUPIID.text = "$currentText$tag";
            _confirmUPIID.selection = TextSelection.fromPosition(
              TextPosition(offset: _confirmUPIID.text.length),
            );
            setState(() {
              showUPITagsForConfirmUPIID = false;
            });
          } else {
            _updateUPI(tag);
          }
        },
        child: Chip(
          label: Text(
            tag,
            style: TextStyle(
              color: selectedUPISuffix == tag ? Colors.blue : Colors.black,
            ),
          ),
          backgroundColor: selectedUPISuffix == tag
              ? Colors.lightBlue.shade100
              : Colors.white,
          side: BorderSide(
            color: selectedUPISuffix == tag ? Colors.blue : Colors.black,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}

