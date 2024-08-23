import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../state/contoller/homepage_banners_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class WhatsNewWidget extends StatefulWidget {
  const WhatsNewWidget({
    super.key,
  });

  @override
  State<WhatsNewWidget> createState() => _WhatsNewWidgetState();
}

class _WhatsNewWidgetState extends State<WhatsNewWidget> {
  late String token;
  int currentIndex = 0;
  CarouselController carouselController = CarouselController();
  List<dynamic> data = [];
  late final Map<String, dynamic> responseData;
  late final Map<String, dynamic>? homepageBanners;
  UserDataController controller = Get.find();
  HomepageBannersController homepageBannersController = Get.find();

  @override
  void initState() {
    super.initState();
    print("Homepage banners");
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
          vertical: variablePixelHeight * 16,
          horizontal: variablePixelWidth * 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              translation(context).whatsNew,
              style: GoogleFonts.poppins(
                color: AppColors.lumiDarkBlack,
                fontSize: 16 * textMultiplier,
                fontWeight: FontWeight.w600,
                height: 0.09,
              ),
            ),
          ),
          const VerticalSpace(height: 16),
          if (homepageBannersController.bannerURLs != null &&
              homepageBannersController.bannerURLs.isNotEmpty)
            Stack(
              children: [
                CarouselSlider(
                    items: homepageBannersController.bannerURLs
                        .map((imageURL) => Padding(
                              padding: EdgeInsets.all(3.0 * variablePixelWidth),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(10 * pixelMultiplier),
                                child: Image.network(
                                  imageURL,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollPhysics: const BouncingScrollPhysics(),
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        })),
                Positioned(
                  bottom: 3 * variablePixelHeight,
                  left: 80 * variablePixelWidth,
                  right: 80 * variablePixelWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: homepageBannersController.bannerURLs
                        .asMap()
                        .entries
                        .map((entry) {
                      return GestureDetector(
                        onTap: () =>
                            carouselController.animateToPage(entry.key),
                        child: Container(
                          width: currentIndex == entry.key ? 8 : 6,
                          height: currentIndex == entry.key ? 8 : 6,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(6 * pixelMultiplier),
                              color: currentIndex == entry.key
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            )
          else
            const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
