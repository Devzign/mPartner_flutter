import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/displaymethods/display_methods.dart';
import '../../utils/utils.dart';

class CoinWithImageWidget extends StatelessWidget {
  CoinWithImageWidget({
    super.key,
    required this.coin,
    required this.color,
    required this.size,
    required this.weight,
    required this.width,
    this.showSign = false,
    this.signText = '',
  });

  final double width;
  final double coin;
  final Color color;
  final int size;
  final FontWeight weight;
  final bool showSign;
  final String signText;

  final _myGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    final int svgSizeReducer = Platform.isAndroid ? 2 : 0;
    const String svgString = '''
<svg width="28" height="28" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M14 26.25C20.7655 26.25 26.25 20.7655 26.25 14C26.25 7.2345 20.7655 1.75 14 1.75C7.2345 1.75 1.75 7.2345 1.75 14C1.75 20.7655 7.2345 26.25 14 26.25Z" fill="#F9C23C"/>
<path opacity="0.53" d="M23.625 14C23.625 19.3156 19.3156 23.625 14 23.625C8.68438 23.625 4.375 19.3156 4.375 14C4.375 8.68438 8.68438 4.375 14 4.375C19.3156 4.375 23.625 8.68438 23.625 14ZM19.53 17.4037C19.4992 17.3097 19.4395 17.2277 19.3593 17.1695C19.2792 17.1114 19.1828 17.0801 19.0837 17.08H19.11V10.29C19.4862 10.045 19.5562 9.44125 19.1012 9.17L14.385 6.3175C14.2828 6.25316 14.1645 6.21902 14.0437 6.21902C13.923 6.21902 13.8047 6.25316 13.7025 6.3175L8.9775 9.17C8.5225 9.44125 8.5925 10.045 8.96 10.29V17.0888H8.86375C8.65375 17.0888 8.47 17.2288 8.4175 17.43L8.11125 18.5238C8.02375 18.8212 8.25125 19.1188 8.5575 19.1188H19.4513C19.7575 19.11 19.985 18.8037 19.8888 18.4975L19.53 17.4037ZM10.4125 10.395V17.08H11.865V10.395H10.4125ZM13.3088 10.395V17.08H14.7875V10.395H13.3088ZM16.24 10.395V17.08H17.6575V10.395H16.24Z" fill="#D3883E"/>
</svg>
''';

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.string(
          svgString,
          width: (size - svgSizeReducer) * f,
          height: (size - svgSizeReducer) * f,
        ),
        AutoSizeText(
          ' ',
          group: _myGroup,
          maxLines: 1,
          stepGranularity: 0.25,
          minFontSize: (size * f).roundToDouble() - 1,
          style: GoogleFonts.roboto(
            color: color,
            fontSize: size * f,
            fontWeight: weight,
          ),
        ),
        if (showSign)
          AutoSizeText(
            signText,
            group: _myGroup,
            maxLines: 1,
            stepGranularity: 0.25,
            minFontSize: (size * f).roundToDouble() - 1,
            style: GoogleFonts.roboto(
              color: color,
              fontSize: size * f,
              fontWeight: weight,
            ),
          ),
        Container(
          constraints: BoxConstraints(maxWidth: (width - 32) * w),
          child: AutoSizeText(
            rupeeNoSign.format(coin),
            group: _myGroup,
            maxLines: 1,
            stepGranularity: 0.25,
            minFontSize: (size * f).roundToDouble() - 1,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: size * f,
              fontWeight: weight,
            ),
          ),
        ),
      ],
    );
  }
}
