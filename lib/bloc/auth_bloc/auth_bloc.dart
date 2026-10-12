import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_models/LoginModel.dart';
import '../../models/user_models/register_model.dart';

import '../../secure_storage/secure_storage.dart';
import '../../servises/dio/auth_service.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final TokenStorage tokenStorage;

  AuthBloc(
      this.authService,
      this.tokenStorage,
      ) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
  }

  Future<void> _login(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final result = await authService.login(
        LoginModel(
          username: event.username,
          password: event.password,
        ),
      );

      print('LOGIN HTTP SUCCESS');

      // Сохраняем токены
      await tokenStorage.saveTokens(
        access: result.access,
        refresh: result.refresh,
      );

      print('TOKENS SAVE DONE');

      // Проверяем, что токены реально сохранились
      final savedAccess = await tokenStorage.getAccessToken();
      final savedRefresh = await tokenStorage.getRefreshToken();

      print(
        'ACCESS SAVED: '
            '${savedAccess != null && savedAccess.isNotEmpty}',
      );

      print(
        'REFRESH SAVED: '
            '${savedRefresh != null && savedRefresh.isNotEmpty}',
      );

      if (savedAccess == null || savedAccess.isEmpty) {
        throw Exception('Access token не сохранился');
      }

      if (savedRefresh == null || savedRefresh.isEmpty) {
        throw Exception('Refresh token не сохранился');
      }

      print('LOGIN SUCCESS');

      emit(
        LoginSuccess(
          access: result.access,
          refresh: result.refresh,
        ),
      );
    } on DioException catch (e) {
      print('========== LOGIN DIO ERROR ==========');
      print('TYPE: ${e.type}');
      print('MESSAGE: ${e.message}');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');
      print('=====================================');

      emit(
        AuthError(
          'Ошибка подключения к серверу',
        ),
      );
    } catch (e, stackTrace) {
      print('========== LOGIN ERROR ==========');
      print('ERROR: $e');
      print(stackTrace);
      print('=================================');

      emit(
        AuthError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _register(
      RegisterEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final result = await authService.register(
        RegisterModel(
          username: event.username,
          email: event.email,
          password: event.password,
          password2: event.password2,
        ),
      );

      print('REGISTER SUCCESS');
      print('USERNAME: ${result.username}');
      print('EMAIL: ${result.email}');

      emit(
        RegisterSuccess(
          username: result.username,
          email: result.email,
        ),
      );
    } on DioException catch (e) {
      print('========== REGISTER DIO ERROR ==========');
      print('TYPE: ${e.type}');
      print('MESSAGE: ${e.message}');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');
      print('========================================');

      emit(
        AuthError(
          'Ошибка регистрации',
        ),
      );
    } catch (e, stackTrace) {
      print('========== REGISTER ERROR ==========');
      print('ERROR: $e');
      print(stackTrace);
      print('====================================');

      emit(
        AuthError(
          e.toString(),
        ),
      );
    }
  }
}