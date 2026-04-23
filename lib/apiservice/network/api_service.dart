// Step 8: API Service (lib/core/network/api_service.dart)
// Complete with all methods: get, post, put, patch, delete, multipart
import 'dart:io';
import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'network_utils.dart';
import '../exceptions/app_exceptions.dart';

class ApiService {
  final Dio _dio = DioClient.instance;

  Future<void> _checkInternet() async {
    if (!await hasInternet()) {
      throw NoInternetException();
    }
  }

  Future<dynamic> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patch(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patchMultipart(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
        bool isMultipart = false,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          extra: {'requiresAuth': requiresAuth},
          headers: {
            if (isMultipart)
              Headers.contentTypeHeader: 'multipart/form-data',
          },
        ),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  Future<dynamic> postMultipart(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
        bool isMultipart = false,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          extra: {'requiresAuth': requiresAuth},
          headers: {
            if (isMultipart)
              Headers.contentTypeHeader: 'multipart/form-data',
          },
        ),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  Future<dynamic> putMultipart(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
        bool isMultipart = false,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          extra: {'requiresAuth': requiresAuth},
          headers: {
            if (isMultipart)
              Headers.contentTypeHeader: 'multipart/form-data',
          },
        ),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  Future<dynamic> delete(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> uploadFiles(
      String endpoint, {
        required List<File> files,
        Map<String, dynamic>? fields,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final formData = FormData();
      if (fields != null) {
        formData.fields.addAll(fields.entries.map((e) => MapEntry(e.key, e.value.toString())));
      }
      for (int i = 0; i < files.length; i++) {
        formData.files.add(MapEntry(
          'file$i',
          await MultipartFile.fromFile(files[i].path, filename: files[i].path.split('/').last),
        ));
      }
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  Future<dynamic> sendMultipart({
    required String endpoint,
    required String method, // 'POST', 'PUT', 'PATCH'
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    await _checkInternet();
    try {
      Response response;
      final options = Options(
        method: method,
        extra: {'requiresAuth': requiresAuth},
        headers: {'Content-Type': 'multipart/form-data'},
      );

      if (method == 'POST') {
        response = await _dio.post(endpoint, data: formData, queryParameters: queryParameters, options: options);
      } else if (method == 'PUT') {
        response = await _dio.put(endpoint, data: formData, queryParameters: queryParameters, options: options);
      } else if (method == 'PATCH') {
        response = await _dio.patch(endpoint, data: formData, queryParameters: queryParameters, options: options);
      } else {
        throw ArgumentError('Unsupported multipart method: $method');
      }
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}


//// Example in your screen or viewmodel
// try {
//   final data = await repo.getLeaderShip();
//   // success
// } on NoInternetException {
//   showNoInternetScreen(context, onRetry: () => _fetchData()); // your retry logic
// } on ServerException {
//   showServerErrorScreen(context, onRetry: () => _fetchData());
// } on UnauthorizedException {
//   await SecureStorageService.logout(context);
//   // go to login screen
// } on DioException catch (e) {
//   // show snackbar with e.message or generic error
// } catch (e) {
//   // generic error
// }


// this code us when use repo class then use this



// leadership_repo.dart (updated)
// class LeaderShipRepo {
//   final ApiService _api = ApiService();
//
//   Future<LeaderShipModel> getLeaderShip() async {  // ← context hataya
//     try {
//       final response = await _api.get(
//         ApiConstants.leadershipChain,
//         requiresAuth: true,
//       );
//       return LeaderShipModel.fromJson(response);
//     } on DioException catch (e) {
//       // just rethrow → UI layer handle karega
//       rethrow;
//     } catch (e) {
//       throw ApiException(0, e.toString());
//     }
//   }
// }






//
//
// lib/
// ├── core/
// │   ├── constants/
// │   │   └── api_constants.dart          → URLs + endpoints
// │   ├── exceptions/
// │   │   └── app_exceptions.dart         → Custom exceptions (good)
// │   ├── network/
// │   │   ├── api_service.dart            → High-level HTTP methods (get/post/multipart)
// │   │   ├── dio_client.dart             → Dio setup + interceptors
// │   │   └── network_utils.dart          → Connectivity check + error screen helpers
// │   └── services/
// │       └── secure_storage_service.dart → Token storage + logout (assume kiya)
// ├── features/
// │   └── leadership/                     (example feature)
// │       ├── model/
// │       │   └── leaderShipModel.dart
// │       └── repo/
// │           └── leadership_repo.dart    → Repository with context (issue yahan hai)
// └── widgets/
// └── error_screens/
// ├── no_internet_screen.dart
// └── server_error_screen.dart