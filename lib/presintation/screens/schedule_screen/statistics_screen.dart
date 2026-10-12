
import 'package:flutter/material.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static const List<_Skill> _skills = [
    _Skill(
      title: 'Знания',
      description: 'Понимание изученных тем и усвоение информации.',
      score: 74,
      icon: Icons.school_outlined,
      color: MainStyle.actionColor,
    ),
    _Skill(
      title: 'Творчество',
      description: 'Создание новых идей и нестандартных решений.',
      score: 86,
      icon: Icons.lightbulb_outline,
      color: Color(0xFFB69CFF),
    ),
    _Skill(
      title: 'Логика',
      description: 'Анализ информации и последовательное мышление.',
      score: 79,
      icon: Icons.account_tree_outlined,
      color: Color(0xFF7DB9FF),
    ),
    _Skill(
      title: 'Концентрация',
      description: 'Способность удерживать внимание на задаче.',
      score: 68,
      icon: Icons.center_focus_strong,
      color: Color(0xFF6ABE77),
    ),
    _Skill(
      title: 'Дисциплина',
      description: 'Регулярность, последовательность и выполнение планов.',
      score: 82,
      icon: Icons.track_changes,
      color: MainStyle.actionColor,
    ),
    _Skill(
      title: 'Память',
      description: 'Запоминание и воспроизведение изученного.',
      score: 71,
      icon: Icons.psychology_outlined,
      color: Color(0xFFDFAE54),
    ),
    _Skill(
      title: 'Решение проблем',
      description: 'Поиск эффективных способов справляться с трудностями.',
      score: 76,
      icon: Icons.extension_outlined,
      color: Color(0xFFFF9B85),
    ),
    _Skill(
      title: 'Скорость обучения',
      description: 'Освоение новых навыков и применение знаний.',
      score: 88,
      icon: Icons.rocket_launch_outlined,
      color: Color(0xFF7DB9FF),
    ),
    _Skill(
      title: 'Критическое мышление',
      description: 'Проверка фактов, аргументов и собственных выводов.',
      score: 73,
      icon: Icons.manage_search,
      color: Color(0xFFB69CFF),
    ),
    _Skill(
      title: 'Коммуникация',
      description: 'Выражение мыслей, объяснение идей и взаимодействие.',
      score: 65,
      icon: Icons.forum_outlined,
      color: Color(0xFF6ABE77),
    ),
  ];

  int get _averageScore {
    final total = _skills.fold<int>(
      0,
          (sum, skill) => sum + skill.score,
    );

    return (total / _skills.length).round();
  }

  String _levelName(int score) {
    if (score >= 90) return 'Экспертный';
    if (score >= 80) return 'Продвинутый';
    if (score >= 60) return 'Уверенный';
    if (score >= 40) return 'Развивающийся';
    return 'Начальный';
  }

  @override
  Widget build(BuildContext context) {
    final strongest = List<_Skill>.from(_skills)
      ..sort((a, b) => b.score.compareTo(a.score));

    final weakest = strongest.last;

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 4),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          children: [
            const Text(
              'SKILL STATISTICS',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 14),

            const Text(
              'Уровень твоих способностей.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Изучай свои сильные стороны и развивай навыки '
                  'шаг за шагом.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 26),

            // Общий уровень
            _OverallSkillCard(
              score: _averageScore,
              levelName: _levelName(_averageScore),
              skillCount: _skills.length,
            ),

            const SizedBox(height: 28),

            const Text(
              'ПРОФИЛЬ СПОСОБНОСТЕЙ',
              style: AppTextStyles.middleGreenText,
            ),

            const SizedBox(height: 8),

            Text(
              'Каждый показатель отражает отдельный навык.',
              style: AppTextStyles.hintText,
            ),

            const SizedBox(height: 16),

            // Карточки навыков
            ..._skills.map(
                  (skill) => _SkillCard(
                skill: skill,
                levelName: _levelName(skill.score),
              ),
            ),

            const SizedBox(height: 18),

            // Сильная сторона
            _InsightCard(
              icon: Icons.workspace_premium_outlined,
              color: MainStyle.successColor,
              label: 'СИЛЬНАЯ СТОРОНА',
              title: strongest.first.title,
              description:
              'Этот показатель сейчас выше остальных '
                  'в демонстрационном профиле.',
              score: strongest.first.score,
            ),

            const SizedBox(height: 12),

            // Навык для развития
            _InsightCard(
              icon: Icons.trending_up,
              color: MainStyle.warningColor,
              label: 'ЗОНА РАЗВИТИЯ',
              title: weakest.title,
              description:
              'Попробуй уделить этому навыку больше внимания '
                  'во время занятий и выполнения задач.',
              score: weakest.score,
            ),

            const SizedBox(height: 24),

            // Шкала уровней
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF151A15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ШКАЛА УРОВНЕЙ',
                    style: AppTextStyles.middleGreenText,
                  ),

                  const SizedBox(height: 16),

                  _LevelLegend(
                    color: Colors.white38,
                    title: 'Начальный',
                    range: '0–39',
                  ),

                  _LevelLegend(
                    color: MainStyle.warningColor,
                    title: 'Развивающийся',
                    range: '40–59',
                  ),

                  _LevelLegend(
                    color: MainStyle.actionColor,
                    title: 'Уверенный',
                    range: '60–79',
                  ),

                  _LevelLegend(
                    color: MainStyle.successColor,
                    title: 'Продвинутый',
                    range: '80–89',
                  ),

                  _LevelLegend(
                    color: const Color(0xFFB69CFF),
                    title: 'Экспертный',
                    range: '90–100',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Способности развиваются через практику, '
                  'обучение и последовательную работу.',
              textAlign: TextAlign.center,
              style: AppTextStyles.hintText.copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// МОДЕЛЬ НАВЫКА
// =====================================================

class _Skill {
  final String title;
  final String description;
  final int score;
  final IconData icon;
  final Color color;

  const _Skill({
    required this.title,
    required this.description,
    required this.score,
    required this.icon,
    required this.color,
  });
}

// =====================================================
// КАРТОЧКА ОБЩЕГО УРОВНЯ
// =====================================================

class _OverallSkillCard extends StatelessWidget {
  final int score;
  final String levelName;
  final int skillCount;

  const _OverallSkillCard({
    required this.score,
    required this.levelName,
    required this.skillCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MainStyle.actionColor,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.psychology_outlined,
            size: 44,
            color: MainStyle.actionColor,
          ),

          const SizedBox(height: 14),

          const Text(
            'ОБЩИЙ УРОВЕНЬ РАЗВИТИЯ',
            textAlign: TextAlign.center,
            style: AppTextStyles.miniGreenText,
          ),

          const SizedBox(height: 14),

          Text(
            '$score',
            style: AppTextStyles.display.copyWith(
              fontSize: 54,
              color: MainStyle.actionColor,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'из 100 баллов',
            style: AppTextStyles.hintText,
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: MainStyle.actionColor.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              levelName.toUpperCase(),
              style: const TextStyle(
                color: MainStyle.actionColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(
                MainStyle.actionColor,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            '$skillCount показателей в профиле',
            style: AppTextStyles.hintText,
          ),
        ],
      ),
    );
  }
}

// =====================================================
// КАРТОЧКА ОТДЕЛЬНОГО НАВЫКА
// =====================================================

class _SkillCard extends StatelessWidget {
  final _Skill skill;
  final String levelName;

  const _SkillCard({
    required this.skill,
    required this.levelName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: skill.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  skill.icon,
                  color: skill.color,
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill.title,
                      style: AppTextStyles.WhiteHeading.copyWith(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      levelName,
                      style: TextStyle(
                        color: skill.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${skill.score}',
                style: AppTextStyles.titleText.copyWith(
                  color: skill.color,
                  fontSize: 25,
                ),
              ),

              Text(
                '/100',
                style: AppTextStyles.hintText.copyWith(
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: skill.score / 100,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(
                skill.color,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            skill.description,
            style: AppTextStyles.caption.copyWith(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// РЕКОМЕНДАЦИИ
// =====================================================

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String title;
  final String description;
  final int score;

  const _InsightCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.title,
    required this.description,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: color.withAlpha(100),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 27,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  title,
                  style: AppTextStyles.WhiteHeading.copyWith(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: AppTextStyles.hintText.copyWith(
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '$score / 100 баллов',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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

// =====================================================
// ЛЕГЕНДА УРОВНЕЙ
// =====================================================

class _LevelLegend extends StatelessWidget {
  final Color color;
  final String title;
  final String range;

  const _LevelLegend({
    required this.color,
    required this.title,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              title,
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
              ),
            ),
          ),

          Text(
            '$range баллов',
            style: AppTextStyles.hintText,
          ),
        ],
      ),
    );
  }
}