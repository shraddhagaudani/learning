import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/route_manager.dart';

import '../../../components/check_internet.dart';
import '../../../main.dart';
import '../../widgets/no_internet_screen.dart';
import '../app_constants.dart';
import '../app_strings.dart';

class NetworkDioHttp {
  late Dio _dio;

  NetworkDioHttp() {
    init();
  }

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiAppConstants.apiEndPoint,
        followRedirects: false,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
    initializeInterceptors();
  }

  initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.next(options);
      },
      onResponse: (e, handler) {
        handler.next(e);
      },
      onError: (e, handler) async {
        log("---------------------------  ${e.response?.statusCode}", name: 'STATUS_CODE');
        // logger.e("ERROR_DATA : ${e.response?.data}");
        switch (e.response?.statusCode) {
          case 400: //Bad Request
            debugPrint("0=========> ${e.response?.data.toString() ?? "Something Went Wrong"}");
            // CustomSnackBar.showGetXSnackBar(toastType: ToastType.error, message: e.response?.data["message"].toString() ?? "Something Went Wrong");
            break;
          case 401: //UnAuthorized User
            debugPrint("1=========> ${e.response?.data.toString() ?? "Something Went Wrong"}");
            // CustomSnackBar.showGetXSnackBar(toastType: ToastType.error, message: e.response?.data["message"].toString() ?? "Something Went Wrong");
            break;
          case 403: //Bad Request
            debugPrint("2=========> ${e.response?.data.toString() ?? "Something Went Wrong"}");
            // CustomSnackBar.showGetXSnackBar(toastType: ToastType.error, message: e.response?.data["message"].toString() ?? "Something Went Wrong");
            break;
          case 404: //Not Found
            debugPrint("3=========> ${e.response?.data.toString() ?? "Something Went Wrong"}");
            // CustomSnackBar.showGetXSnackBar(toastType: ToastType.error, message: e.response?.data["message"].toString() ?? "Something Went Wrong");
            break;
          case 500: //Internal Server Error
            debugPrint("4=========> ${e.response?.data.toString() ?? "Something Went Wrong"}");
            // CustomSnackBar.showGetXSnackBar(toastType: ToastType.error, message: e.response?.data["message"].toString() ?? "Something Went Wrong");
            break;
          case 501: //Internal Server Error
            debugPrint("5=========> ${e.response?.data.toString() ?? "Something Went Wrong"}");
            // CustomSnackBar.showGetXSnackBar(toastType: ToastType.error, message: e.response?.data["message"].toString() ?? "Something Went Wrong");
            break;

          default:
            debugPrint("6=========> ${"Something Went Wrong"}");
            // CustomSnackBar.showGetXSnackBar(toastType: ToastType.error, message: "Something Went Wrong");
            break;
        }
        handler.next(e);
      },
    ));
  }

  Future<Response?> postRequest({
    required String url,
    required bool isHeader,
    required bool isBody,
    Object? bodyData,
    name,
    bool? isBearer,
  }) async {
    final hasInternet = await checkInternet();
    Response response;
    if (hasInternet == true) {
      try {
        _dio.options.headers['Content-Type'] = 'application/json';
        _dio.options.headers['Accept'] = 'application/json';
        if (isHeader == true) {
          _dio.options.headers['Authorization'] = isBearer == true ? 'Bearer ${dataStorage.read(AppStrings.token)}' : dataStorage.read(AppStrings.token);
        }

        logger.i("$name REQUEST URL: $url"); // Log the URL
        logger.i("$name REQUEST Body: $bodyData"); // Log the body data

        response = isBody == true
            ? await _dio.post(url, data: bodyData)
            : await _dio.post(
          url,
          options: Options(
            responseType: ResponseType.plain,
          ),
        );

        logger.i("$name RESPONSE: ${response.data}"); // Log the response data
        return response;
      } on DioException catch (exception) {
        logger.e("$name ERROR: $exception"); // Log error
        return exception.response;
      }
    } else {
      logger.w("No internet connection!!");
      Get.to(() => const NoInterNetScreen());
    }
    return null;
  }

  Future<Response?> getRequest({
    required String url,
    required bool isHeader,
    String? name,
    bool? isBearer,
    Object? data,
  }) async {
    final hasInternet = await checkInternet();
    if (hasInternet) {
      try {
        _dio.options.headers['Content-Type'] = 'application/json';
        _dio.options.headers['Accept'] = 'application/json';
        if (isHeader) {
          _dio.options.headers['Authorization'] = isBearer == true ? 'Bearer ${dataStorage.read(AppStrings.token)}' : dataStorage.read(AppStrings.token);
        }

        logger.i("$name REQUEST URL: $url"); // Log the URL
        final response = await _dio.get(url,data: data,);

        logger.i("$name RESPONSE: ${response.data}"); // Log the response data
        return response;
      } on DioException catch (exception) {
        logger.e("$name ERROR: $exception"); // Log error
        return exception.response;
      } catch (e) {
        logger.e("$name Unexpected error: $e"); // Log unexpected errors
        return null;
      }
    } else {
      logger.w("No internet connection!!");
      Get.to(() => const NoInterNetScreen());
      return null;
    }
  }

  Future<Response?> putRequest({
    required String url,
    required bool isHeader,
    Object? bodyData,
    name,
    bool? isBearer,
  }) async {
    final hasInternet = await checkInternet();
    Response response;
    if (hasInternet == true) {
      try {
        _dio.options.headers['Content-Type'] = 'application/json';
        _dio.options.headers['Accept'] = 'application/json';
        if (isHeader == true) {
          _dio.options.headers['Authorization'] = isBearer == true ? 'Bearer ${dataStorage.read(AppStrings.token)}' : dataStorage.read(AppStrings.token);
        }

        logger.i("$name REQUEST URL: $url"); // Log the URL
        logger.i("$name REQUEST Body: $bodyData"); // Log the body data

        response = await _dio.put(url, data: bodyData);

        logger.i("$name RESPONSE: ${response.data}"); // Log the response data
        return response;
      } on DioException catch (exception) {
        logger.e("$name ERROR: $exception"); // Log error
        return exception.response;
      }
    } else {
      logger.w("No internet connection!!");
      Get.to(() => const NoInterNetScreen());
    }
    return null;
  }

  Future<Response?> deleteRequest({
    required String url,
    required bool isHeader,
    name,
    bool? isBearer,
  }) async {
    final hasInternet = await checkInternet();
    Response response;
    if (hasInternet == true) {
      try {
        _dio.options.headers['Content-Type'] = 'application/json';
        _dio.options.headers['Accept'] = 'application/json';
        if (isHeader == true) {
          _dio.options.headers['Authorization'] = isBearer == true ? 'Bearer ${dataStorage.read(AppStrings.token)}' : dataStorage.read(AppStrings.token);
        }

        logger.i("$name REQUEST URL: $url"); // Log the URL

        response = await _dio.delete(url);

        logger.i("$name RESPONSE: ${response.data}"); // Log the response data
        return response;
      } on DioException catch (exception) {
        logger.e("$name ERROR: $exception"); // Log error
        return exception.response;
      }
    } else {
      logger.w("No internet connection!!");
      Get.to(() => const NoInterNetScreen());
    }
    return null;
  }

  Future<Response?> uploadMediaRequest({
    required String url,
    required FormData formData,
    required bool isHeader,
    name,
    bool? isBearer,
  }) async {
    final hasInternet = await checkInternet();
    Response response;
    if (hasInternet == true) {
      try {
        _dio.options.headers['content-Type'] = "multipart/form-data";
        if (isHeader == true) {
          _dio.options.headers['Authorization'] = isBearer == true ? 'Bearer ${dataStorage.read(AppStrings.token)}' : dataStorage.read(AppStrings.token);
        }

        logger.i("$name REQUEST URL: $url"); // Log the URL
        logger.i("$name REQUEST Body: $formData"); // Log the body data

        response = await _dio.post(url, data: formData, options: Options(headers: _dio.options.headers));

        logger.i("$name RESPONSE: ${response.data}"); // Log the response data
        return response;
      } on DioException catch (exception) {
        logger.e("$name ERROR: $exception"); // Log error
        return exception.response;
      }
    } else {
      logger.w("No internet connection!!");
      Get.to(() => const NoInterNetScreen());
    }
    return null;
  }
}
