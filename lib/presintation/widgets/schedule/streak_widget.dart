import 'package:flutter/material.dart';
import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreakItem(
          title: 'Прогресс дисцеплины',
          streak: 'серия 18 дней',
          progress: 0.92,
        ),

        const SizedBox(height: 26),

        StreakItem(
          title: 'Глубокая работа',
          streak: 'серия 6 дней',
          progress: 0.80,
        ),

        const SizedBox(height: 26),

        StreakItem(
          title: 'Творческое мышление',
          streak: 'серия 3 дня',
          progress: 0.67,
        ),
      ],
    );
  }
}

class StreakItem extends StatelessWidget {
  final String title;
  final String streak;
  final double progress;

  const StreakItem({
    super.key,
    required this.title,
    required this.streak,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.heading,
            ),

            Text(
              streak,
              style: AppTextStyles.label,
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          height: 14,
          decoration: BoxDecoration(
            color: const Color(0xFF202522),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: MainStyle.actionColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}