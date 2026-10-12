import 'package:flutter/material.dart';

import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';

class LevelsWidget extends StatelessWidget {
  const LevelsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        LevelItem(
          title: 'Новичок',
          xp: '0',
          state: LevelState.completed,
        ),
        LevelItem(
          title: 'Оператор',
          xp: '1 тыс.',
          state: LevelState.completed,
        ),
        LevelItem(
          title: 'Элита',
          xp: '3 тыс.',
          state: LevelState.current,
          number: '3',
        ),
        LevelItem(
          title: 'Мастер',
          xp: '7 тыс.',
          state: LevelState.locked,
          number: '4',
        ),
        LevelItem(
          title: 'Легенда',
          xp: '15 тыс.',
          state: LevelState.locked,
          crown: true,
        ),
      ],
    );
  }
}

enum LevelState {
  completed,
  current,
  locked,
}

class LevelItem extends StatelessWidget {
  final String title;
  final String xp;
  final LevelState state;
  final String? number;
  final bool crown;

  const LevelItem({
    super.key,
    required this.title,
    required this.xp,
    required this.state,
    this.number,
    this.crown = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool completed = state == LevelState.completed;
    final bool current = state == LevelState.current;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed
                ? MainStyle.actionColor
                : Colors.transparent,
            border: Border.all(
              color: completed || current
                  ? MainStyle.actionColor
                  : const Color(0xFF29312C),
              width: 2,
            ),
          ),
          child: Center(
            child: completed
                ? const Icon(
              Icons.check,
              color: Colors.black,
              size: 38,
            )
                : crown
                ? Icon(
              Icons.workspace_premium_outlined,
              color: const Color(0xFF9A9D98),
              size: 40,
            )
                : Text(
              number ?? '',
              style: TextStyle(
                color: current
                    ? MainStyle.actionColor
                    : const Color(0xFF9A9D98),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          title,
          style: AppTextStyles.body,
        ),

        const SizedBox(height: 4),

        Text(
          xp,
          style: AppTextStyles.label,
        ),
      ],
    );
  }
}