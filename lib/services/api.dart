import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  final Dio api = Dio();
  String? accessToken;

  final _storage = const FlutterSecureStorage();

  Api() {
    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      if (!options.path.contains('http')) {
        options.path = 'http://localhost/flame-api/api' + options.path;
      }

      options.headers['Authorization'] = 'Bearer $accessToken';
      return handler.next(options);
    }, onError: (DioError error, hanlder) async {
      if (error.response?.statusCode == 401 &&
          error.response?.data['message'] == 'Invalid JWT') {
        if (await _storage.containsKey(key: 'refreshToken')) {
          await refreshToken();
          return hanlder.resolve(await _retry(error.requestOptions));
        }
      }

      return hanlder.next(error);
    }));
  }

  Future<void> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');

    final response =
        await api.post('/auth/refresh', data: {'refreshToken': refreshToken});

    if (response.statusCode == 201) {
      accessToken = response.data;
    } else {
      accessToken = null;
      _storage.deleteAll();
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =
        Options(method: requestOptions.method, headers: requestOptions.headers);

    return api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
