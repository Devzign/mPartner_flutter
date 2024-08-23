import 'package:get_it/get_it.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../presentation/screens/ismart/registersales/secondarysales/bloc/secondary_sales_product_details_bloc.dart';
import '../../presentation/screens/language/bloc/language_bloc.dart';
import '../../presentation/screens/login/bloc/login_bloc.dart';
import '../../presentation/screens/userprofile/bloc/user_profile_bloc.dart';
import '../../presentation/screens/verifyotp/bloc/verify_otp_bloc.dart';
import '../gem/data/datasource/gem_remote_data_source.dart';
import '../gem/presentation/gem_tender/bloc/category_type_bloc.dart';
import '../gem/utils/term_conditions/term_and_conditions_bloc.dart';
import '../presentation/screens/home/Homescreen/scheme/bloc/scheme_homepage_bloc.dart';
import '../presentation/screens/ismart/registersales/bloc/register_sales_bloc.dart';
import '../presentation/screens/ismart/registersales/intermediary_sales/bloc/intermediary_sales_bloc.dart';
import '../presentation/screens/ismart/registersales/intermediary_sales/bloc/intermediary_sales_product_details_bloc.dart';
import '../presentation/screens/ismart/registersales/secondarysales/bloc/secondary_sales_bloc.dart';
import '../presentation/screens/ismart/registersales/tertiarysalesbulkorder/bloc/otp_bloc.dart';
import '../presentation/screens/ismart/registersales/tertiarysalesbulkorder/bloc/tertiary_sales_product_details_bloc.dart';
import '../presentation/screens/ismart/registersales/tertiarysalesbulkorder/bloc/tertiary_sales_product_save_details_bloc.dart';
import '../presentation/screens/our_products/bloc/product_bloc.dart';
import '../presentation/screens/our_products/tab_pricelist/bloc/pricelist_bloc.dart';
import '../solar/data/datasource/solar_remote_data_source.dart';

final sl = GetIt.instance;
final s2= GetIt.instance;
final s3= GetIt.instance;

class ServicesLocator {
  void init() {
    /// Bloc
    sl.registerFactory(() => LanguageBloc(sl()));
    sl.registerFactory(() => LoginBloc(sl()));
    sl.registerFactory(() => VerifyOtpBloc(sl()));
    sl.registerFactory(() => UserProfileBloc(sl()));
    sl.registerFactory(() => ProductBloc(sl()));
    sl.registerFactory(() => PricelistBloc(sl()));
    // sl.registerFactory(() => SchemeAPIBloc(sl()));
    sl.registerFactory(() => SchemeHomepageBloc(sl()));
    sl.registerFactory(() => RegisterSalesBloc(sl()));
    sl.registerFactory(() => SecondarySalesBloc(sl()));
    sl.registerFactory(() => SecondarySalesProductDetailsBloc(sl()));
    sl.registerFactory(() => TertiarySalesProductDetailsBloc(sl()));
    sl.registerFactory(() => TertiarySalesProductSaveDetailsBloc(sl()));
    sl.registerFactory(() => OTPBloc(sl()));
    sl.registerFactory(() => IntermediarySalesBloc(sl()));
    sl.registerFactory(() => IntermediarySalesProductDetailsBloc(sl()));
    // sl.registerFactory(() => ISmartController(sl()));

    /// DATA SOURCE
    sl.registerLazySingleton<BaseMPartnerRemoteDataSource>(
        () => MPartnerRemoteDataSource());
    s2.registerLazySingleton<BaseSolarRemoteDataSource>(
        () => SolarRemoteDataSource());

    s3.registerLazySingleton<BaseGemRemoteDataSource>(() => BaseGemRemoteDataSource());



    sl.registerFactory(() => CategoryTypeBloc(sl()));
    sl.registerFactory(() => TermsAndConditionsBloc(sl()));
  }
}
