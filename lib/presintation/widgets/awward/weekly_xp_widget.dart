import 'package:flutter/material.dart';
import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';

class WeeklyXpWidget extends StatelessWidget {
  const WeeklyXpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'НА ЭТОЙ НЕДЕЛЕ',
              style: AppTextStyles.label.copyWith(
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '+620 XP',
              style: TextStyle(
                color: MainStyle.actionColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        WeeklyXpItem(
          icon: Icons.verified_user_outlined,
          title: 'Проверенные задачи',
          xp: '+360',
          color: MainStyle.actionColor,
        ),

        const SizedBox(height: 18),

        WeeklyXpItem(
          icon: Icons.center_focus_strong,
          title: 'Глубокий фокус',
          xp: '+180',
          color: MainStyle.actionColor,
        ),

        const SizedBox(height: 18),

        WeeklyXpItem(
          icon: Icons.local_fire_department_outlined,
          title: 'Серия из 12 дней',
          xp: '+120',
          color: MainStyle.actionColor,
        ),

        const SizedBox(height: 18),

        WeeklyXpItem(
          icon: Icons.remove,
          title: 'Штраф за опоздание',
          xp: '−40',
          color: MainStyle.dangerColor,
        ),
      ],
    );
  }
}

class WeeklyXpItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String xp;
  final Color color;

  const WeeklyXpItem({
    super.key,
    required this.icon,
    required this.title,
    required this.xp,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF080D0A),
        border: Border.all(
          color: const Color(0xFF29312C),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),

          const SizedBox(width: 28),

          Expanded(
            child: Text(
              title,
              style: AppTextStyles.middleText,
            ),
          ),

          Text(
            xp,
            style: AppTextStyles.middleGreenText
          ),
        ],
      ),
    );
  }
}