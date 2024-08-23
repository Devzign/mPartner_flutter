import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class HeadingMaf extends StatefulWidget {
  final String heading;
  final Icon icon;
  final Function() onPressed;
  final Color textColor;

  const HeadingMaf({
    required this.heading,
    required this.onPressed,
    this.textColor = AppColors.iconColor,
    required this.icon,
    super.key});

  @override
  State<HeadingMaf> createState() => _HeadingMafState();
}

class _HeadingMafState extends State<HeadingMaf> {

  @override
  Widget build(BuildContext context) {

    final variablePixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    final variableTextMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: widget.icon!,
          onPressed: () => widget.onPressed.call(),
        ),
        Text(
          widget.heading,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: GoogleFonts.poppins(
            color: widget.textColor,
            fontSize:
            18 * variableTextMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
