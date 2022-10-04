import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

final _log = Logger('endpoint');

abstract class Endpoint {
  Endpoint(this.method, String url, [this.validStatusCode]) : _url = url;

  static BaseOptions options = BaseOptions(
    connectTimeout: 30000,
    contentType: 'application/json; charset=utf-8',
  );

  final Dio dio = Dio(options);
  final String method;
  final int? validStatusCode;

  final String _url;

  String get url => domainUrl + _url;

  String get domainUrl;

  FutureOr<T?> hit<T>(
    String token, {
    Map<String, dynamic>? queryParameters,
    FormData? data,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic> responseBody)? map,
    Function(String errorMessage)? onError,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool isMultipart = false,
  }) async {
    _log.info('➡️ $method $url');

    T? result;

    if (!await _checkConnection()) {
      _log.warning('Unable to connect to the internet');
      _log.warning(
          '⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️');
      onError?.call('Please check your connection and try again!');
      return null;
    }

    final dataMap = {}..addEntries(data?.fields ?? []);
    final filesMap = {}..addEntries(data?.files ?? []);

    _log.info('TOKEN: $token');
    _log.info('HEADERS: $headers');
    _log.info('QUERY PARAMETERS: $queryParameters');
    _log.info('DATA: $dataMap');
    _log.info('Files: ${filesMap.keys}');

    try {
      final Response response = await dio.request(
        url,
        data: isMultipart ? data : dataMap,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          method: method,
          receiveTimeout: 30000,
          followRedirects: false,
          responseType: ResponseType.json,
          headers: {
            "Authorization": 'Bearer $token',
            "content-type": 'application/json; charset=utf-8'
          }..addAll(headers ?? {}),
          validateStatus: (status) {
            return (status ?? 999) == (validStatusCode ?? 200);
          },
        ),
      );
      _log.info('SUCCESS: $method $url');
      try {
        result = map?.call(response.data);
        _log.info(
            '✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️');
      } catch (e) {
        _log.warning('EXCEPTION: $e');
        // _log.info('RESPONSE DATA: ${response.data}\nEXCEPTION: $e');
        throw MappingException();
      }
    } on DioError catch (e) {
      _logError(e);
      final errorMessage =
          e.response?.data['message'] ?? 'An unknown error occoured';
      onError?.call(errorMessage);
      _log.warning('❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌');
    } on MappingException {
      _log.warning('An error occoured while mapping response to $T');
      onError?.call('An error occoured while mapping response to $T');
      _log.warning('❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌');
    } catch (e) {
      _log.warning(e);
      onError?.call(e.toString());
      _log.warning('❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌');
    }
    return result;
  }

  void _logError(DioError e) {
    if (e.response != null) {
      _log.warning('⚠️ ${e.requestOptions.method} ${e.requestOptions.path}');
      _log.info(
          'REQUEST QUERY PARAMETERS: ${e.requestOptions.queryParameters}');
      _log.warning('REQUEST DATA: ${e.requestOptions.data}');
      _log.warning('REQUEST HEADERS: ${e.requestOptions.headers}');
      _log.warning('RESPONSE STATUS: ${e.response?.statusCode}');
      _log.warning('RESOPNSE DATA: ${e.response?.data}');
      _log.warning('RESPONSE HEADERS: ${e.response?.headers}');
    } else {
      _log.severe('Error sending request!');
      _log.severe(e.message, e, e.stackTrace);
    }
  }

  Future<bool> _checkConnection() async {
    final Dio dio = Dio();
    const endpoint =
        'https://sandbox.api.service.nhs.uk/hello-world/hello/world';
    try {
      Response response = await dio.get(endpoint);
      return response.statusCode == 200;
    } on Exception {
      return false;
    }
  }
}

class MappingException implements Exception {}
