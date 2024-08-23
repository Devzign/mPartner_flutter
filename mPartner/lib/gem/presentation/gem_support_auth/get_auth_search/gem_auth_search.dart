import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../../utils/routes/app_routes.dart';

import '../../../../presentation/screens/base_screen.dart';
import '../../../data/models/auth_filter_model.dart';
import '../../../state/controller/gem_authsearchlist_controller.dart';
import '../../../state/controller/gem_bid_controller.dart';
import '../../../utils/gem_default_widget/gem_header.dart';
import '../../../utils/gem_default_widget/loading_bar.dart';
import '../../../utils/gem_default_widget/no_data_widget.dart';
import '../component/gem_search_component.dart';
import '../component/gem_serach_list.dart';
import '../gem_auth_details/gem_auth_details.dart';
import 'gem_auth_filter/gem_auth_filter.dart';

class GemAuthSearch extends StatefulWidget {
  String? Status;

  GemAuthSearch({required this.Status});

  @override
  State<StatefulWidget> createState() {
    return _GemAuthSearch();
  }
}

class _GemAuthSearch extends BaseScreenState<GemAuthSearch> {
  GemAuthSearchListController controller = Get.find();

  @override
  void initState() {
    controller.filterModel = AuthFilterModel().obs;
    controller.status.value = widget.Status.toString();
    controller.getList();
    super.initState();
  }

  @override
  Widget baseBody(BuildContext context) {
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (controller.loadingmore.value == false &&
                controller.search.value == false &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                controller.authenticationlist.length >= 10) {
              controller.loadMore();
            }
            return true;
          },
          child: new Column(
            children: [
              GemHeader(translation(context).gemSupportAuthorizationCode),
              GemSearchComponent(
                title : translation(context).enterAuthcodeText,
                filterClick: () async {
                  controller.moveToFilter(context);
                },
                onTyped: (String) {
                  controller.search_item(String);
                },
              ),
              if (controller.loading == true)LoadingBar()
              else if (controller.authenticationlist.length > 0)Expanded(
                    child: ListView.builder(
                        itemCount: controller.authenticationlist.length,
                        padding: EdgeInsets.only(bottom: 100),
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, int index) {
                          return Build_AuthListItem(
                            controller.authenticationlist[index],
                            onTap: (id, authcode) async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GemAuthDetails(
                                        id: id, authcode: authcode)),
                              );
                            },
                          );
                        })) else NoDataWidget(message: translation(context).noRecordFound,)
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.lumiBluePrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        label: Text(
          translation(context).gemRequestCode,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 12 * textMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          GemBidController controller2 = Get.find();
          controller2.checkGstExist(context,true);
        },
      ),
    );
  }
}
