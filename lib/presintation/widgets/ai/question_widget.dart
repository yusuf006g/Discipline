import 'package:discipline/presintation/style/containet_style.dart';
import 'package:discipline/presintation/style/widgets_style.dart';
import 'package:flutter/material.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:go_router/go_router.dart';

import '../../style/app_text_styles.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({super.key});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // QUESTION
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: ContainerStyle.actionContainerStyle,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.psychology_outlined,
                  color: MainStyle.actionColor,
                  size: 48,
                ),

                const SizedBox(width: 28),

                Expanded(
                  child: const Text(
                      'Какая фраза лучше всего передаёт главное противоречие продукта?',
                      style: AppTextStyles.body
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // ANSWER A
          AnswerItem(
            letter: 'A',
            text: 'Больше функций создают больше ценности.',
            selected: selectedAnswer == 'A',
            onTap: () {
              setState(() {
                selectedAnswer = 'A';
              });
            },
          ),

          const SizedBox(height: 18),

          // ANSWER B
          AnswerItem(
            letter: 'B',
            text: 'Амбиции без ежедневной системы\n'
                'превращаются в тревогу.',
            selected: selectedAnswer == 'B',
            onTap: () {
              setState(() {
                selectedAnswer = 'B';
              });
            },
          ),

          const SizedBox(height: 18),

          // ANSWER C
          AnswerItem(
            letter: 'C',
            text: 'Клиентам прежде всего нужны более быстрые\n'
                'процессы.',
            selected: selectedAnswer == 'C',
            onTap: () {
              setState(() {
                selectedAnswer = 'C';
              });
            },
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: ContainerStyle.primaryContainerStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: MainStyle.actionColor,
                      size: 20,
                    ),
                    const Text(
                        ' Проверка уверенности ИИ',
                        style: AppTextStyles.body
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                const Text('Ответ сопоставляется с контекстом работы, а не с формальной отметкой о завершении.',style: AppTextStyles.label)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnswerItem extends StatelessWidget {
  final String letter;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const AnswerItem({
    super.key,
    required this.letter,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: selected
            ? ContainerStyle.actionContainerStyle
            : ContainerStyle.primaryContainerStyle,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? MainStyle.actionColor
                        : const Color(0xFF29312C),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Text(
                text,
                style: AppTextStyles.body
              ),
            ),
          ],
        ),
      ),
    );
  }
}