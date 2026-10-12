
import 'package:flutter/material.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class ScheduleWidgetScreen extends StatefulWidget {
  const ScheduleWidgetScreen({super.key});

  @override
  State<ScheduleWidgetScreen> createState() => _ScheduleWidgetScreenState();
}

class _ScheduleWidgetScreenState extends State<ScheduleWidgetScreen> {
  DateTime _focusedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  DateTime _selectedDate = DateTime.now();

  final List<String> _months = const [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];

  final List<String> _monthsGenitive = const [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  final List<String> _weekDays = const [
    'ПН',
    'ВТ',
    'СР',
    'ЧТ',
    'ПТ',
    'СБ',
    'ВС',
  ];

  late final Map<String, List<_CalendarTask>> _tasksByDate = {
    _dateKey(DateTime.now()): [
      _CalendarTask(
        title: 'Определить приоритеты',
        time: '09:00',
        icon: Icons.flag_outlined,
      ),
      _CalendarTask(
        title: 'Работа над главной целью',
        time: '11:00',
        icon: Icons.track_changes,
      ),
      _CalendarTask(
        title: 'Глубокий фокус',
        time: '15:00',
        icon: Icons.center_focus_strong,
      ),
    ],
    _dateKey(DateTime.now().add(const Duration(days: 1))): [
      _CalendarTask(
        title: 'Проверить прогресс',
        time: '10:00',
        icon: Icons.trending_up,
      ),
      _CalendarTask(
        title: 'Запланировать следующий шаг',
        time: '16:00',
        icon: Icons.event_note,
      ),
    ],
  };

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + offset,
      );

      _selectedDate = DateTime(
        _focusedMonth.year,
        _focusedMonth.month,
        1,
      );
    });
  }

  void _selectDay(int day) {
    setState(() {
      _selectedDate = DateTime(
        _focusedMonth.year,
        _focusedMonth.month,
        day,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstWeekday = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    ).weekday -
        1;

    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;

    final tasks = _tasksByDate[_dateKey(_selectedDate)] ??
        <_CalendarTask>[];

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 4),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'КАЛЕНДАРЬ',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 14),

            const Text(
              'Планируйте свой прогресс.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Каждый день — маленький шаг к большой цели.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 24),

            // Календарь
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MainStyle.backgrountColor.withGreen(20),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_months[_focusedMonth.month - 1]} '
                              '${_focusedMonth.year}',
                          style: AppTextStyles.middleText,
                        ),
                      ),

                      IconButton(
                        onPressed: () => _changeMonth(-1),
                        icon: const Icon(
                          Icons.chevron_left,
                          color: MainStyle.actionColor,
                          size: 28,
                        ),
                      ),

                      IconButton(
                        onPressed: () => _changeMonth(1),
                        icon: const Icon(
                          Icons.chevron_right,
                          color: MainStyle.actionColor,
                          size: 28,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Дни недели
                  Row(
                    children: _weekDays.map((day) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: AppTextStyles.label.copyWith(
                              letterSpacing: 0.5,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 12),

                  // Даты
                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: firstWeekday + daysInMonth,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      if (index < firstWeekday) {
                        return const SizedBox.shrink();
                      }

                      final day = index - firstWeekday + 1;

                      final date = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month,
                        day,
                      );

                      final isSelected =
                      _isSameDay(date, _selectedDate);

                      final isToday =
                      _isSameDay(date, DateTime.now());

                      final hasTasks =
                      _tasksByDate.containsKey(_dateKey(date));

                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => _selectDay(day),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? MainStyle.actionColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: isToday && !isSelected
                                ? Border.all(
                              color: MainStyle.actionColor,
                            )
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$day',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black
                                      : MainStyle.TextColor,
                                  fontWeight: isSelected ||
                                      isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: hasTasks
                                      ? (isSelected
                                      ? Colors.black
                                      : MainStyle.actionColor)
                                      : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: MainStyle.actionColor,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        'День с запланированными задачами',
                        style: AppTextStyles.hintText.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Задачи выбранной даты
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_selectedDate.day} '
                        '${_monthsGenitive[_selectedDate.month - 1]}',
                    style: AppTextStyles.middleGreenText,
                  ),
                ),

                Text(
                  '${tasks.length} задач',
                  style: AppTextStyles.hintText,
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (tasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: MainStyle.backgrountColor.withGreen(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.event_available_outlined,
                      size: 34,
                      color: Colors.white38,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'На этот день пока нет задач.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...tasks.map((task) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: MainStyle.backgrountColor.withGreen(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: task.isDone
                          ? MainStyle.successColor
                          : Colors.white12,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: MainStyle.actionColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          task.icon,
                          color: MainStyle.actionColor,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: AppTextStyles.body.copyWith(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isDone
                                    ? Colors.white54
                                    : MainStyle.TextColor,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              task.time,
                              style: AppTextStyles.hintText,
                            ),
                          ],
                        ),
                      ),

                      Checkbox(
                        value: task.isDone,
                        activeColor: MainStyle.actionColor,
                        checkColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            task.isDone = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CalendarTask {
  final String title;
  final String time;
  final IconData icon;
  bool isDone;

  _CalendarTask({
    required this.title,
    required this.time,
    required this.icon,
    this.isDone = false,
  });
}