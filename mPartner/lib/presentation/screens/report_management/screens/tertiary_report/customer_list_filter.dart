import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/get_customer_list_model.dart';
import '../../../../../state/contoller/customer_list_controller.dart';
import '../../../../../state/contoller/customer_wise_list_controller.dart';
import '../../../../../state/contoller/tertiary_product_wise_details_controller.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import 'customer_checkbox_widget.dart';

class CustomerListFilterWidget extends StatefulWidget {
  final void Function(int selectedCount) updateFilterText;
  List<Customer> customerList;
  CustomerListFilterWidget(
      {Key? key, required this.updateFilterText, required this.customerList})
      : super(key: key);

  @override
  State<CustomerListFilterWidget> createState() =>
      _CustomerListFilterWidgetState();
}

class _CustomerListFilterWidgetState extends State<CustomerListFilterWidget> {
  bool? value = false;
  TextEditingController searchController = TextEditingController();
  CustomerWiseListController customerWiseListController = Get.find();
  UserDataController userDataController = Get.find();
  String searchText = "";
  CustomerList customerListController = Get.find();
  late List<Customer> customerList;
  late List<Customer> filteredCustomerList;
  List<String> checkedCustomerPhone = [];
  bool isSelectAll = true;
  String checkedCustomerPhoneString = "";

  @override
  void initState() {
    super.initState();
    customerList = widget.customerList;
    filteredCustomerList = customerList;
    checkedCustomerPhoneString = getCheckedCustomerPhoneString();
    isSelectAll = customerListController.customersSelected.isEmpty;
    if (!isSelectAll) {
      checkedCustomerPhone =
          customerListController.customersSelected.value.split(',');
    }
  }

  void filterCustomers() {
    if (searchText.isEmpty) {
      filteredCustomerList = customerList;
    } else {
      filteredCustomerList = customerList
          .where((customer) =>
      customer.customer_Name
          .toLowerCase()
          .contains(searchText.toLowerCase()) ||
          customer.customer_Phone
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }
  }

  void onCheckBoxChanged(bool isChecked, String phone) {
    setState(() {
      if (isChecked) {
        if(!checkedCustomerPhone.contains(phone)){
          checkedCustomerPhone.add(phone);
        }
      } else {
        if (isSelectAll) {
          isSelectAll = false;
          for (var customer in customerList) {
            if(!checkedCustomerPhone.contains(customer.customer_Phone)){
              checkedCustomerPhone.add(customer.customer_Phone);
            }
          }
          if (checkedCustomerPhone.contains(phone)) {
            checkedCustomerPhone.remove(phone);
          }
        } else {
          checkedCustomerPhone.remove(phone);
        }
      }
      checkedCustomerPhoneString = getCheckedCustomerPhoneString();
    });
  }

  String getCheckedCustomerPhoneString() {
    return checkedCustomerPhone.join(',');
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Stack(children: [
      Container(
        height: 717 * h,
        padding: EdgeInsets.symmetric(horizontal: 24 * w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close),
            ),
            const VerticalSpace(height: 12),
            Container(
              child: Text(
                translation(context).chooseYourCustomers,
                style: GoogleFonts.poppins(
                  color: AppColors.titleColor,
                  fontSize: 20 * f,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.50,
                ),
              ),
            ),
            const VerticalSpace(height: 16),
            Container(
              width: double.infinity,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: AppColors.dividerGreyColor,
                  ),
                ),
              ),
            ),
            const VerticalSpace(height: 20),
            Container(
              height: 56 * h,
              width: double.infinity,
              decoration: ShapeDecoration(
                color: AppColors.searchBlue,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: AppColors.white_234),
                  borderRadius: BorderRadius.circular(8 * r),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20 * w),
                    child: const Icon(
                      Icons.search,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      maxLength: 50,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                          filterCustomers();
                        });
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: translation(context).search,
                        hintStyle: GoogleFonts.poppins(
                          color: AppColors.hintColor,
                          fontSize: 16.0 * f,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.poppins(
                        color: AppColors.blackText,
                        fontSize: 16.0 * f,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalSpace(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${filteredCustomerList.length} customers listed",
                  style: GoogleFonts.poppins(
                    color: AppColors.hintColor,
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w600,
                    height: 0.12,
                    letterSpacing: 0.50,
                  ),
                ),
                const Spacer(),
                isSelectAll
                    ? Text(
                  "${customerList.length}/${customerList.length} selected",
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    height: 0.12,
                    letterSpacing: 0.50,
                  ),
                )
                    : Text(
                  "${checkedCustomerPhone.length}/${customerList.length} selected",
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    height: 0.12,
                    letterSpacing: 0.50,
                  ),
                ),
                const VerticalSpace(height: 12),
              ],
            ),
            const VerticalSpace(height: 16),
            GestureDetector(
              onTap: () {
                //var value = !isSelectAll;
                setState(() {
                  if (value == false) {
                    checkedCustomerPhone = [];
                    checkedCustomerPhoneString = "";
                  }
                  isSelectAll = value!;
                  checkedCustomerPhoneString = "";
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 24 * h,
                      width: 24 * w,
                      child: Checkbox(
                        value: isSelectAll,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == false) {
                              checkedCustomerPhone = [];
                              checkedCustomerPhoneString = "";
                            } else {
                              for (var customer in customerList) {
                                if(!checkedCustomerPhone.contains(customer.customer_Phone)){
                                  checkedCustomerPhone.add(customer.customer_Phone);
                                }
                              }
                            }
                            isSelectAll = value!;
                            
                            checkedCustomerPhoneString = "";
                          });
                        },
                        checkColor: AppColors.lightWhite1,
                        activeColor: AppColors.lumiBluePrimary,
                      )),
                  const HorizontalSpace(width: 4),
                  Text(
                    "Select All",
                    style: GoogleFonts.poppins(
                      color: AppColors.darkText2,
                      fontSize: 14 * f,
                      fontWeight: FontWeight.w600,
                      height: 0.12,
                      letterSpacing: 0.50,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalSpace(height: 16),
            Container(
              height: 418 * h,
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredCustomerList.length,
                  itemBuilder: (context, index) {
                    Customer customer = filteredCustomerList[index];
                    return CustomerCheckBoxWidget(
                      customer: customer,
                      isSelected: isSelectAll ||
                          checkedCustomerPhone
                              .contains(customer.customer_Phone),
                      onCheckBoxChanged: onCheckBoxChanged,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(children: [
            Expanded(
              child: CommonButton(
                onPressed: () {
                  if(isSelectAll || checkedCustomerPhone.length > 0){
                    setState(() {
                      isSelectAll = true;
                      widget.updateFilterText(filteredCustomerList.length);
                      checkedCustomerPhoneString = "";
                      customerListController.customersSelected.value = "";
                      customerWiseListController.fetchTertiaryReportSummary(
                          userDataController.sapId,
                          customerPhone: checkedCustomerPhoneString);
                      Navigator.pop(context);
                    });
                  }
                },
                isEnabled: true,
                containerBackgroundColor: AppColors.lightWhite1,
                containerHeight: 48,
                backGroundColor: AppColors.lightWhite1,
                buttonText: translation(context).reset,
                textColor: isSelectAll || checkedCustomerPhone.isNotEmpty ? AppColors.lumiBluePrimary : AppColors.darkGreyText,
              ),
            ),
            Expanded(
              child: CommonButton(
                  onPressed: () {
                    if(checkedCustomerPhoneString == ""){
                      widget.updateFilterText(filteredCustomerList.length);
                    }
                    else {
                      widget.updateFilterText(checkedCustomerPhone.length);
                    }
                    customerListController.customersSelected.value =
                        checkedCustomerPhoneString;
                    customerWiseListController.customers.value = checkedCustomerPhone.join(",");
                    customerWiseListController.applyFilter();
                    /* customerWiseListController.fetchTertiaryReportSummary(
                        userDataController.sapId,
                        customerPhone: checkedCustomerPhoneString,
                        fromDate: customerWiseListController.from.value,
                        toDate: customerWiseListController.to.value); */
                    Navigator.pop(context);
                  },
                  isEnabled: isSelectAll || checkedCustomerPhone.isNotEmpty,
                  containerBackgroundColor: AppColors.lightWhite1,
                  containerHeight: 48,
                  buttonText: translation(context).submit),
            ),
          ]))
    ]);
  }
}
