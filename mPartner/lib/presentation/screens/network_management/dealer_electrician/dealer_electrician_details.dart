import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../../../state/contoller/ISmartCashHistoryController.dart';
import '../../../../state/contoller/Ismart_coin_history_controller.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../state/contoller/dealer_electrician_view_detailController.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/common_bottom_sheet.dart';
import '../../../widgets/upcoming_feature.dart';
import '../../base_screen.dart';
import '../../ismart/cash_coins_history/cash_coin_history_screen.dart';
import '../../userprofile/user_profile_widget.dart';
import 'components/common_network_utils.dart';
import 'components/custom_check_box.dart';
import 'components/delete_button.dart';
import 'components/heading_dealer.dart';
import 'components/redumption_confirmation_screen.dart';
import 'components/remove_unmap_dealer_screen.dart';
import 'components/submit_button.dart';
import 'components/view_pan_image_widget.dart';

class DealerElectricianDetails extends StatefulWidget {
  final String selectedUserType;
  final String id;
  // final DealerElectricianDetail listItemData;
  // final DealerElectricianDetail? statusData;

  const DealerElectricianDetails(
      {super.key,
        required this.selectedUserType,
        required this.id,
        //   this.index = 1,
        //  required this.listItemData,
        // this.statusData
      });

  @override
  State<DealerElectricianDetails> createState() =>
      _DealerElectricianDetailsState();
}

class _DealerElectricianDetailsState
    extends BaseScreenState<DealerElectricianDetails> {
  late double variablePixelHeight;
  late double variablePixelWidth;
  late double variablePixelMultiplier;
  late double textMultiplier;
  DealerElectricianViewDetailsController viewController = Get.find();
  CreateDealerElectricianController controller = Get.find();
  DealerElectricianViewDetailsController createController = Get.find();
  ISmartCashHistoryController cashHistory = Get.find();
  ISmartCoinHistoryController coinHistory = Get.find();
  CashSummaryController cashSumHistory = Get.find();
  CoinsSummaryController coinSumHistory = Get.find();

  @override
  void initState() {
    callDealerElectricianDetail();
    super.initState();
  }

  @override
  void dispose() {
    viewController.isRedembtionBlock.value = false;
    viewController.dealerElectricianStatusListDetails.value= DealerElectricianDetail();
    super.dispose();

  }

  Future callDealerElectricianDetail() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewController
          .getDealerElectricanListDetails(widget.id,widget.selectedUserType);
      setState(() {
        viewController.isRedembtionBlock.value =
        viewController.dealerElectricianStatusListDetails.value.blocked == 0 ? false : true;
      });
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    if (widget.selectedUserType == UserType.electrician) {
      controller.userType = UserType.electrician;
      createController.userType = UserType.electrician;
      viewController.userType = UserType.electrician;
    } else {
      controller.userType = UserType.dealer;
      createController.userType = UserType.dealer;
      viewController.userType = UserType.dealer;
    }
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRoutes.viewDetails);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.viewDetails);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        bottomNavigationBar: submitButtonWidget(),
        body: Container(
          //height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
              horizontal: 24 * variablePixelWidth,
              vertical: 24 * variablePixelHeight),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: variablePixelHeight * 34),
            HeadingDealer(
                heading: widget.selectedUserType == UserType.dealer
                    ? translation(context).dealerDetails
                    : translation(context).electricianDetails,
                controller: viewController,
                callBackBtnClick:(){
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.viewDetails);
                  } else {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.viewDetails);
                  }
                }
            ),
            UserProfileWidget(
              horizontalPadding: 0,
              top: 20 * variablePixelHeight,
            ),
            Expanded(
              child: SingleChildScrollView(child: Column(children: [
                Obx(
                      () => (viewController.isDetailAPILoading.value)
                      ? Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 150 * variablePixelHeight),
                    child: CircularProgressIndicator(),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      newProfileWidget(),
                      SizedBox(
                        height: 25 * variablePixelHeight,
                      ),
                      Text(
                        translation(context).ownerName,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          letterSpacing: 0.10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightGreyBorder,
                        ),
                      ),
                      SizedBox(
                        height: 5 * variablePixelHeight,
                      ),
                      Text(
                        ((viewController.dealerElectricianStatusListDetails.value.ownerName ?? "").isEmpty)
                            ? "-"
                            : viewController.dealerElectricianStatusListDetails.value.ownerName!,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackText,
                        ),
                      ),
                      SizedBox(
                        height: 16 * variablePixelHeight,
                      ),
                      Text(
                        translation(context).mobileNumber,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          letterSpacing: 0.10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightGreyBorder,
                        ),
                      ),
                      SizedBox(
                        height: 5 * variablePixelHeight,
                      ),
                      Text(
                        "${viewController.dealerElectricianStatusListDetails.value.phoneNo}",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackText,
                        ),
                      ),
                      SizedBox(
                        height: 16 * variablePixelHeight,
                      ),
                      Text(
                        translation(context).emailId,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          letterSpacing: 0.10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightGreyBorder,
                        ),
                      ),
                      SizedBox(
                        height: 5 * variablePixelHeight,
                      ),
                      Text(
                        viewController.dealerElectricianStatusListDetails.value.emailId ?? "",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackText,
                        ),
                      ),
                      SizedBox(
                        height: 16 * variablePixelHeight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translation(context).panCardNumber,
                            style: GoogleFonts.poppins(
                              fontSize: 14.0 * textMultiplier,
                              letterSpacing: 0.10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.lightGreyBorder,
                            ),
                          ),
                          Visibility(
                            visible: (viewController.dealerElectricianStatusListDetails.value.panNumber != null &&
                                viewController.dealerElectricianStatusListDetails.value.panNumber != ""),
                            child: InkWell(
                              onTap: () {
                                showCustomEditBottomSheet(
                                    viewController.dealerElectricianStatusListDetails.value);
                              },
                              child: Container(
                                height: 40 * variablePixelHeight,
                                padding: EdgeInsets.only(
                                    top: 4 * variablePixelHeight,
                                    bottom: 4 * variablePixelHeight),
                                child: Text(
                                  translation(context).viewPanCard,
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.0 * textMultiplier,
                                      letterSpacing: 0.10,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lumiBluePrimary),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5 * variablePixelHeight,
                      ),
                      Text(
                        (viewController.dealerElectricianStatusListDetails.value.panNumber == null &&
                            viewController.dealerElectricianStatusListDetails.value.panNumber == "")
                            ? translation(context).notSubmitted
                            : viewController.dealerElectricianStatusListDetails.value.panNumber ?? "",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackText,
                        ),
                      ),
                      SizedBox(
                        height: 16 * variablePixelHeight,
                      ),
                      rowWidget(translation(context).blockRedumption, "",
                          variablePixelWidth, variablePixelHeight),
                      undo_Block(),
                      SizedBox(
                        height: 20 * variablePixelHeight,
                      ),
                    ],
                  ),
                )
              ],),),
            ),
          ]),
        ),
      ),
    );
  }

  Widget rowWidget(String data1, String data2, double variablePixelWidth,
      double variablePixelHeight) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (data2.isNotEmpty)
              ? Text(
            data1,
            style: GoogleFonts.poppins(
              fontSize: 14.0 * textMultiplier,
              letterSpacing: 0.10,
              height: 0.10,
              fontWeight: FontWeight.w500,
              color: AppColors.lightGreyBorder,
            ),
          )
              :
          Obx(() => Row(
            children: [
              Text(data1,
                  style: GoogleFonts.poppins(
                    fontSize: 14.0 * textMultiplier,
                    letterSpacing: 0.10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightGreyBorder,
                  )),
              (viewController.isRedembtionBlock.value)
                  ? SizedBox(
                width: 10 * variablePixelHeight,
              )
                  : Container(),
              viewController.isRedembtionBlock.value
                  ? SvgPicture.asset(
                "assets/mpartner/network/warning.svg",height: 20*variablePixelHeight,width: 20*variablePixelWidth,)
                  : Container()
            ],
          )),
          if (data2.isNotEmpty)Expanded(
            child: InkWell(
              onTap: () {
                if (data1 == "") {
                  showCustomEditBottomSheet(viewController.dealerElectricianStatusListDetails.value);
                }
              },
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(
                    top: data1 == "" ? 12 * variablePixelHeight : 0,
                    bottom: data1 == "" ? 12 * variablePixelHeight : 0),
                child: Text(
                  data1 == "" ? translation(context).viewPanCard : data2,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    fontSize: 14.0 * textMultiplier,
                    letterSpacing: 0.10,
                    fontWeight: FontWeight.w500,
                    color: (data1 == "")
                        ? AppColors.lumiBluePrimary
                        : AppColors.blackText,
                  ),
                ),
              ),
            ),
          )
          else
            Obx(
                  (){
                if (widget.selectedUserType == UserType.electrician){
                  return  CustomCheckbox(
                    side: BorderSide(color: AppColors.grayText.withOpacity(0.7), width: 1.5),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: viewController.isRedembtionBlock.value,
                    activeColor: AppColors.lumiBluePrimary,
                    onChanged: (value) async {
                      if (value!) {
                        CommonBottomSheet.show(
                            context,
                            RedumptionConfirmationScreenWidget(
                                onItemSelected: (selectedState) async {
                                  Navigator.of(context).pop();
                                  if (selectedState == "yes") {
                                    viewController.isRedembtionBlock.value =
                                        value ?? false;
                                    bool response = await viewController
                                        .setDealerElectricanBlockRedumption(
                                        value,
                                        (widget.selectedUserType ==
                                            UserType.dealer)
                                            ? viewController.dealerElectricianStatusListDetails.value.code!
                                            :viewController.dealerElectricianStatusListDetails.value.electricianId!,widget.selectedUserType);
                                    /* if (!response) {
                                  viewController.isRedembtionBlock.value =
                                      !viewController.isRedembtionBlock.value;
                                }*/
                                    callDealerElectricianDetail();
                                  }
                                },
                                contentTiltle:
                                translation(context).confirmationAlert,
                                message: widget.selectedUserType != UserType.dealer
                                    ? translation(context).alertContentDealer
                                    : translation(context).alertContentElectrician),
                            variablePixelHeight,
                            variablePixelWidth);
                      } else {
                        viewController.isRedembtionBlock.value = value ?? false;
                        bool response =
                        await viewController.setDealerElectricanBlockRedumption(
                            value,
                            (widget.selectedUserType == UserType.dealer)
                                ? viewController.dealerElectricianStatusListDetails.value.code!
                                : viewController.dealerElectricianStatusListDetails.value.electricianId!,widget.selectedUserType);

                        /* if (!response) {
                      viewController.isRedembtionBlock.value =
                          !viewController.isRedembtionBlock.value;
                    }*/
                        callDealerElectricianDetail();
                      }
                    },
                  );
                }else{
                  return InkWell(child:viewController.dealerElectricianStatusListDetails.value.dealerBlockRedemptionStatus==""? Icon(Icons.toggle_off,size: 60,color: AppColors.grey,):(viewController.dealerElectricianStatusListDetails.value.dealerBlockRedemptionStatus=="1"&&viewController.dealerElectricianStatusListDetails.value.ambmBlockRedemptionStatusForDealer=="1")? Icon(Icons.toggle_on,size: 60,color: AppColors.lumiBluePrimary):viewController.dealerElectricianStatusListDetails.value.dealerBlockRedemptionStatus=="1"?Icon(Icons.toggle_on,size: 60,color: AppColors.lumiBluePrimary.withOpacity(.4),):new Container(),onTap: () async {
                    if(viewController.dealerElectricianStatusListDetails.value.dealerBlockRedemptionStatus==""||viewController.dealerElectricianStatusListDetails.value.ambmBlockRedemptionStatusForDealer=="1"){
                      if(viewController.dealerElectricianStatusListDetails.value.dealerBlockRedemptionStatus=="")
                        CommonBottomSheet.show(
                          context,
                          RedumptionConfirmationScreenWidget(
                              onItemSelected: (selectedState) async {
                                Navigator.of(context).pop();
                                if (selectedState == "yes") {
                                  bool response = await viewController.setDealerElectricanBlockRedumption(true,viewController.dealerElectricianStatusListDetails.value.code!,widget.selectedUserType);
                                  callDealerElectricianDetail();
                                }
                              },
                              contentTiltle:
                              translation(context).confirmationAlert,
                              message: widget.selectedUserType != UserType.dealer
                                  ? translation(context).alertContentDealer
                                  : translation(context).alertContentElectrician),
                          variablePixelHeight,
                          variablePixelWidth);
                      else if(viewController.dealerElectricianStatusListDetails.value.ambmBlockRedemptionStatusForDealer=="1"){
                        CommonBottomSheet.show(
                            context,
                            RedumptionConfirmationScreenWidget(
                                onItemSelected: (selectedState) async {
                                  Navigator.of(context).pop();
                                  if (selectedState == "yes") {
                                    bool response = await viewController.setDealerElectricanBlockRedumption(false,viewController.dealerElectricianStatusListDetails.value.code!,widget.selectedUserType);
                                    callDealerElectricianDetail();
                                  }
                                },
                                contentTiltle:translation(context).unblock_redeption,
                                message:"You are about to unblock this dealer for Redemption."),
                            variablePixelHeight,
                            variablePixelWidth);





                      }

                    }

                  },);
                }




              },
            ),
        ],
      ),
    );
  }

  Widget submitButtonWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SubmitButton(
            onPressed: () {
              if (widget.selectedUserType == UserType.electrician) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpcomingFeatureScreen()),
                );
              } else {
                cashHistory.clearIsmartCashHistory();
                cashHistory.clearIsmartCashHistoryFilterData();
                cashHistory.clearCashHistoryList();
                coinHistory.clearCoinHistoryList();
                coinHistory.clearIsmartCoinHistoryFilterData();
                coinHistory.clearIsmartCoinHistory();
                coinSumHistory.clearCoinSummaryData(
                    code: viewController.dealerElectricianStatusListDetails.value.code);
                cashSumHistory.clearCashSummaryData(
                    code: viewController.dealerElectricianStatusListDetails.value.code);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CashCoinHistoryScreen(
                          cardType: FilterCashCoin.cashType,
                          isFromPerformanceScreen: true,
                          listItemData:
                          /*widget.selectedUserType == UserType.electrician
                                    ?*/ viewController
                              .dealerElectricianStatusListDetails
                              .value,
                          // : widget.listItemData,
                          selectedUserType: widget.selectedUserType,
                        )));
              }
            },
            isEnabled: true,
            containerBackgroundColor: AppColors.white,
            buttonText: (widget.selectedUserType == UserType.dealer)
                ? translation(context).view +
                translation(context).dealerPerformance
                : translation(context).view +
                translation(context).electricianPerformance),
        SizedBox(height: 10,),

        if(widget.selectedUserType == UserType.dealer)Obx((){
          if(viewController.dealerElectricianStatusListDetails.value.dealerUnmappedStatus==""||viewController.dealerElectricianStatusListDetails.value.dealerUnmappedStatus=="1"||viewController.dealerElectricianStatusListDetails.value.dealerUnmappedStatus=="0")return DeleteButton(
            onPressed: () {
              if(viewController.dealerElectricianStatusListDetails.value.dealerUnmappedStatus==""||viewController.dealerElectricianStatusListDetails.value.dealerUnmappedStatus=="0")
                CommonBottomSheet.show(context,RemoveUnmapDealerScreen(
                    onItemSelected: (selectedState) async {
                      Navigator.of(context).pop();
                      if (selectedState == "yes") {
                        await viewController.DealerMapUnmap(true,widget.id,widget.selectedUserType,context).then((message) async {
                          if(message!=""){
                            await CommonBottomSheet.openSuccessSheet(context, "Request Submitted",message.toString());
                            callDealerElectricianDetail();
                          }
                        });

                      }
                    },
                    contentTiltle:translation(context).submitRequest,
                    message:translation(context).removeOrUnmapDealerconfirmationmessage), variablePixelHeight, variablePixelWidth);
            },
            isEnabled: (viewController.dealerElectricianStatusListDetails.value.dealerUnmappedStatus==""||viewController.dealerElectricianStatusListDetails.value.dealerUnmappedStatus=="0")?true:false,
            colors:(viewController.dealerElectricianStatusListDetails.value.dealerUnmappedStatus==""||viewController.dealerElectricianStatusListDetails.value.dealerUnmappedStatus=="0")? AppColors.red:AppColors.red.withOpacity(.2),
            buttonText: translation(context).removeOrUnmapDealer,);
          else return Container();
        }),
        new SizedBox(height: 10,),
        if(viewController.dealerElectricianStatusListDetails.value.dealerRemovalMessage!=null&&viewController.dealerElectricianStatusListDetails.value.dealerRemovalMessage.toString().length>0)

          Padding(padding: EdgeInsets.only(left: 24 *variablePixelWidth,right: 24*variablePixelWidth,bottom: 20),child: Text.rich(
            TextSpan(children: [
              TextSpan(text: viewController.dealerElectricianStatusListDetails.value.dealerRemovalMessage.toString()+" ",style:GoogleFonts.poppins(
                  fontSize: 12.0 * textMultiplier,
                  letterSpacing: 0.10,
                  fontWeight: FontWeight.w500,
                  color:(viewController.dealerElectricianStatusListDetails.value.ambmStatus.toString()=="")?AppColors.black:(viewController.dealerElectricianStatusListDetails.value.ambmStatus.toString()=="1")?AppColors.green:AppColors.red) ),
              if(viewController.dealerElectricianStatusListDetails.value.dealerUnmappedStatus=="1") TextSpan(recognizer: TapGestureRecognizer()..onTap = () async {
                CommonBottomSheet.show(context,RemoveUnmapDealerScreen(
                    onItemSelected: (selectedState) async {
                      Navigator.of(context).pop();
                      if (selectedState == "yes") {
                        await viewController.DealerMapUnmap(false,widget.id,widget.selectedUserType,context).then((message) async {
                          if(message!=""){
                            Utils().showToast(message.toString(), context);
                            callDealerElectricianDetail();
                          }

                        });

                      }
                    },
                    contentTiltle:translation(context).undorequest,
                    message:translation(context).dealerundoconfirmationmessage), variablePixelHeight, variablePixelWidth);

                },
                  text: 'Undo',
                  style:GoogleFonts.poppins(
                    fontSize: 12.0 * textMultiplier,
                    letterSpacing: 0.10,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    color:AppColors.lumiBluePrimary,)),

            ],
            ),
          ),)
      ],
    );
  }

  Widget newProfileWidget() {
    var variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lumiLight5,
          borderRadius:
          BorderRadius.all(Radius.circular(12 * variablePixelMultiplier))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70 * variablePixelHeight,
                width: 100 * variablePixelWidth,
                child: Stack(
                  children: [
                    Positioned(
                      top: 5 * variablePixelHeight,
                      left: 5 * variablePixelWidth,
                      child: CircleAvatar(
                        backgroundColor: AppColors.lumiLight5,
                        radius: 22.0 * variablePixelMultiplier,
                        child: Icon(
                          Icons.account_circle_sharp,
                          size: 90 * variablePixelMultiplier,
                          color: AppColors.white,
                        ),
                        //backgroundImage: NetworkImage(state.userProfileData.profileImg),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 100 * variablePixelHeight,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 15 * variablePixelHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (widget.selectedUserType == UserType.dealer)
                                ? translation(context).dealerCode
                                : translation(context).electricianCode,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0 * textMultiplier,
                              letterSpacing: 0.10,
                              height: 0.10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.lumiBluePrimary.withOpacity(0.7),
                            ),
                          ),
                          Container(
                            //height: 34 * variablePixelHeight,
                            width: ((viewController.dealerElectricianStatusListDetails.value.status == "1" ||
                                viewController.dealerElectricianStatusListDetails.value.status ==
                                    "Active")
                                ? 80
                                : 100) *
                                variablePixelWidth,
                            margin:
                            EdgeInsets.only(right: 14 * variablePixelWidth),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: (viewController.dealerElectricianStatusListDetails.value.status == "1" ||
                                    viewController.dealerElectricianStatusListDetails.value.status ==
                                        "Active")
                                    ? AppColors.green10
                                    : AppColors.red10,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    12 * variablePixelMultiplier))),
                            padding: EdgeInsets.only(
                                right: 6 * variablePixelWidth,
                                bottom: 2 * variablePixelHeight,
                                top: 2 * variablePixelHeight,
                                left: 6 * variablePixelWidth),
                            child: Text(
                              (viewController.dealerElectricianStatusListDetails.value.status == "1" ||
                                  viewController.dealerElectricianStatusListDetails.value.status ==
                                      "Active")
                                  ? translation(context).active
                                  : translation(context).inActive,
                              //  textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 12.0 * textMultiplier,
                                letterSpacing: 0.10,
                                fontWeight: FontWeight.w500,
                                color: (viewController.dealerElectricianStatusListDetails.value.status == "1" ||
                                    viewController.dealerElectricianStatusListDetails.value.status ==
                                        "Active")

                                    ? AppColors.successGreen
                                    : AppColors.errorRed,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10 * variablePixelHeight,
                      ),
                      Text(
                        (widget.selectedUserType == UserType.dealer)
                            ? ((viewController.dealerElectricianStatusListDetails.value.id == null ||
                            viewController.dealerElectricianStatusListDetails.value.id == "")
                            ? viewController.dealerElectricianStatusListDetails.value.code
                            : viewController.dealerElectricianStatusListDetails.value.id)
                            .toString()
                            : viewController.dealerElectricianStatusListDetails.value.code.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12.0 * textMultiplier,
                          letterSpacing: 0.10,
                          height: 0.10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackText,
                        ),
                      ),
                      SizedBox(
                        height: 12 * variablePixelHeight,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            (widget.selectedUserType == UserType.dealer)
                                ? viewController.dealerElectricianStatusListDetails.value.name ?? ""
                                : "",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0 * textMultiplier,
                              letterSpacing: 0.10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                left: 15 * variablePixelWidth,
                right: 15 * variablePixelWidth,
                bottom: 15 * variablePixelHeight),
            height: 1 * variablePixelHeight,
            width: MediaQuery.of(context).size.width,
            color: AppColors.dividerGreyColor,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 15 * variablePixelWidth,
                right: 20 * variablePixelWidth,
                bottom: 8 * variablePixelHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translation(context).address,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 12.0 * textMultiplier,
                    letterSpacing: 0.10,
                    height: 0.10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lumiBluePrimary.withOpacity(0.7),
                  ),
                ),
                SizedBox(
                  height: 12 * variablePixelHeight,
                ),
                Text(
                  viewController.dealerElectricianStatusListDetails.value.address1 ?? "",
                  maxLines: 4,
                  style: GoogleFonts.poppins(
                    fontSize: 12.0 * textMultiplier,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackText,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showCustomEditBottomSheet(DealerElectricianDetail listItemData) async {
    double height = 310 * variablePixelHeight;
    bool isVerticleScroll = false;
    double bottomsheetHeight =
        (MediaQuery.of(context).size.height * 0.5) * variablePixelHeight;
    try {
      var file =
      await DefaultCacheManager().getSingleFile(listItemData?.pan ?? "");
      if (file != null) {
        var data = await decodeImageFromList(file.readAsBytesSync());
        if (data.height > data.width) {
          height =
              (MediaQuery.of(context).size.height * 0.5) * variablePixelHeight;
          bottomsheetHeight =
              (MediaQuery.of(context).size.height * 0.8) * variablePixelHeight;
          isVerticleScroll = true;
        } else {
          height = 310 * variablePixelHeight;
          bottomsheetHeight = height + (200 * variablePixelHeight);
          isVerticleScroll = false;
        }
      } else {
        height = 310 * variablePixelHeight;
        bottomsheetHeight = height + (150 * variablePixelHeight);
        isVerticleScroll = false;
      }
    } catch (e) {
      height = 310 * variablePixelHeight;
      bottomsheetHeight = height + (200 * variablePixelHeight);
      isVerticleScroll = false;
    }
    CommonPANBottomSheet.show(
        context,
        ViewPanImageBottomSheetWidget(
            onItemSelected: (selectedState) async {
              Navigator.of(context).pop();
            },
            data: listItemData,
            height: height,
            bottomsheetHeight: bottomsheetHeight,
            isVerticleScroll: isVerticleScroll,
            contentTiltle: translation(context).pan),
        variablePixelHeight,
        variablePixelWidth);
  }

  Widget undo_Block() {
    if(widget.selectedUserType == UserType.dealer &&(viewController.dealerElectricianStatusListDetails.value.dealerBlockRedemptionStatus=="1"||viewController.dealerElectricianStatusListDetails.value.ambmBlockRedemptionStatusForDealer=="1"))  return   Padding(padding: EdgeInsets.only(left: 0 *variablePixelWidth,right: 24*variablePixelWidth,bottom: 20),child: Text.rich(
      TextSpan(children: [
        TextSpan(text: viewController.dealerElectricianStatusListDetails.value.blockRedemptionMessage.toString()+" ",style:GoogleFonts.poppins(
            fontSize: 12.0 * textMultiplier,
            letterSpacing: 0.10,
            fontWeight: FontWeight.w500,
            color:(viewController.dealerElectricianStatusListDetails.value.dealerBlockRedemptionStatus=="1"&&viewController.dealerElectricianStatusListDetails.value.ambmBlockRedemptionStatusForDealer=="1")?AppColors.green:AppColors.grey )),
        if(viewController.dealerElectricianStatusListDetails.value.dealerBlockRedemptionStatus=="1"&&viewController.dealerElectricianStatusListDetails.value.ambmBlockRedemptionStatusForDealer!="1")
          TextSpan(recognizer: TapGestureRecognizer()..onTap = () async {
            CommonBottomSheet.show(context,RemoveUnmapDealerScreen(
                onItemSelected: (selectedState) async {
                  Navigator.of(context).pop();
                  if (selectedState == "yes") {
                    bool response = await viewController.setDealerElectricanBlockRedumption(false,viewController.dealerElectricianStatusListDetails.value.code!,widget.selectedUserType);
                    Utils().showToast("Request cancelled successfully.", context);
                    callDealerElectricianDetail();

                  }
                },
                contentTiltle:translation(context).undorequest,
                message:"You are about to cancel the request for “Block Redemption” of dealer from your network."), variablePixelHeight, variablePixelWidth);



          },
              text: 'Undo',
              style:GoogleFonts.poppins(
                fontSize: 12.0 * textMultiplier,
                letterSpacing: 0.10,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
                color:AppColors.lumiBluePrimary,)),

      ],
      ),
    ),);
    else return Container();

  }
}

class CommonPANBottomSheet {
  static Future<void> show(BuildContext context, Widget body,
      double variablePixelHeight, double variablePixelWidth) {
    return showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: variablePixelHeight * 700),
      showDragHandle: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, 0, 16, 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                  visible: false,
                  child: Container(
                    width: 250 * variablePixelWidth,
                    height: 250 * variablePixelHeight,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                    ),
                  )),
              body,
            ],
          ),
        );
      },
    );
  }
}
