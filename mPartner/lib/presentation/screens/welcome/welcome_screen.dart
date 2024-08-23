import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../state/contoller/splash_screen_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/common_button.dart';
import '../base_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends BaseScreenState<WelcomeScreen> {
  final FocusNode _focusNode = FocusNode();
  int _currentIndex = 0;
  Timer? _timer;
  double variablePixelHeight = 0;
  double variablePixelWidth = 0;
  double textFontMultiplier = 0;
  double pixelMultiplier = 0;
  final SplashScreenController splashScreenController = Get.find();
  final String svgString = '''
<svg width="140" height="32" viewBox="0 0 140 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M22.1287 31.7452C26.4026 31.7722 29.9046 29.6767 30.5383 23.3327L30.524 0.846472L23.7582 0.834642L23.7693 22.4117C23.6645 23.5744 22.8878 24.1996 22.1239 24.1861C21.3568 24.1996 20.5817 23.5761 20.4737 22.4134L20.461 0.838022L13.6936 0.858301L13.7095 23.3445C14.3464 29.6885 17.85 31.7756 22.1271 31.7452M44.2859 16.6575L46.4904 0.814363L54.5934 0.810983L56.2531 31.1841L50.1147 31.2027L49.6001 10.1495L46.8493 31.1993H41.7368L38.9622 10.1563L38.4714 31.2112L32.3346 31.1993L33.9561 0.819433L42.0608 0.814363L44.2859 16.6558V16.6575ZM58.6021 0.826193L58.618 31.1824L65.3854 31.1791L65.3711 0.809293L58.6037 0.827882L58.6021 0.826193ZM68.4824 0.863371L68.5015 31.2213L74.7877 31.2179L74.7765 16.2046L78.5565 31.2162L85.3239 31.1976L85.3048 0.839712L79.0171 0.844782L79.0282 16.1877L75.2482 0.846472L68.484 0.865061L68.4824 0.863371ZM115.973 31.686C120.249 31.7114 123.757 29.6142 124.381 23.2719L124.372 0.783944L117.606 0.772115L117.619 22.3509C117.512 23.5186 116.736 24.1388 115.973 24.1253C115.209 24.1388 114.433 23.5169 114.32 22.3525L114.312 0.775495L107.543 0.794084L107.559 23.2837C108.196 29.6243 111.703 31.7165 115.973 31.686ZM96.5685 7.24286C96.4843 7.24624 96.4001 7.25807 96.3191 7.27835C95.147 7.59268 94.2735 10.1259 94.2179 15.9612C94.2815 21.7256 95.1359 24.2689 96.2906 24.6289C96.3017 24.6323 96.3128 24.6356 96.3255 24.6407C96.4097 24.6593 96.4891 24.6694 96.5717 24.6728H96.605C96.686 24.6694 96.767 24.6593 96.848 24.6407C96.8623 24.6356 96.875 24.6323 96.8877 24.6289C98.0392 24.2655 98.8937 21.7256 98.9492 15.9562C98.8873 10.1242 98.0106 7.59099 96.8385 7.27835C96.7543 7.25638 96.6733 7.24624 96.5876 7.24286H96.5669H96.5685ZM95.4282 31.7621C90.5888 31.0946 87.3187 26.5385 87.5363 15.9629C87.3028 5.3738 90.5793 0.810983 95.4313 0.1536C95.4742 0.14515 95.5219 0.13839 95.5695 0.13332C95.8999 0.0927621 96.2334 0.069103 96.5733 0.069103C96.9131 0.069103 97.2482 0.0927621 97.5818 0.13332C97.6247 0.13839 97.6707 0.14177 97.7168 0.15191H97.72C102.567 0.804223 105.845 5.36197 105.629 15.9494V15.9578C105.86 26.5267 102.594 31.0912 97.7597 31.7604C97.3785 31.8195 96.9878 31.8483 96.5907 31.8449C96.1905 31.85 95.8046 31.8195 95.425 31.7638L95.4282 31.7621ZM138.623 16.453C136.973 13.548 135.758 13.3942 134.39 11.662C131.485 7.97629 134.878 4.6015 139.347 9.8217L139.344 2.21532C135.742 -0.540962 131.887 -0.931337 128.643 2.22039C124.802 6.4486 126.298 12.8179 129.183 16.4614H129.2C130.029 17.5024 130.976 18.4353 131.794 19.5709C135.016 23.5676 131.117 27.4544 126.235 21.1003L126.238 29.6767C130.031 32.5699 134.201 32.9755 137.618 29.6683C140.97 25.8862 140.278 19.358 138.623 16.453ZM0 0.863371L0.0158822 31.2264L11.8846 31.2179L11.8799 24.0137H6.77852L6.7674 0.846472L0 0.865061V0.863371Z" fill="white"/>
</svg>
''';

  late List<Widget> icons = <Widget>[
    BuildLanguageCard('WELCOME'),
    BuildLanguageCard('स्वागतम्‌'),
    BuildLanguageCard('স্বাগত'),
    BuildLanguageCard('ಸ್ವಾಗತ'),
    BuildLanguageCard('സ്വാഗതം'),
    BuildLanguageCard('خوش آمدید'),
  ];

  @override
  void initState() {
    super.initState();
    splashScreenController.fetchWelcomeScreenImage();
    _focusNode.requestFocus();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (mounted) {
        setState(() {
          if (_currentIndex + 1 == icons.length) {
            _currentIndex = 0;
          } else {
            _currentIndex = _currentIndex + 1;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget BuildLanguageCard(String language) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GetBuilder<SplashScreenController>(
            builder: (_) {
              return Text(
                language,
                style: GoogleFonts.poppins(
                  color: splashScreenController.welcomeScreenUrl.isNotEmpty
                      ? AppColors.statusBarColor
                      : AppColors.black,
                  fontSize: 28 * textFontMultiplier,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.12,
                ),
              );
            }
        ),
      ],
    );
  }

  @override
  Widget baseBody(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
        backgroundColor: AppColors.lumiLight5,
        body: Center(
          child: Obx(() {
            if (splashScreenController.isLoading.value) {
              return const CircularProgressIndicator();
            }
            else {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: Stack(
                    children: [
                      if(splashScreenController.welcomeScreenUrl.isNotEmpty)
                        Positioned.fill(child: CachedNetworkImage(
                          imageUrl: splashScreenController.welcomeScreenUrl
                              .value,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              splashScreenController.welcomeScreenUrl.value = '';
                            });
                            return Container();
                          },
                        )),
                      Column(
                        children: [
                          SizedBox(height: variablePixelHeight * 60),
                          SvgPicture.string(
                            svgString,
                            width: 205 * textFontMultiplier,
                            color: splashScreenController
                                .welcomeScreenUrl.isNotEmpty
                                ? AppColors.statusBarColor
                                : AppColors.lumiBluePrimary,
                          ),
                          SizedBox(height: variablePixelHeight * 15),
                          Text(
                            'mPARTNER',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: splashScreenController.welcomeScreenUrl
                                  .isNotEmpty
                                  ? AppColors.statusBarColor
                                  : AppColors.lumiBluePrimary,
                              fontSize: textFontMultiplier * 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          Wrap(
                            children: [
                              SizedBox(
                                width: variablePixelWidth * 206,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: icons[_currentIndex],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: variablePixelHeight * 40),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                36 * variablePixelWidth, 0,
                                36 * variablePixelWidth, 0),
                            child: Container(
                              width: variablePixelWidth * 321,
                              height: variablePixelHeight * 80,
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Text(
                                    'mPARTNER is ONE-STOP-SOLUTION to help partners run business with LUMINOUS with complete peace of mind. Login to stay connected with us anytime anywhere!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: splashScreenController
                                          .welcomeScreenUrl.isNotEmpty
                                          ? AppColors.statusBarColor
                                          : AppColors.lightGreyBorder,
                                      fontSize: textFontMultiplier * 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 16 * variablePixelWidth,
                                left: 16 * variablePixelWidth,
                                bottom: 24 * variablePixelWidth),
                            child: CommonButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.language);
                              },
                              isEnabled: true,
                              buttonText: translation(context).getStarted,
                              backGroundColor: splashScreenController
                                  .welcomeScreenUrl.isNotEmpty ? AppColors
                                  .statusBarColor : AppColors.lumiBluePrimary,
                              textColor: splashScreenController.welcomeScreenUrl
                                  .isNotEmpty
                                  ? AppColors.lumiBluePrimary
                                  : AppColors.statusBarColor,
                              withContainer: false,),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }),
        )
    );
  }
}
