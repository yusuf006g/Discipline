import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../bloc/auth_bloc/auth_event.dart';
import '../../../bloc/auth_bloc/auth_state.dart';
import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';
import '../../style/widgets_style.dart';

class AuthRegistrateScreen extends StatefulWidget {
  const AuthRegistrateScreen({super.key});

  @override
  State<AuthRegistrateScreen> createState() =>
      _AuthRegistrateScreenState();
}

class _AuthRegistrateScreenState extends State<AuthRegistrateScreen> {
  String? gender;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.go('/hobby');
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
        backgroundColor: MainStyle.backgrountColor,

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

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),

                Image.asset(
                  'assets/images/mini_logo.png',
                  height: 100,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Удачи с началом новой жизни!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.WhiteHeading,
                ),

                const SizedBox(height: 60),

                // EMAIL
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
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

                // USERNAME
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Имя пользователя',
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

                // GENDER
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF141A15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: RadioListTile<String>(
                          title: const Text(
                            'Мужской',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          value: 'male',
                          groupValue: gender,
                          activeColor: MainStyle.actionColor,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF141A15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: RadioListTile<String>(
                          title: const Text(
                            'Женский',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          value: 'female',
                          groupValue: gender,
                          activeColor: MainStyle.actionColor,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // PASSWORD
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

                const SizedBox(height: 20),

                // PASSWORD 2
                TextField(
                  controller: password2Controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Повторите пароль',
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

                const SizedBox(height: 40),

                // REGISTER
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator(
                        color: MainStyle.actionColor,
                      );
                    }

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: WidgetsStyle.primaryButtonStyle,
                        onPressed: () {
                          if (gender == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Выберите пол',
                                ),
                              ),
                            );
                            return;
                          }

                          if (passwordController.text !=
                              password2Controller.text) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Пароли не совпадают',
                                ),
                              ),
                            );
                            return;
                          }

                          context.read<AuthBloc>().add(
                            RegisterEvent(
                              username:
                              usernameController.text,
                              email:
                              emailController.text,
                              password:
                              passwordController.text,
                              password2:
                              password2Controller.text,
                            ),
                          );
                        },
                        child: Text(
                          'Регистрироваться',
                          style: AppTextStyles.ButtonTextStyle,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}