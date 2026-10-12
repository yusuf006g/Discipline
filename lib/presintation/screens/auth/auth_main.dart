import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/style/widgets_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthMain extends StatelessWidget {
  const AuthMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      body: Stack(
        children: [
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Image.asset('assets/images/mini_logo.png',height: 100,),
                const Text(
                  'Добропожаловать в сообшество победителей!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.WhiteHeading,
                ),
              ],
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 100,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: WidgetsStyle.primaryButtonStyle,
                    onPressed: () {
                      context.go('registrate');
                    },
                    child: Text(
                      'Регистрироваться',
                      style: AppTextStyles.ButtonTextStyle,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: WidgetsStyle.primaryButtonStyle,
                    onPressed: () {
                      context.go('login');
                    },
                    child: Text(
                      'Войти',
                      style: AppTextStyles.ButtonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}