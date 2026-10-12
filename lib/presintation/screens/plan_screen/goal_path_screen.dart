
import 'package:flutter/material.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class GoalPathScreen extends StatefulWidget {
  const GoalPathScreen({super.key});

  @override
  State<GoalPathScreen> createState() => _GoalPathScreenState();
}

class _GoalPathScreenState extends State<GoalPathScreen> {
  final String _goal = 'Запустить свой первый продукт';

  final List<_GoalStage> _stages = [
    _GoalStage(
      number: 1,
      title: 'Исследование',
      description: 'Разберись в проблеме и своей аудитории.',
      period: 'Недели 1–2',
      icon: Icons.search,
      tasks: [
        _GoalTask('Определить проблему'),
        _GoalTask('Изучить конкурентов'),
        _GoalTask('Провести 10 интервью'),
      ],
    ),
    _GoalStage(
      number: 2,
      title: 'Планирование',
      description: 'Определи решение и подготовь план.',
      period: 'Недели 3–4',
      icon: Icons.assignment_outlined,
      tasks: [
        _GoalTask('Сформулировать предложение'),
        _GoalTask('Определить основные функции'),
        _GoalTask('Составить план разработки'),
      ],
    ),
    _GoalStage(
      number: 3,
      title: 'Создание продукта',
      description: 'Создай первую работающую версию.',
      period: 'Недели 5–8',
      icon: Icons.rocket_launch_outlined,
      tasks: [
        _GoalTask('Создать прототип'),
        _GoalTask('Проверить основные функции'),
        _GoalTask('Получить обратную связь'),
      ],
    ),
    _GoalStage(
      number: 4,
      title: 'Запуск и анализ',
      description: 'Запусти продукт и оцени результат.',
      period: 'Недели 9–12',
      icon: Icons.trending_up,
      tasks: [
        _GoalTask('Подготовить запуск'),
        _GoalTask('Найти первых пользователей'),
        _GoalTask('Проанализировать результаты'),
      ],
    ),
  ];

  int get _totalTasks =>
      _stages.fold(0, (sum, stage) => sum + stage.tasks.length);

  int get _completedTasks => _stages.fold(
    0,
        (sum, stage) =>
    sum + stage.tasks.where((task) => task.isCompleted).length,
  );

  double get _progress =>
      _totalTasks == 0 ? 0 : _completedTasks / _totalTasks;

  int get _completedStages =>
      _stages.where((stage) => stage.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 2),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'GOAL ROADMAP',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 14),

            const Text(
              'Путь к вашей цели.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Большой результат начинается с маленьких '
                  'и последовательных действий.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 24),

            // Главная цель
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF151A15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: MainStyle.actionColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        color: MainStyle.actionColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'ВАША ЦЕЛЬ',
                        style: AppTextStyles.miniGreenText,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    _goal,
                    style: AppTextStyles.WhiteHeading,
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Общий прогресс',
                          style: AppTextStyles.body,
                        ),
                      ),
                      Text(
                        '${(_progress * 100).round()}%',
                        style: AppTextStyles.middleGreenText,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8,
                      backgroundColor: Colors.white12,
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(
                        MainStyle.actionColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: MainStyle.actionColor,
                        size: 18,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          '$_completedTasks из $_totalTasks задач',
                          style: AppTextStyles.hintText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '$_completedStages из ${_stages.length} этапов завершено',
                    style: AppTextStyles.hintText,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'ЭТАПЫ ПУТИ',
              style: AppTextStyles.middleGreenText,
            ),

            const SizedBox(height: 8),

            Text(
              'Отмечай выполненные задачи, чтобы отслеживать '
                  'своё продвижение.',
              style: AppTextStyles.hintText.copyWith(
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // Дорожная карта-змейка
            ...List.generate(_stages.length, (index) {
              return Column(
                children: [
                  _buildRoadmapStage(
                    _stages[index],
                    index,
                  ),

                  if (index < _stages.length - 1)
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: CustomPaint(
                        painter: _SnakeRoadPainter(
                          fromLeft: index.isEven,
                        ),
                      ),
                    ),
                ],
              );
            }),

            const SizedBox(height: 22),

            // Мотивационный блок
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF151A15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white12,
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: MainStyle.actionColor,
                    size: 26,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Главное — последовательность.',
                          style: AppTextStyles.WhiteHeading,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Необязательно делать всё сразу. '
                              'Выполняй задачи по одной и продолжай '
                              'двигаться вперёд.',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Карточка этапа, расположенная попеременно слева и справа
  Widget _buildRoadmapStage(
      _GoalStage stage,
      int index,
      ) {
    final completed =
        stage.tasks.where((task) => task.isCompleted).length;

    final allDone = stage.isCompleted;

    return Align(
      alignment: index.isEven
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.78,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF151A15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: allDone
                  ? MainStyle.successColor
                  : Colors.white12,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              initiallyExpanded: stage.number == 1,

              tilePadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

              childrenPadding: const EdgeInsets.fromLTRB(
                12,
                0,
                12,
                14,
              ),

              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: allDone
                      ? MainStyle.successColor.withAlpha(25)
                      : MainStyle.actionColor.withAlpha(25),
                  border: Border.all(
                    color: allDone
                        ? MainStyle.successColor
                        : MainStyle.actionColor,
                  ),
                ),
                child: Icon(
                  allDone ? Icons.check_circle : stage.icon,
                  color: allDone
                      ? MainStyle.successColor
                      : MainStyle.actionColor,
                  size: 22,
                ),
              ),

              title: Text(
                stage.title,
                style: AppTextStyles.WhiteHeading.copyWith(
                  fontSize: 16,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '${stage.period}\n'
                      '$completed/${stage.tasks.length} задач',
                  style: AppTextStyles.hintText.copyWith(
                    height: 1.5,
                    fontSize: 11,
                  ),
                ),
              ),

              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    stage.description,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: stage.tasks.isEmpty
                        ? 0
                        : completed / stage.tasks.length,
                    minHeight: 5,
                    backgroundColor: Colors.white12,
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(
                      MainStyle.actionColor,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                ...stage.tasks.map(
                      (task) => CheckboxListTile(
                    value: task.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        task.isCompleted = value ?? false;
                      });
                    },
                    activeColor: MainStyle.actionColor,
                    checkColor: Colors.black,
                    controlAffinity:
                    ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      task.title,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 13,
                        color: task.isCompleted
                            ? Colors.white54
                            : MainStyle.TextColor,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// ИЗВИЛИСТАЯ ДОРОЖКА МЕЖДУ ЭТАПАМИ
// =====================================================

class _SnakeRoadPainter extends CustomPainter {
  final bool fromLeft;

  const _SnakeRoadPainter({
    required this.fromLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Центры карточек с учётом их ширины 78%.
    final startX = fromLeft
        ? size.width * 0.39
        : size.width * 0.61;

    final endX = fromLeft
        ? size.width * 0.61
        : size.width * 0.39;

    final path = Path()
      ..moveTo(startX, 0)
      ..cubicTo(
        startX,
        size.height * 0.35,
        endX,
        size.height * 0.65,
        endX,
        size.height,
      );

    // Широкая тёмная основа дорожки
    final roadPaint = Paint()
      ..color = Colors.white.withAlpha(25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    // Лаймовая линия по центру
    final linePaint = Paint()
      ..color = MainStyle.actionColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, roadPaint);
    canvas.drawPath(path, linePaint);

    // Точки начала и завершения дорожки
    final markerPaint = Paint()
      ..color = MainStyle.actionColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(startX, 2),
      4,
      markerPaint,
    );

    canvas.drawCircle(
      Offset(endX, size.height - 2),
      4,
      markerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SnakeRoadPainter oldDelegate) {
    return oldDelegate.fromLeft != fromLeft;
  }
}

// =====================================================
// МОДЕЛИ ЭТАПОВ И ЗАДАЧ
// =====================================================

class _GoalStage {
  final int number;
  final String title;
  final String description;
  final String period;
  final IconData icon;
  final List<_GoalTask> tasks;

  _GoalStage({
    required this.number,
    required this.title,
    required this.description,
    required this.period,
    required this.icon,
    required this.tasks,
  });

  bool get isCompleted =>
      tasks.isNotEmpty && tasks.every((task) => task.isCompleted);
}

class _GoalTask {
  final String title;
  bool isCompleted;

  _GoalTask(
      this.title, {
        this.isCompleted = false,
      });
}