import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

class TravellerInfoCard extends StatefulWidget {
  TravellerInfoCard({
    super.key,
    required this.onPressedDelete,
    required this.onPressedEdit,
    required this.showDetails,
    required this.name,
    required this.emailId,
    required this.passport,
    required this.phoneNumber,
    required this.number,
    required this.relationship,
    this.showDefaultMessage = false,
    
  });

  bool showDetails, showDefaultMessage;
  final onPressedEdit, onPressedDelete;
  final String name, emailId, passport, phoneNumber, relationship;
  final int number;

  @override
  State<TravellerInfoCard> createState() => _TravellerInfoCardState();
}

class _TravellerInfoCardState extends State<TravellerInfoCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.relationship);
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.showDetails = !widget.showDetails;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16 * r),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1 * r, color: AppColors.lightGrey2),
                borderRadius: BorderRadius.circular(12 * r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${translation(context).traveller} ${widget.number}',
                      style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 16 * f,
                          fontWeight: FontWeight.w600,
                          height: 24 / 16),
                    ),
                    Spacer(),
                    widget.showDetails
                        ? const Icon(Icons.keyboard_arrow_up)
                        : const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
                Visibility(
                    visible: widget.showDetails,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpace(height: 16),
                        Divider(),
                        VerticalSpace(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 245 * w,
                              child: Text(
                                widget.name,
                                style: GoogleFonts.poppins(
                                  color: AppColors.darkGrey,
                                  fontSize: 12 * f,
                                  fontWeight: FontWeight.w500,
                                  height: 20 / 12,
                                ),
                                softWrap: true,
                              ),
                            ),

                    Spacer(),
                    GestureDetector(
                      onTap: widget.onPressedEdit,
                      child: SizedBox(
                        height: 24 * r,
                        width: 24 * r,
                        child: SvgPicture.asset('assets/mpartner/edit.svg'),
                      ),
                    ),
                    HorizontalSpace(width: 16),
                    GestureDetector(
                      onTap: widget.onPressedDelete,
                      child: SizedBox(
                        height: 24 * r,
                        width: 24 * r,
                        child: SvgPicture.asset('assets/mpartner/delete.svg'),
                      ),
                    ),
                    
                  ],
                ),

                        Visibility(
                            visible: widget.emailId.isNotEmpty,
                            child: VerticalSpace(height: 4)),
                        Visibility(
                          visible: widget.emailId.isNotEmpty,
                          child: Text(
                            widget.emailId,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 20 / 12,
                            ),
                          ),
                        ),
                        Visibility(
                            visible: widget.phoneNumber.isNotEmpty,
                            child: VerticalSpace(height: 4)),
                        Visibility(
                          visible: widget.phoneNumber.isNotEmpty,
                          child: Text(
                            "${translation(context).mobileNumber}: ${widget.phoneNumber}",
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 20 / 12,
                            ),
                          ),
                        ),
                        Visibility(
                            visible: widget.relationship.isNotEmpty,
                            child: VerticalSpace(height: 4)),
                        Visibility(
                          visible: widget.relationship.isNotEmpty,
                          child: Text(
                            "${translation(context).relation}: ${widget.relationship}",
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 20 / 12,
                            ),
                          ),
                        ),
                        Visibility(
                            visible: widget.passport.isNotEmpty,
                            child: VerticalSpace(height: 4)),
                        Visibility(
                          visible: widget.passport.isNotEmpty,
                          child: Text(
                            "${translation(context).passport}: ${widget.passport}",
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 20 / 12,
                            ),
                          ),
                        ),
                        
          
                      ],
                      
                    ))
              ],
            ),
          ),
          Visibility(
              visible: widget.relationship.toLowerCase() == "self" &&
                  widget.showDefaultMessage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpace(height: 4),
                  Text('*This is added by default, you can edit/delete it',
                      style: GoogleFonts.poppins(
                        color: AppColors.grayText,
                        fontSize: 12 * f,
                        fontWeight: FontWeight.w400,
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
