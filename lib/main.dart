import 'package:discipline/bloc/user_bloc/user_bloc.dart';
import 'package:discipline/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:discipline/presintation/screens/auth/auth_login_screen.dart';
import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/secure_storage/secure_storage.dart';
import 'package:discipline/servises/dio/auth_service.dart';
import 'package:discipline/servises/dio/dio_users.dart';
import 'package:discipline/servises/dio/dio_schedule.dart';
import 'package:discipline/servises/go_route/go_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc/auth_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(AuthService(), TokenStorage(),),
          child: const AuthLoginScreen(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: MainStyle.backgrountColor,
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.display,
          headlineMedium: AppTextStyles.heading,
          bodyMedium: AppTextStyles.body,
          labelSmall: AppTextStyles.label,
        ),
      ),
    );
  }
}
