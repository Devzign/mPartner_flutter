import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../utils/app_constants.dart';
import '../../utils/localdata/shared_preferences_util.dart';

class AppSettingValueController extends GetxController {

  int solarRaiseRequestStartDateLimit=2;
  int solarRaiseRequestEndDateLimit=22;
  RxString solarviable="".obs;
  RxString isdeleted="".obs;
  RxString deletemesssage="".obs;
  RxBool loading=false.obs;

   RxString getAccountDeleted="".obs;



  @override
  void onInit() async {
    super.onInit();
  }

  Future<dynamic>fetchAppSettingValues(String type) async {
    loading.value=true;
    try {
      MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();
      final result = await mPartnerRemoteDataSource.fetchAppSettingValues(type);
      loading.value=false;
      result.fold(
            (failure) {
              logger.e(failure);
            },
            (data) {
           if(type==AppConstants.solarRequestRaisingDate){
             List<String> dateLimitList = data.split(",");
             if (dateLimitList.length > 1) {
               solarRaiseRequestStartDateLimit= int.parse(dateLimitList[0]);
               solarRaiseRequestEndDateLimit=int.parse(dateLimitList[1]);
             }
           } else if(type==AppConstants.solarvisible)  {
             solarviable.value=data.toString();
           }else if(type==AppConstants.IsUserDeleteEnable){
             isdeleted.value=data.toString();
           }else if(type==AppConstants.IsUserDeletemessage){
             deletemesssage.value=data.toString();

           }


        },
      );
    } finally {
      loading.value=false;
      logger.e("");
    }
    getIsDeleted();

  }


  clearData() async {
    solarRaiseRequestStartDateLimit=2;
    solarRaiseRequestEndDateLimit=22;
    update();
  }

  getIsDeleted() async {
    String? deletedValue=await SharedPreferencesUtil.getIsAccountDeleted();
    getAccountDeleted.value=deletedValue.toString();
  }


}
