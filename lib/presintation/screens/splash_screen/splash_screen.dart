import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:discipline/presintation/style/main_style.dart';

import '../../../secure_storage/secure_storage.dart';
import '../../../servises/dio/auth_service.dart';
import '../../../models/user_models/refresh_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TokenStorage tokenStorage = TokenStorage();
  final AuthService authService = AuthService();

  bool _checking = true;

  @override
  void initState() {
    super.initState();

    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      _checking = true;
    });

    final accessToken = await tokenStorage.getAccessToken();

    // Токена нет
    if (accessToken == null || accessToken.isEmpty) {
      if (!mounted) return;

      context.go('/buttom_nav_bar');
      return;
    }

    // Access token истёк → берём refresh
    final refreshToken = await tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      if (!mounted) return;

      context.go('/auth');
      return;
    }

    // Получаем новый access token
    final newAccessToken = await authService.refresh(
      RefreshModel(
        refresh: refreshToken,
      ),
    );

    // Сохраняем новый access token
    await tokenStorage.saveTokens(
      access: newAccessToken,
      refresh: refreshToken,
    );

    // Проверяем новый access token
    await authService.getMe(newAccessToken);

    if (!mounted) return;

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}