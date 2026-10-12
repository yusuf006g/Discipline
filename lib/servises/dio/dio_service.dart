import 'dart:io';

import 'package:dio/dio.dart';

class DioService {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/';
    }

    if (Platform.isMacOS || Platform.isIOS) {
      return 'http://127.0.0.1:8000/api/';
    }

    return 'http://127.0.0.1:8000/api/';
  }

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
}