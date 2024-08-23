import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../state/contoller/dealer_electrician_view_detailController.dart';
import '../../../../state/contoller/new_dealer_electrician_status_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/headers/network_mgmnt_header_widget.dart';
import '../../base_screen.dart';
import '../../userprofile/user_profile_widget.dart';
import 'components/common_network_utils.dart';
import 'components/custom_check_box.dart';
import 'components/dealer_electrician_status_list_page.dart';


class NewDealerElectricianStatusScreen extends StatefulWidget {
  final String selectedUserType;
  const NewDealerElectricianStatusScreen({super.key, required this.selectedUserType});

  @override
  State<NewDealerElectricianStatusScreen> createState() => _NewDealerElectricianStatusScreenState();
}

class _NewDealerElectricianStatusScreenState extends BaseScreenState<NewDealerElectricianStatusScreen> {
  DealerElectricianViewDetailsController viewController = Get.find();
  NewDealerElectricianStatusController controller = Get.find();
  CreateDealerElectricianController createController = Get.find();

  @override
  void initState() {
    controller.userType=widget.selectedUserType;
    controller.isActive.value=true;
    controller.isRejected.value=true;
    controller.isPending.value=true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getStatusList();
    });
    super.initState();
  }

  TextEditingController _searchController = TextEditingController();

  @override
  Widget baseBody(BuildContext context) {
    if (widget.selectedUserType == UserType.electrician) {
      controller.userType = UserType.electrician;
      createController.userType = UserType.electrician;
      viewController.userType = UserType.electrician;
    } else {
      controller.userType = UserType.dealer;
      createController.userType = UserType.dealer;
      viewController.userType = UserType.dealer;
    }
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();

    var variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    var textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus
                                    ?.unfocus(),
      child:  WillPopScope(
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.viewDetails);
          } else {
            Navigator.of(context).pushReplacementNamed(AppRoutes.viewDetails);
          }
          return true;
        },
        child:  Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
          child: Column(
            children: [
              NetworkManagementHeaderWidget(heading:(widget.selectedUserType==UserType.dealer)?translation(context).newDealersStatus:translation(context).newElectricianStatus,
              callBackBtnClick: (){
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.viewDetails);
                } else {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.viewDetails);
                }
              },),
              UserProfileWidget(),
              Container(
                margin: EdgeInsets.only(
                    left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                constraints: BoxConstraints(maxHeight: variablePixelHeight * 100),
                height: variablePixelHeight * 50,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.grayText.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8*variablePixelMultiplier),
                ),
                child: TextField(
                  controller: _searchController,
                  maxLength: 50,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration:  InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.grayText,
                    ),
                    counterText: "",
                    hintText: translation(context).search,
                    hintStyle: const TextStyle(color: AppColors.grayText),
                    border: InputBorder.none, // Remove the default border
                  ),
                ),
              ),
              Obx(
                () =>Container(
                  margin: EdgeInsets.only(
                      left: 24 * variablePixelWidth, right: 24 * variablePixelWidth,top: 10*variablePixelHeight),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        bool value = !controller.isActive.value;
                        controller.isActive.value =
                                    value;
                        controller.getStatusList();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomCheckbox(
                              side: BorderSide(color:  AppColors.grayText.withOpacity(0.7),width: 1.5),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: controller.isActive.value,
                              activeColor: AppColors.lumiBluePrimary,
                              onChanged: (value) async{
                                controller.isActive.value =
                                    value ?? false;
                                controller.getStatusList();
                              /*  if(widget.selectedUserType==UserType.electrician) {

                                }
                                else{
                                await controller.getStatusListLocal();
                                setState(() {

                                });

                                }*/
                              },
                            ),
                          Container(
                            padding: EdgeInsets.only(left: 10*variablePixelWidth),
                            child: Text(
                              translation(context).accepted,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0 * textMultiplier,
                                letterSpacing: 0.10,
                                height: 0.10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        bool value = !controller.isPending.value;
                        controller.isPending.value =
                                    value;
                        controller.getStatusList();

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomCheckbox(
                              side: BorderSide(color:  AppColors.grayText.withOpacity(0.7),width: 1.5),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: controller.isPending.value,
                              activeColor: AppColors.lumiBluePrimary,
                              onChanged: (value)async  {
                                controller.isPending.value =
                                    value ?? false;
                                controller.getStatusList();
                              /* if(widget.selectedUserType==UserType.electrician) {
                                  controller.getStatusList();
                                }
                                else{
                                  await controller.getStatusListLocal();
                                  setState(() {

                                  });
                                }*/
                              },
                            ),
                          Container(
                            padding: EdgeInsets.only(left: 10*variablePixelWidth),
                            child: Text(
                              translation(context).pending,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0 * textMultiplier,
                                letterSpacing: 0.10,
                                height: 0.10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        bool value = !controller.isRejected.value;
                        controller.isRejected.value =
                                    value;
                        controller.getStatusList();

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomCheckbox(
                            side: BorderSide(color:  AppColors.grayText.withOpacity(0.7),width: 1.5),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: controller.isRejected.value,
                            activeColor: AppColors.lumiBluePrimary,
                            onChanged: (value) async{
                              controller.isRejected.value =
                                  value ?? false;
                              controller.getStatusList();
                            /*  if(widget.selectedUserType==UserType.electrician) {
                                controller.getStatusList();
                              }
                              else{
                                await controller.getStatusListLocal();
                                setState(() {

                                });
                              }*/
                            },
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10*variablePixelWidth),
                            child: Text(
                              translation(context).rejected,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0 * textMultiplier,
                                letterSpacing: 0.10,
                                height: 0.10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],),
                ),
              ),
               Expanded(
                  child: DealerElectricianStatusListPage(widget.selectedUserType, _searchController.text,))
            ],
          ),
        ),
      ),
    ),
    );
  }
}
