import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../presentation/screens/network_management/dealer_electrician/components/custom_calender.dart';
import '../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../solar_finance_utils.dart';

class CustomerProjectDetailsCard extends StatelessWidget {
  bool isResidential, isCommercial;
  String uniqueId,
      projectType,
      firmName,
      contactPersonName,
      contactPersonMobile,
      contactPersonEmail,
      projectName,
      pincode,
      state,
      city,
      projectCapacity,
      projectCost,
      preferredBank,
      aadharNumber,
      firmGSTIN,
      panNumber,
      financeStatus,
      approvedBank,
      remarks,
      secondaryContactName,
      secondaryContactEmailId,
      secondaryContactMobileNo;

  CustomerProjectDetailsCard(
      {super.key,
      required this.uniqueId,
      required this.firmName,
      required this.contactPersonName,
      required this.contactPersonEmail,
      required this.contactPersonMobile,
      required this.projectName,
      required this.pincode,
      required this.state,
      required this.city,
      required this.projectCapacity,
      required this.projectCost,
      required this.preferredBank,
      this.aadharNumber = "",
      this.firmGSTIN = "",
      required this.panNumber,
      required this.financeStatus,
      required this.approvedBank,
      required this.projectType,
      required this.remarks,
      required this.secondaryContactName,
      required this.secondaryContactEmailId,
      required this.secondaryContactMobileNo,
      this.isResidential = false,
      this.isCommercial = false});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12 * w, vertical: 12 * h),
      decoration: ShapeDecoration(
        color: AppColors.grey97,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.white_234),
          borderRadius: BorderRadius.circular(12 * r),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Customer Project Details",
          style: GoogleFonts.poppins(
              fontSize: 16 * f,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreyText),
        ),
        VerticalSpace(height: 16),
        Divider(
          color: AppColors.white_234,
        ),
        VerticalSpace(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Unique Id",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              uniqueId,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Project Type",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              projectType,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Visibility(
          visible: isCommercial,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Firm Name",
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreyText),
              ),
              Text(
                firmName,
                style: GoogleFonts.poppins(
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGreyText),
              )
            ],
          ),
        ),
        Visibility(visible: isCommercial, child: VerticalSpace(height: 8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Contact Person Name",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              contactPersonName,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Contact Person Mobile",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              contactPersonMobile,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Contact Person Email Id",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Tooltip(
              message: contactPersonEmail,
              triggerMode: TooltipTriggerMode.tap,
              child: SizedBox(
                width: 133 * variablePixelWidth,
                child: Text(
                  contactPersonEmail,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 14 * f,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGreyText),
                ),
              ),
            ),
          ],
        ),
        VerticalSpace(height: 8),
         Visibility(
          visible: secondaryContactName.isNotEmpty,
           child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Secondary Contact Name",
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreyText),
              ),
              Text(
                secondaryContactName,
                style: GoogleFonts.poppins(
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGreyText),
              )
            ],
                   ),
         ),
        Visibility(visible : secondaryContactName.isNotEmpty, child: VerticalSpace(height: 8)),
        Visibility(
          visible: secondaryContactMobileNo.isNotEmpty,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Secondary Contact Mobile",
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreyText),
              ),
              Text(
                secondaryContactMobileNo,
                style: GoogleFonts.poppins(
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGreyText),
              )
            ],
          ),
        ),
        Visibility(visible: secondaryContactMobileNo.isNotEmpty, child: VerticalSpace(height: 8)),
         Visibility(
          visible: secondaryContactEmailId.isNotEmpty,
           child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Secondary Contact Email Id",
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreyText),
              ),
              Tooltip(
                message: secondaryContactEmailId,
                triggerMode: TooltipTriggerMode.tap,
                child: SizedBox(
                  width: 133 * variablePixelWidth,
                  child: Text(
                    secondaryContactEmailId,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 14 * f,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGreyText),
                  ),
                ),
              ),
            ],
                   ),
         ),
        Visibility(visible: secondaryContactEmailId.isNotEmpty, child: VerticalSpace(height: 8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Project Name",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              projectName,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pincode",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              pincode,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "State",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              state,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "City",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              city,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Project Capacity",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              projectCapacity,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Project Cost",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              projectCost,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Preferred Bank",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              preferredBank,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Visibility(
          visible: isCommercial,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Firm GSTIN Number",
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreyText),
              ),
              Text(
                firmGSTIN,
                style: GoogleFonts.poppins(
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGreyText),
              )
            ],
          ),
        ),
        Visibility(visible: isCommercial, child: VerticalSpace(height: 8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isResidential ? 'PAN Number' : 'Firm PAN Number',
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Text(
              panNumber,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreyText),
            )
          ],
        ),
        VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Finance Status",
              style: GoogleFonts.poppins(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyText),
            ),
            Row(
              children: [
                Icon(
                  statusIcons[financeStatus.toLowerCase()],
                  color: getStatusColor(financeStatus.toLowerCase()),
                  size: 16 * w,
                ),
                HorizontalSpace(width: 6),
                Text(
                  financeStatus,
                  style: GoogleFonts.poppins(
                    color: getStatusColor(financeStatus.toLowerCase()),
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w600,
                    height: 0.11,
                  ),
                ),
              ],
            )
          ],
        ),
        Visibility(
          visible: financeStatus.toLowerCase() == 'approved' && approvedBank.isNotEmpty,
          child: VerticalSpace(height: 8)),
        Visibility(
          visible: financeStatus.toLowerCase() == 'approved' && approvedBank.isNotEmpty,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Approved Bank",
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreyText),
              ),
              Text(
                approvedBank,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w600,
                  height: 0.11,
                ),
              )
            ],
          ),
        ),
        VerticalSpace(height: 8),
        Visibility(
          visible: remarks.isNotEmpty,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Remarks",
                style: GoogleFonts.poppins(
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreyText),
              ),
              Text(
                remarks,
                style: GoogleFonts.poppins(
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGreyText),
              )
            ],
          ),
        ),
        Visibility(visible: remarks.isNotEmpty, child: VerticalSpace(height: 8)),
      ]),
    );
  }
}
