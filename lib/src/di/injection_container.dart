import 'package:get_it/get_it.dart';
import '../bloc/aadhaar_auth_cubit.dart';
import '../data/repository/server_repository_impl.dart';
import '../domain/repository/server_repository.dart';
import '../domain/useCases/attestation_uc.dart';
import '../domain/useCases/check_rdinstalled_uc.dart';
import '../domain/useCases/dashboard_uc.dart';
import '../domain/useCases/face_auth_req_uc.dart';
import '../domain/useCases/start_facerd_uc.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;
bool _diInitialized = false;
Future<void> injectionContainer() async {

  if (_diInitialized) return;

  // ******** CORE ********
  getIt.registerLazySingleton(() => DioClient());

  // ******** REPOSITORIES ********
  getIt.registerLazySingleton<ServerRepository>(
        () => ServerRepositoryImpl(getIt<DioClient>()),
  );

  // ******** USE CASES ********
  getIt.registerLazySingleton(() => DashboardUseCase(getIt()));
  getIt.registerLazySingleton(() => FaceAuthRequestUseCase(getIt()));
  getIt.registerLazySingleton(() => AttestationUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckRdInstalledUseCase(getIt()));
  getIt.registerLazySingleton(() => StartFaceRdUseCase(getIt()));

  // ******** CUBITS ********
  getIt.registerFactoryParam<AadhaarAuthCubit, String, String>(
        (appCode, userData) => AadhaarAuthCubit(
      getIt<AttestationUseCase>(),
      getIt<DashboardUseCase>(),
      getIt<CheckRdInstalledUseCase>(),
      getIt<StartFaceRdUseCase>(),
      getIt<FaceAuthRequestUseCase>(),
      appCode: appCode,
      userData: userData,
    ),
  );

  _diInitialized = true;

}
