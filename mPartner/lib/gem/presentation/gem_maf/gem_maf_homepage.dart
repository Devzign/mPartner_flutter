import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/utils.dart';

import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../state/controller/gem_maf_home_page_controller.dart';
import '../gem_tender/component/headingGemSupportCategory.dart';
import 'component/gem_maf_support_content_widget.dart';
import 'component/maf_homepage_content.dart';
import 'maf_listinghome_page.dart';

class GemMafHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GemBidDetails();
  }
}

class _GemBidDetails extends State {
  GemHomePageController controller = Get.find();

  @override
  void initState() {
    controller.getdata(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    heading: translation(context).gemSupport,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
              UserProfileWidget(
                top: 8 * variablePixelHeight,
              ),
              GemMafSupportContentAuthWidget(
                onclick: () async {
                 await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GemListingHomePage(
                                status: "",
                                bidstatus: "",
                              )));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                if (controller.loading.value) {
                  return Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (controller.datalist.isNotEmpty)
                  return MafHomePageContent(
                    controller.datalist[0],
                    onClick: (status, bidstatus) {
                      checkDataValidation(status, bidstatus);
                    },
                    requestCode: () async {
                      await controller.checkGstExist(context, false);

                       //Navigator.pushNamed(context, AppRoutes.gemMafRegistration);
                    },
                  );
                return const Text("No Data Found");
              })
            ],
          ),
          Obx(() {
            if (controller.checkgst.value) {
              return Container(
                margin: const EdgeInsets.only(top: 100),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            ;
            return Container();
          })
        ],
      ),
    );
  }

  checkDataValidation(String status, String bidstatus){
    Map<String, int> statusMap = {
      "" : controller.datalist[0].total ?? 0,
      "Rejected": controller.datalist[0].rejected ?? 0,
      "In Progress": controller.datalist[0].inProgress ?? 0,
      "Approved": controller.datalist[0].received ?? 0
    };

// Check if the status exists in the map and its associated data count is greater than 0
    if (statusMap.containsKey(status) && statusMap[status]! > 0) {
      // Data found, navigate to listing page
      gotToListingPage(status, bidstatus);
    } else {
      // No data found, show toast message
      Utils().showToast('Data not found!', context);
    }

  }

  void gotToListingPage(String status, String bidstatus) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GemListingHomePage(
          status: status,
          bidstatus: bidstatus,
        ),
      ),
    );
  }
}
