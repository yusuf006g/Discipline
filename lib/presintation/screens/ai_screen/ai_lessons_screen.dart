
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class AiLessonsScreen extends StatefulWidget {
  const AiLessonsScreen({super.key});

  @override
  State<AiLessonsScreen> createState() => _AiLessonsScreenState();
}

class _AiLessonsScreenState extends State<AiLessonsScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  String _selectedCategory = 'Все';
  String _searchQuery = '';

  final List<String> _categories = const [
    'Все',
    'Обучение',
    'Практика',
    'Проверка',
    'Планирование',
  ];

  final List<_AiLesson> _lessons = [
    _AiLesson(
      title: 'Изучи новую тему',
      description:
      'Разберись в сложной теме вместе с AI-наставником. '
          'Получай объяснения, примеры и дополнительные вопросы.',
      category: 'Обучение',
      duration: '15–30 мин',
      icon: Icons.school_outlined,
      color: const Color(0xFFCCE956),
      prompt:
      'Помоги мне изучить новую тему. '
          'Сначала спроси, какую тему я хочу изучить, '
          'затем объясняй её поэтапно с примерами.',
    ),
    _AiLesson(
      title: 'Практическое задание',
      description:
      'Закрепи знания с помощью упражнений, '
          'реальных ситуаций и пошаговых заданий.',
      category: 'Практика',
      duration: '20 мин',
      icon: Icons.psychology_outlined,
      color: const Color(0xFF7DB9FF),
      prompt:
      'Подготовь для меня практическое занятие. '
          'Узнай мою тему и уровень знаний, затем предложи '
          'упражнения от простого к сложному.',
    ),
    _AiLesson(
      title: 'Проверь свои знания',
      description:
      'Ответь на вопросы, получи обратную связь '
          'и узнай, какие темы стоит повторить.',
      category: 'Проверка',
      duration: '10–15 мин',
      icon: Icons.quiz_outlined,
      color: const Color(0xFFDFAE54),
      prompt:
      'Проведи для меня проверку знаний. '
          'Сначала спроси тему и мой уровень, затем задавай '
          'вопросы по одному и проверяй каждый ответ.',
    ),
    _AiLesson(
      title: 'Персональный план обучения',
      description:
      'Определи цель, доступное время и составь '
          'пошаговую программу обучения.',
      category: 'Планирование',
      duration: '10 мин',
      icon: Icons.route_outlined,
      color: const Color(0xFFB69CFF),
      prompt:
      'Составь для меня персональный план обучения. '
          'Спроси, чему я хочу научиться, какой у меня уровень '
          'и сколько времени есть каждый день.',
    ),
    _AiLesson(
      title: 'Разбери свою ошибку',
      description:
      'Разбери ошибочный ответ, найди причину '
          'и научись решать подобные задачи правильно.',
      category: 'Практика',
      duration: '10 мин',
      icon: Icons.lightbulb_outline,
      color: const Color(0xFFFF9B85),
      prompt:
      'Помоги мне разобраться в ошибке. '
          'Попроси прислать задачу и мой ответ, '
          'затем объясни, где и почему возникла ошибка.',
    ),
    _AiLesson(
      title: 'Повтори изученное',
      description:
      'Повтори основные понятия и закрепи их '
          'с помощью короткого интерактивного занятия.',
      category: 'Обучение',
      duration: '5–10 мин',
      icon: Icons.replay_outlined,
      color: const Color(0xFF6ABE77),
      prompt:
      'Проведи короткое занятие для повторения материала. '
          'Спроси, какую тему я изучал, затем проверь понимание '
          'основных понятий.',
    ),
  ];

  List<_AiLesson> get _filteredLessons {
    final query = _searchQuery.toLowerCase();

    return _lessons.where((lesson) {
      final matchesCategory =
          _selectedCategory == 'Все' ||
              lesson.category == _selectedCategory;

      final matchesSearch =
          lesson.title.toLowerCase().contains(query) ||
              lesson.description.toLowerCase().contains(query) ||
              lesson.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAiChat() {
    context.push('/ai_chat');
  }

  void _showLesson(_AiLesson lesson) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF151A15),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: lesson.color.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    lesson.icon,
                    color: lesson.color,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  lesson.title,
                  style: AppTextStyles.display,
                ),

                const SizedBox(height: 10),

                Text(
                  lesson.description,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 18,
                      color: MainStyle.actionColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lesson.duration,
                      style: AppTextStyles.hintText,
                    ),
                    const SizedBox(width: 18),
                    Icon(
                      lesson.icon,
                      size: 18,
                      color: lesson.color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lesson.category,
                      style: AppTextStyles.hintText,
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _openAiChat();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainStyle.actionColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text(
                      'Начать занятие с AI',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lessons = _filteredLessons;

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 3),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'AI LEARNING',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 14),

            const Text(
              'Расти с помощью AI.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Изучай новое, решай задачи и развивай навыки '
                  'вместе со своим AI-наставником.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 24),

            // Карточка AI-наставника
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151A15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: MainStyle.actionColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: MainStyle.actionColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: MainStyle.actionColor,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI-наставник',
                              style: AppTextStyles.WhiteHeading,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Твой помощник в обучении',
                              style: AppTextStyles.hintText,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: MainStyle.successColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Не просто читай теорию. '
                        'Задавай вопросы, практикуйся и проверяй себя.',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _openAiChat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainStyle.actionColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text(
                        'Открыть AI-чат',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'ВЫБЕРИ ФОРМАТ ЗАНЯТИЯ',
              style: AppTextStyles.middleGreenText,
            ),

            const SizedBox(height: 16),

            // Поиск
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
              style: const TextStyle(
                color: MainStyle.TextColor,
              ),
              decoration: InputDecoration(
                hintText: 'Найти занятие...',
                hintStyle: AppTextStyles.hintText,
                prefixIcon: const Icon(
                  Icons.search,
                  color: MainStyle.actionColor,
                ),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white54,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFF151A15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.white12,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.white12,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: MainStyle.actionColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Фильтры
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final selected = _selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: const Color(0xFF151A15),
                      selectedColor: MainStyle.actionColor,
                      side: BorderSide(
                        color: selected
                            ? MainStyle.actionColor
                            : Colors.white12,
                      ),
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.black
                            : Colors.white70,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'ЗАНЯТИЯ',
                    style: AppTextStyles.middleGreenText,
                  ),
                ),
                Text(
                  '${lessons.length}',
                  style: AppTextStyles.hintText,
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (lessons.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF151A15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white12,
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 40,
                      color: Colors.white38,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Занятия не найдены',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              )
            else
              ...lessons.map(
                    (lesson) => _AiLessonCard(
                  lesson: lesson,
                  onTap: () => _showLesson(lesson),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// МОДЕЛЬ ЗАНЯТИЯ
// =====================================================

class _AiLesson {
  final String title;
  final String description;
  final String category;
  final String duration;
  final String prompt;
  final IconData icon;
  final Color color;

  const _AiLesson({
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.prompt,
    required this.icon,
    required this.color,
  });
}

// =====================================================
// КАРТОЧКА ЗАНЯТИЯ
// =====================================================

class _AiLessonCard extends StatelessWidget {
  final _AiLesson lesson;
  final VoidCallback onTap;

  const _AiLessonCard({
    required this.lesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 58,
                decoration: BoxDecoration(
                  color: lesson.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  lesson.icon,
                  color: lesson.color,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: AppTextStyles.WhiteHeading.copyWith(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      lesson.description,
                      style: AppTextStyles.hintText.copyWith(
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: lesson.color,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          lesson.duration,
                          style: AppTextStyles.hintText.copyWith(
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          lesson.category,
                          style: AppTextStyles.miniGreenText.copyWith(
                            fontSize: 10,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              const Icon(
                Icons.chevron_right,
                color: MainStyle.actionColor,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}