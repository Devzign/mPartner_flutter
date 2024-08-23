import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';
import '../../utils/displaymethods/display_methods.dart';
import 'horizontalspace/horizontal_space.dart';

class QRToastMessage extends StatefulWidget {
  const QRToastMessage({
    Key? key,
    required this.serialNo,
    required this.isSuccess,
  }) : super(key: key);

  final bool isSuccess;
  final String serialNo;

  @override
  _CustomToastMessageState createState() => _CustomToastMessageState();
}

class _CustomToastMessageState extends State<QRToastMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 4),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    // Start the animation when the widget is built
    _controller.forward();

    // Add a listener to hide the toast after a certain duration
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // You can adjust the delay duration as needed
        Future.delayed(const Duration(seconds: 2), () {
          if(null != _controller) {
            _controller?.reverse();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: QrToastMessageBody(
        isSuccess: widget.isSuccess,
        serialNo: widget.serialNo,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class QrToastMessageBody extends StatelessWidget {
  const QrToastMessageBody({
    super.key,
    required this.serialNo,
    required this.isSuccess,
  });
  final bool isSuccess;
  final String serialNo;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    String icon = isSuccess
        ? 'assets/mpartner/check_circle.svg'
        : 'assets/mpartner/cancel.svg';
    var textColor = isSuccess ? AppColors.successGreen : AppColors.errorRed;
    return Container(
      width: 266 * w,
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: ShapeDecoration(
            color: AppColors.white.withOpacity(0.85),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12 * r),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 12 * h, horizontal: 20 * w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 24 * r,
                width: 24 * r,
                child: SvgPicture.asset(icon),
              ),
              const HorizontalSpace(width: 10),
              Flexible(
                child: Text(
                  'S No: ${serialNo}',
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 16 * f,
                    fontWeight: FontWeight.w600,
                    height: 24 / 16,
                    letterSpacing: 0.50 * w,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
