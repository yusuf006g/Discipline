import 'package:dio/dio.dart';

import '../../models/user_models/LoginModel.dart';
import '../../models/user_models/login_response_model.dart';
import '../../models/user_models/refresh_model.dart';
import '../../models/user_models/register_model.dart';
import '../../models/user_models/register_response_model.dart';
import '../../models/user_models/user_model.dart';
import 'dio_service.dart';

class AuthService {
  Future<LoginResponseModel> login(LoginModel model) async {
    try {
      final response = await DioService.dio.post(
        'auth/login/',
        data: model.toJson(),
      );

      print('LOGIN HTTP STATUS: ${response.statusCode}');
      print('LOGIN HTTP DATA: ${response.data}');
      print('LOGIN URL: ${response.requestOptions.uri}');

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print('========== LOGIN DIO ERROR ==========');
      print('TYPE: ${e.type}');
      print('MESSAGE: ${e.message}');
      print('ERROR: ${e.error}');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');
      print('REQUEST DATA: ${_safeRequestData(e.requestOptions.data)}');
      print('=====================================');

      rethrow;
    } catch (e, stackTrace) {
      print('LOGIN UNKNOWN ERROR: $e');
      print(stackTrace);

      rethrow;
    }
  }

  Future<RegisterResponseModel> register(RegisterModel model) async {
    try {
      final response = await DioService.dio.post(
        'auth/register/',
        data: model.toJson(),
      );

      print('REGISTER HTTP STATUS: ${response.statusCode}');
      print('REGISTER HTTP DATA: ${response.data}');

      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print('========== REGISTER DIO ERROR ==========');
      print('TYPE: ${e.type}');
      print('MESSAGE: ${e.message}');
      print('ERROR: ${e.error}');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');
      print('REQUEST DATA: ${_safeRequestData(e.requestOptions.data)}');
      print('========================================');

      rethrow;
    } catch (e, stackTrace) {
      print('REGISTER UNKNOWN ERROR: $e');
      print(stackTrace);

      rethrow;
    }
  }

  Future<UserModel> getMe(String accessToken) async {
    try {
      final response = await DioService.dio.get(
        'auth/me/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print('GET ME ERROR: ${e.message}');
      print('GET ME STATUS: ${e.response?.statusCode}');
      print('GET ME DATA: ${e.response?.data}');

      rethrow;
    }
  }

  Future<String> refresh(RefreshModel model) async {
    final response = await DioService.dio.post(
      'auth/refresh/',
      data: model.toJson(),
    );

    return response.data['access'];
  }

  dynamic _safeRequestData(dynamic data) {
    if (data is Map) {
      final copy = Map<String, dynamic>.from(data);

      copy.remove('password');
      copy.remove('password2');

      return copy;
    }

    return data;
  }
}