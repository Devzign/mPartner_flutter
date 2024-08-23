import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/routes/app_routes.dart';

class NetworkManagementHeaderWidget extends StatefulWidget {
  final String heading;
  final  Function()? callBackBtnClick;

  const NetworkManagementHeaderWidget({required this.heading, super.key, this.callBackBtnClick});

  @override
  State<NetworkManagementHeaderWidget> createState() => _NetworkManagementHeaderWidgetState();
}

class _NetworkManagementHeaderWidgetState extends State<NetworkManagementHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    final variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    final variableTextMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    final variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    final variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return Padding(
      padding: EdgeInsets.only(
          left: 24 * variablePixelWidth,
          top: 24 * variablePixelHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (widget.callBackBtnClick!=null)?widget.callBackBtnClick:(){
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.of(context).pushReplacementNamed(AppRoutes.viewDetails);
              }
            },
            child: Icon(
              Icons.arrow_back_outlined,
              color: AppColors.iconColor,
              size: 24 * variablePixelMultiplier,
            ),
          ),
          SizedBox(width: 10 * variablePixelWidth,),
          Expanded(
            child: Text(
              widget.heading,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: GoogleFonts.poppins(
                color: AppColors.iconColor,
                fontSize: AppConstants.FONT_SIZE_LARGE * variableTextMultiplier,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
