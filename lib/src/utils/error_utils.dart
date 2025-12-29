import 'dart:io';

import 'package:dio/dio.dart';

class ErrorUtils {
  static String? read(Object err) {
    if (err is DioException) {
      return readDioError(err);
    }

    return err.toString();
  }

  static String? readDioError(DioException err) {
    if (err.type == DioExceptionType.unknown) {
      return readDynamicError(err.error);
    }

    return err.message;
  }

  static String readDynamicError(dynamic err) {
    if (err is SocketException) {
      return err.message;
    }

    return err.toString();
  }
}
