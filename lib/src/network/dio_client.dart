import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../helper/constants/api_urls.dart';
import 'interceptors.dart';

class DioClient {
  final Dio _dio;

  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiUrls.baseURL,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      ) {
    // =====================================================
    // ✅ UNPINNED MODE (ByPass secure network Config)
    // =====================================================
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // final token = await GetIt.I<TokenService>().getToken();
          // if (token != null && token.isNotEmpty) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {

          } else {
            return handler.next(e);
          }
        },
      ),
    );

    _dio.interceptors.add(LoggerInterceptor());
  }

  Future<Response> post(
    String pathOrFullUrl, {
    required Map<String, dynamic> data,
    bool isForm = false,
    Options? options,
    bool isFullUrl = false,
  }) async {
    final requestOptions = options ?? Options();

    if (isForm) {
      requestOptions.contentType = Headers.formUrlEncodedContentType;
    }

    final url = isFullUrl
        ? pathOrFullUrl
        : '${_dio.options.baseUrl}$pathOrFullUrl';

    return await _dio.post(url, data: data, options: requestOptions);
  }
}
