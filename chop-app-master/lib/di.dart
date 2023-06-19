import 'package:chop/data/data_sources/chop_local_data_source.dart';
import 'package:chop/data/data_sources/chop_remote_data_source.dart';
import 'package:chop/data/repositories/chop_repository_impl.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:chop/domain/use_cases/checkout_use_case.dart';
import 'package:chop/domain/use_cases/create_inventory_use_case.dart';
import 'package:chop/domain/use_cases/create_rescue_use_case.dart';
import 'package:chop/domain/use_cases/create_review_use_case.dart';
import 'package:chop/domain/use_cases/delete_inventory_use_case.dart';
import 'package:chop/domain/use_cases/delete_rescue_use_case.dart';
import 'package:chop/domain/use_cases/delete_review_use_case.dart';
import 'package:chop/domain/use_cases/get_inventories_use_case.dart';
import 'package:chop/domain/use_cases/get_inventory_use_case.dart';
import 'package:chop/domain/use_cases/get_rescue_inventories.dart';
import 'package:chop/domain/use_cases/get_rescue_use_case.dart';
import 'package:chop/domain/use_cases/get_rescues_use_case.dart';
import 'package:chop/domain/use_cases/get_review_use_case.dart';
import 'package:chop/domain/use_cases/get_reviews_use_case.dart';
import 'package:chop/domain/use_cases/get_user_use_case.dart';
import 'package:chop/domain/use_cases/get_vendors_use_case.dart';
import 'package:chop/domain/use_cases/log_out_use_case.dart';
import 'package:chop/domain/use_cases/login_use_case.dart';
import 'package:chop/domain/use_cases/register_use_case.dart';
import 'package:chop/domain/use_cases/update_inventory_use_case.dart';
import 'package:chop/domain/use_cases/update_rescue_use_case.dart';
import 'package:chop/domain/use_cases/update_review_use_case.dart';
import 'package:chop/domain/use_cases/verify_code_use_case.dart';
import 'package:chop/presentation/pages/checkout_page/cubit/checkout_page_cubit.dart';
import 'package:chop/presentation/pages/fii_home_page/cubit/fii_home_page_cubit.dart';
import 'package:chop/presentation/pages/fii_rescue_page/cubit/fii_rescue_page_cubit.dart';
import 'package:chop/presentation/pages/login_page/cubit/login_page_cubit.dart';
import 'package:chop/presentation/pages/profile_pages/cubit/profile_pages_cubit.dart';
import 'package:chop/presentation/pages/signup_page/cubit/signup_page_cubit.dart';
import 'package:chop/presentation/pages/vendor_add_item_page/cubit/vendor_add_item_page_cubit.dart';
import 'package:chop/presentation/pages/vendor_detail_page/cubit/vendor_detail_page_cubit.dart';
import 'package:chop/presentation/pages/vendor_inventory_page/cubit/vendor_inventory_page_cubit.dart';
import 'package:chop/presentation/pages/vendor_rescue_page/cubit/vendor_rescue_page_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  localDataSources(sl);
  remoteDataSources(sl);
  repositories(sl);
  useCases(sl);
  blocs(sl);
  externals(sl);
}

void repositories(GetIt sl) {
  sl.registerLazySingleton<ChopRepository>(
    () => ChopRepositoryImpl(sl(), sl()),
  );
}

void localDataSources(GetIt sl) {
  sl.registerLazySingleton<ChopLocalDataSource>(
    () => ChopLocalDataSourceImpl(sl()),
  );
}

void remoteDataSources(GetIt sl) {
  sl.registerLazySingleton<ChopRemoteDataSource>(
    () => ChopRemoteDataSourceImpl(sl()),
  );
}

void useCases(GetIt sl) {
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => CreateInventoryUseCase(sl()));
  sl.registerLazySingleton(() => CreateRescueUseCase(sl()));
  sl.registerLazySingleton(() => CreateReviewUseCase(sl()));
  sl.registerLazySingleton(() => DeleteInventoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteRescueUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReviewUseCase(sl()));
  sl.registerLazySingleton(() => GetInventoryUseCase(sl()));
  sl.registerLazySingleton(() => GetRescueUseCase(sl()));
  sl.registerLazySingleton(() => GetReviewUseCase(sl()));
  sl.registerLazySingleton(() => GetInventoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetRescuesUseCase(sl()));
  sl.registerLazySingleton(() => GetReviewsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateInventoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateRescueUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReviewUseCase(sl()));
  sl.registerLazySingleton(() => CheckOutUseCase(sl()));
  sl.registerLazySingleton(() => GetRescueInventoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetUserUseCase(sl()));
  sl.registerLazySingleton(() => GetVendorsUseCase(sl()));
  sl.registerLazySingleton(() => VerifyCodeUseCase(sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
}

void blocs(GetIt sl) {
  sl.registerFactory<CheckoutPageCubit>(
    () => CheckoutPageCubit(sl()),
  );
  sl.registerFactory<FIIHomePageCubit>(
    () => FIIHomePageCubit(sl(), sl()),
  );
  sl.registerFactory<FIIRescuePageCubit>(
    () => FIIRescuePageCubit(sl(), sl(), sl()),
  );
  sl.registerFactory<LoginPageCubit>(
    () => LoginPageCubit(sl()),
  );
  sl.registerFactory<SignupPageCubit>(
    () => SignupPageCubit(sl()),
  );
  sl.registerFactory<VendorAddItemPageCubit>(
    () => VendorAddItemPageCubit(sl(), sl()),
  );
  sl.registerFactory<VendorDetailPageCubit>(
    () => VendorDetailPageCubit(sl()),
  );
  sl.registerFactory<VendorInventoryPageCubit>(
    () => VendorInventoryPageCubit(sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<VendorRescuePageCubit>(
    () => VendorRescuePageCubit(sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<ProfilePagesCubit>(
    () => ProfilePagesCubit(sl()),
  );
}

void externals(GetIt sl) async {
  sl.registerLazySingleton(() => http.Client());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
