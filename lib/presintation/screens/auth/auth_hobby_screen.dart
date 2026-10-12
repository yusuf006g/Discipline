import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';
import '../../style/widgets_style.dart';

class AuthHobbyScreen extends StatefulWidget {
  const AuthHobbyScreen({super.key});

  @override
  State<AuthHobbyScreen> createState() => _AuthHobbyScreenState();
}

class _AuthHobbyScreenState extends State<AuthHobbyScreen> {
  final Set<String> selectedHobbies = {};

  final List<String> hobbies = [
    'Спорт',
    'Музыка',
    'Чтение',
    'Игры',
    'Программирование',
    'Рисование',
    'Путешествия',
    'Фильмы',
    'Фотография',
    'Изучение языков',
    'Наука',
    'Бизнес',
  ];

  void toggleHobby(String hobby) {
    setState(() {
      if (selectedHobbies.contains(hobby)) {
        selectedHobbies.remove(hobby);
      } else {
        selectedHobbies.add(hobby);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,

      appBar: AppBar(
        backgroundColor: MainStyle.backgrountColor,
        leading: IconButton(
          onPressed: () {
            context.go('/registrate');
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              const Text(
                'Расскажите о себе',
                style: AppTextStyles.display,
              ),

              const SizedBox(height: 10),

              const Text(
                'Выберите свои хобби',
                style: AppTextStyles.heading
              ),

              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: hobbies.map((hobby) {
                      final selected =
                      selectedHobbies.contains(hobby);

                      return GestureDetector(
                        onTap: () => toggleHobby(hobby),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? MainStyle.actionColor
                                : MainStyle.offColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? MainStyle.actionColor
                                  : MainStyle.offColor,
                            ),
                          ),
                          child: Text(
                            hobby,
                            style: TextStyle(
                              color: selected
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: WidgetsStyle.primaryButtonStyle,
                  onPressed: selectedHobbies.isEmpty
                      ? null
                      : () {
                    context.go('/home');
                  },
                  child: Text(
                    'Продолжить',
                    style: AppTextStyles.ButtonTextStyle,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}