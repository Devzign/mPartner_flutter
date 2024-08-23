import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/headers/back_button_header_widget.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';
import '../userprofile/user_profile_widget.dart';

class OmniSearch extends StatefulWidget {
  const OmniSearch({super.key});

  @override
  State<OmniSearch> createState() => _OmniSearchState();
}

class _OmniSearchState extends BaseScreenState<OmniSearch> {
  List<AppRoutesMap> appRoutes = getFilterAppRoutes(AppRoutes().searchList);
  List<AppRoutesMap> filteredappRoutes = [];
  String group = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // appRoutes.sort((a, b) => a.compareTo(b));
  }

  bool showBorder(int index) {
    if (index == filteredappRoutes.length - 1) {
      return false;
    }
    if (group.compareTo(filteredappRoutes[index + 1].group) != 0) {
      return false;
    }

    return true;
  }

  void search(String query) {
    setState(() {
      filteredappRoutes.clear();
      if (query.length >= 2) {
        for (final i in appRoutes) {
          if (i.displayText.toLowerCase().contains(query.toLowerCase())) {
            filteredappRoutes.add(i);
          }
        }
        filteredappRoutes.sort((a, b) {
          int groupComparison = a.group.compareTo(b.group);
          if (groupComparison != 0) {
            return groupComparison;
          } else {
            return a.displayText.compareTo(b.displayText);
          }
        });
        group = "";
      } else {
        filteredappRoutes.clear();
      }
    });
  }

  var isPrevElementModule = false;

  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeaderWidgetWithBackButton(
                  topPadding: 24,
                  leftPadding: 14,
                  heading: translation(context).search,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              UserProfileWidget(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * w),
                child: TextField(
                  cursorColor: AppColors.lightGrey1,
                  style: GoogleFonts.poppins(
                    color: AppColors.titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: 0.50,
                  ),
                  controller: searchController,
                  maxLength: 50,
                  onChanged: (inputText) {
                    String inputQuery = inputText.trimLeft();
                    logger.e("inputQuery: $inputQuery");
                    if (inputQuery.isNotEmpty) {
                      search(inputQuery);
                    }
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: const EdgeInsets.all(0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: AppColors.lightGrey2),
                      borderRadius: BorderRadius.circular(8 * r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: AppColors.lightGrey2),
                      borderRadius: BorderRadius.circular(8 * r),
                    ),
                    hintText: translation(context).searchByFeatureName,
                    hintStyle: GoogleFonts.poppins(
                      color: AppColors.hintColor,
                      fontSize: 14 * f,
                      fontWeight: FontWeight.w400,
                      height: 20 / 14,
                      letterSpacing: 0.50 * w,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.grayText,
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: AppColors.lightGrey2),
                      borderRadius: BorderRadius.circular(8 * r),
                    ),
                  ),
                ),
              ),
              Expanded(
                child:
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24 * w),
                      child: ClubbedListView(h, f, w, r, searchController.text.length),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ClubbedListView(double h, double f, double w, double r, int len) {
    logger.e("filteredappRoutes.length: ${filteredappRoutes.length}");
    if (filteredappRoutes.isEmpty && len > 1) {
      return Center(
          child: Text(
        translation(context).noSearchRecordFound,
        style: GoogleFonts.poppins(
          color: AppColors.grayText,
          fontSize: 14 * f,
          fontWeight: FontWeight.w600,
          height: 20 / 14,
          letterSpacing: 0.10 * w,
        ),
      ));
    } else {
      return ListView.builder(
        itemCount: filteredappRoutes.length,
        itemBuilder: (context, index) {
          if (filteredappRoutes[index].group.compareTo(group) != 0) {
            group = filteredappRoutes[index].group;
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpace(height: 24),
                  RouteGrp(text: group),
                  const VerticalSpace(height: 16),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushNamed(
                          context, filteredappRoutes[index].route),
                    },
                    child: RouteElement(
                        text: filteredappRoutes[index].displayText,
                        query: searchController.text.trimLeft(),
                        showBorder: showBorder(index)),
                  ),
                ]);
          } else {
            return GestureDetector(
              onTap: () => {
                Navigator.pushNamed(context, filteredappRoutes[index].route),
              },
              child: Column(
                children: [
                  const VerticalSpace(height: 16),
                  RouteElement(
                      text: filteredappRoutes[index].displayText,
                      query: searchController.text.trimLeft(),
                      showBorder: showBorder(index)),
                ],
              ),
            );
          }
        },
      );
    }
  }

  static List<AppRoutesMap> getFilterAppRoutes(List<AppRoutesMap> searchList) {
    logger.e("searchList.length: ${searchList.length}");
    UserDataController controller = Get.find();
    logger.e("controller.userType: ${controller.userType}");
    List<AppRoutesMap> finalAppRoutes = [];
    for (var i in searchList) {
      print(
          "Supported Role: ##${i.supportedRoles}## || ##${controller.userType.toUpperCase()}##");
      print(i.supportedRoles.contains(controller.userType.toUpperCase()));
      print(
          (controller.isPrimaryNumberLogin ? true : i.isAvailableToSecondary));
      if (i.supportedRoles.contains(controller.userType.toUpperCase()) &&
          (controller.isPrimaryNumberLogin ? true : i.isAvailableToSecondary)) {
        finalAppRoutes.add(i);
      }
    }
    logger.e("Distributor.length: ${finalAppRoutes.length}");
    return finalAppRoutes;
  }
}

class RouteElement extends StatelessWidget {
  const RouteElement({
    Key? key,
    required this.text,
    required this.query,
    required this.showBorder,
  }) : super(key: key);
  final bool showBorder;
  final String text;
  final String query;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    // Split the text into parts before and after the query
    int queryIndex = text.toLowerCase().indexOf(query.toLowerCase());
    String beforeQuery = text.substring(0, queryIndex);
    String searchQuery = text.substring(queryIndex, queryIndex + query.length);
    String afterQuery = text.substring(queryIndex + query.length);
    return Container(
      padding: EdgeInsets.only(bottom: 12 * h),
      decoration: showBorder
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: AppColors.lightGrey2),
              ),
            )
          : const BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                color: AppColors.lumiDarkBlack,
                fontSize: 14 * f,
                fontWeight: FontWeight.w400,
                height: 24 / 14,
                letterSpacing: 0.10 * w,
              ),
              children: [
                TextSpan(text: beforeQuery),
                TextSpan(text: searchQuery),
                TextSpan(
                  text: afterQuery,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600, // Make the query text bold
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              height: 24 * r,
              width: 24 * r,
              child: Icon(
                Icons.arrow_outward_outlined,
                size: 20 * r,
                color: AppColors.lumiBluePrimary,
              )),
        ],
      ),
    );
  }
}

class RouteGrp extends StatelessWidget {
  RouteGrp({super.key, required this.text});

  String text;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColors.grayText,
        fontSize: 14 * f,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.10 * w,
      ),
    );
  }
}
