//
// import 'package:get_it/get_it.dart';
// import 'package:dio/dio.dart';
// import '../network/api_service.dart';
// import '../network/dio_client.dart';
//
// import '../services/secure_storage_service.dart';
//
// final GetIt getIt = GetIt.instance;
//
// Future<void> setupDependencies() async {
//   // Dio singleton (lazy)
//   getIt.registerLazySingleton<Dio>(() => DioClient.instance);
//
//   // ApiService
//   getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));
//
//   // Secure Storage (assume singleton)
//   getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
//
//   // Agar aur services/repos hain to yahan register kar dena
//   // getIt.registerFactory<LeaderShipRepo>(() => LeaderShipRepo(getIt<ApiService>()));
// }