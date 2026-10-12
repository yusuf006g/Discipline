import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../bloc/auth_bloc/auth_event.dart';
import '../../../bloc/auth_bloc/auth_state.dart';
import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';
import '../../style/widgets_style.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          print('LOGIN SUCCESS');
          print('ACCESS: ${state.access}');
          print('REFRESH: ${state.refresh}');

          context.go('/home');
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MainStyle.backgrountColor,
          leading: IconButton(
            onPressed: () {
              context.go('/auth');
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: MainStyle.backgrountColor,
        body: Stack(
          children: [
            Positioned(
              top: 150,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/mini_logo.png',
                    height: 100,
                  ),

                  const Text(
                    'С возвращением в мир успеха!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.WhiteHeading,
                  ),

                  const SizedBox(height: 40),

                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Имя',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF141A15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF141A15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 100),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const SizedBox(
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: WidgetsStyle.primaryButtonStyle,
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              LoginEvent(
                                username: usernameController.text.trim(),
                                password: passwordController.text,
                              ),
                            );
                          },
                          child: Text(
                            'Войти',
                            style: AppTextStyles.ButtonTextStyle,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}