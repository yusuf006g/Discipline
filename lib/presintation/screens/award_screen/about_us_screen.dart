import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../style/main_style.dart';
import '../../widgets/main/app_bar_widget.dart';
import '../../widgets/main/drawer_widget.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: AppBarWidget(),
      drawer: DrawerWidget(part: 5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'О нас',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Узнай больше о Discipline',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),

              // Главный блок
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF151A15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: MainStyle.prymaryColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: MainStyle.prymaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.track_changes_rounded,
                        color: MainStyle.prymaryColor,
                        size: 46,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'DISCIPLINE',
                      style: TextStyle(
                        color: MainStyle.prymaryColor,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Маленькие шаги каждый день — '
                          'большие изменения в будущем.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Discipline — приложение для тех, кто хочет '
                          'лучше управлять своим временем, развивать навыки '
                          'и последовательно двигаться к своим целям.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const _SectionTitle(title: 'Наша миссия'),
              const SizedBox(height: 12),
              const _InfoCard(
                icon: Icons.flag_rounded,
                title: 'Помогать достигать целей',
                description:
                'Разбивай большие задачи на небольшие шаги, '
                    'планируй действия и следи за своим прогрессом.',
              ),
              const SizedBox(height: 12),
              const _InfoCard(
                icon: Icons.psychology_rounded,
                title: 'Развивать мышление',
                description:
                'Изучай новые материалы, тренируй навыки '
                    'и используй инструменты саморазвития.',
              ),
              const SizedBox(height: 12),
              const _InfoCard(
                icon: Icons.bolt_rounded,
                title: 'Формировать привычки',
                description:
                'Создавай полезные привычки, сохраняй фокус '
                    'и старайся становиться лучше каждый день.',
              ),

              const SizedBox(height: 28),

              const _SectionTitle(title: 'Что есть в приложении'),
              const SizedBox(height: 12),
              const _FeatureRow(
                icon: Icons.calendar_month_rounded,
                title: 'Планирование',
                description: 'Расписание, задачи и цели.',
              ),
              const _FeatureRow(
                icon: Icons.smart_toy_rounded,
                title: 'Искусственный интеллект',
                description: 'ИИ-помощник для обучения и работы.',
              ),
              const _FeatureRow(
                icon: Icons.menu_book_rounded,
                title: 'Обучение',
                description: 'Книги, уроки и полезные материалы.',
              ),
              const _FeatureRow(
                icon: Icons.query_stats_rounded,
                title: 'Статистика',
                description: 'Отслеживание личного развития.',
              ),
              const _FeatureRow(
                icon: Icons.emoji_events_rounded,
                title: 'Награды',
                description: 'Мотивация за выполнение задач.',
              ),

              const SizedBox(height: 28),

              // Наш подход
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF151A15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: MainStyle.prymaryColor,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Наш подход',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Мы верим, что саморазвитие начинается '
                          'не с идеального плана, а с первого действия. '
                          'Главное — двигаться вперёд в собственном темпе '
                          'и не останавливаться после неудач.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Кнопка возврата
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text(
                    'На главную',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainStyle.prymaryColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'DISCIPLINE • Развивайся каждый день',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: MainStyle.prymaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: MainStyle.prymaryColor,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.5,
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

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Icon(
            icon,
            color: MainStyle.prymaryColor,
            size: 25,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
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