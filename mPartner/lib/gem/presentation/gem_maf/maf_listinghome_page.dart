import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';

import '../../../../utils/routes/app_routes.dart';

import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../data/models/maf_filter_model.dart';
import '../../state/controller/gem_maf_home_page_listing_controller.dart';
import '../../utils/gem_default_widget/no_data_widget.dart';
import '../gem_support_auth/component/gem_search_component.dart';
import '../gem_tender/component/headingGemSupportCategory.dart';
import 'component/maf_homepage_listing_item_widget.dart';
import 'maf_data_detail_page.dart';

class GemListingHomePage extends StatefulWidget {
  String? status;
  String? bidstatus;

  GemListingHomePage(
      {super.key, required this.status, required this.bidstatus});

  @override
  State<StatefulWidget> createState() {
    return _GemListingHomePage();
  }
}

class _GemListingHomePage extends BaseScreenState<GemListingHomePage> {
  GemMafHomePageListingController controller = Get.find();

  @override
  void initState() {
    controller.filterModel = MafFilterModel().obs;
    controller.status.value = widget.status!;
    controller.bidstatus.value = "";
    controller.getList();
    super.initState();
  }

  @override
  Widget baseBody(BuildContext context) {
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (controller.loadingmore.value == false &&
              controller.search.value == false &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              controller.authenticationlist.length >= 10) {
            controller.loadMore();
          }
          return true;
        },
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: 14 * variablePixelWidth,
                    top: 45 * variablePixelHeight),
                child: HeadingGemSupportCategory(
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.iconColor,
                    size: 24 * variablePixelMultiplier,
                  ),
                  heading: translation(context).mafText,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            UserProfileWidget(
              top: 8 * variablePixelHeight,
            ),
            GemSearchComponent(
              title : translation(context).enterbidNumber,
              filterClick: () async {
                controller.moveToFilter(context);
              },
              onTyped: (String) {
                controller.search_item(String);
              },
            ),
            Obx(() {
              if (controller.loading == true) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  margin: EdgeInsets.only(top: 100),
                );
              } else if (controller.authenticationlist.length > 0)
                return Expanded(
                    child: ListView.builder(
                        itemCount: controller.authenticationlist.length,
                        padding: EdgeInsets.only(bottom: 100),
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, int index) {
                          return MafHomePageListingItemWidget(
                            controller.authenticationlist[index],
                            onTap: (id, authcode) async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MafDataDetailsPage(
                                        bidNumber: authcode)),
                              ).then((value){
                                controller.getList();
                              });
                            },
                          );
                        }));
              else
                return NoDataWidget(
                  message: translation(context).noRecordFound,
                );
            })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.lumiBluePrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        label: Text(
          translation(context).raisemafrequest,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 12 * textMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
         await controller.checkGstExist(context, false);
          //Navigator.pushNamed(context, AppRoutes.gemMafRegistration);
        },
      ),
    );
  }
}
