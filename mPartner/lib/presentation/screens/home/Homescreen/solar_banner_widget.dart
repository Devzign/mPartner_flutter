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

class SolarBannerWidget extends StatefulWidget {
  const SolarBannerWidget({
    super.key,
  });

  @override
  State<SolarBannerWidget> createState() => _WhatsNewWidgetState();
}

class _WhatsNewWidgetState extends State<SolarBannerWidget> {
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
    print("solar banners");

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
      padding: EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          if (homepageBannersController.solarUrls != null &&
              homepageBannersController.solarUrls.isNotEmpty)
            Stack(
              children: [
                CarouselSlider(
                    items: homepageBannersController.solarUrls
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
                    children: homepageBannersController.solarUrls
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
