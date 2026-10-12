
import 'package:flutter/material.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class DailyScheduleScreen extends StatefulWidget {
  const DailyScheduleScreen({super.key});

  @override
  State<DailyScheduleScreen> createState() =>
      _DailyScheduleScreenState();
}

class _DailyScheduleScreenState extends State<DailyScheduleScreen> {
  late DateTime _selectedDate;

  final Map<String, List<_DailyTask>> _tasksByDate = {};

  final List<String> _weekDays = const [
    'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС',
  ];

  final List<String> _months = const [
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

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);

    // Демонстрационные задачи на сегодня.
    _tasksByDate[_dateKey(_selectedDate)] = [
      _DailyTask(
        title: 'Определить приоритеты',
        description: 'Выбрать три главные задачи на день.',
        time: const TimeOfDay(hour: 9, minute: 0),
        duration: 15,
        icon: Icons.flag_outlined,
      ),
      _DailyTask(
        title: 'Работа над главной целью',
        description: 'Продвинуться на один шаг к своей цели.',
        time: const TimeOfDay(hour: 10, minute: 0),
        duration: 60,
        icon: Icons.track_changes,
      ),
      _DailyTask(
        title: 'Глубокий фокус',
        description: 'Поработать без отвлечений.',
        time: const TimeOfDay(hour: 14, minute: 0),
        duration: 45,
        icon: Icons.center_focus_strong,
      ),
      _DailyTask(
        title: 'Итоги дня',
        description: 'Оценить результат и подготовить завтра.',
        time: const TimeOfDay(hour: 20, minute: 0),
        duration: 15,
        icon: Icons.check_circle_outline,
      ),
    ];
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  DateTime get _weekStart {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day - _selectedDate.weekday + 1,
    );
  }

  List<_DailyTask> get _selectedTasks {
    final tasks = List<_DailyTask>.from(
      _tasksByDate[_dateKey(_selectedDate)] ?? [],
    );

    tasks.sort((a, b) {
      final first = a.time.hour * 60 + a.time.minute;
      final second = b.time.hour * 60 + b.time.minute;

      return first.compareTo(second);
    });

    return tasks;
  }

  int get _completedCount =>
      _selectedTasks.where((task) => task.isCompleted).length;

  int get _totalMinutes =>
      _selectedTasks.fold(0, (sum, task) => sum + task.duration);

  double get _progress {
    if (_selectedTasks.isEmpty) return 0;

    return _completedCount / _selectedTasks.length;
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes мин';

    final hours = minutes ~/ 60;
    final remainder = minutes % 60;

    if (remainder == 0) return '$hours ч';

    return '$hours ч $remainder мин';
  }

  String get _selectedDateLabel {
    final date = _selectedDate;
    return '${date.day} ${_months[date.month - 1]}';
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
    });
  }

  Future<void> _addTask() async {
    final task = await showDialog<_DailyTask>(
      context: context,
      builder: (context) => const _AddTaskDialog(),
    );

    if (task == null || !mounted) return;

    setState(() {
      _tasksByDate.putIfAbsent(
        _dateKey(_selectedDate),
            () => [],
      );

      _tasksByDate[_dateKey(_selectedDate)]!.add(task);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Задача добавлена в расписание'),
      ),
    );
  }

  void _toggleTask(_DailyTask task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  void _deleteTask(_DailyTask task) {
    setState(() {
      _tasksByDate[_dateKey(_selectedDate)]?.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _selectedTasks;

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 2),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        backgroundColor: MainStyle.actionColor,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'Добавить задачу',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            const Text(
              'DAILY SCHEDULE',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 14),

            const Text(
              'График на каждый день.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Распредели время и двигайся к цели шаг за шагом.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 26),

            // Выбор недели и даты
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF151A15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'ВЫБЕРИ ДЕНЬ',
                          style: AppTextStyles.miniGreenText,
                        ),
                      ),

                      IconButton(
                        tooltip: 'Предыдущая неделя',
                        onPressed: () {
                          _selectDate(
                            _selectedDate.subtract(
                              const Duration(days: 7),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          color: MainStyle.actionColor,
                        ),
                      ),

                      IconButton(
                        tooltip: 'Следующая неделя',
                        onPressed: () {
                          _selectDate(
                            _selectedDate.add(
                              const Duration(days: 7),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.chevron_right,
                          color: MainStyle.actionColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: List.generate(7, (index) {
                      final date = _weekStart.add(
                        Duration(days: index),
                      );

                      final selected =
                          _dateKey(date) == _dateKey(_selectedDate);

                      final today =
                          _dateKey(date) == _dateKey(DateTime.now());

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _selectDate(date),
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 180,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? MainStyle.actionColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected
                                      ? MainStyle.actionColor
                                      : today
                                      ? MainStyle.actionColor
                                      : Colors.white12,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _weekDays[index],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: selected
                                          ? Colors.black
                                          : Colors.white54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selected
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Container(
                                    height: 5,
                                    width: 5,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selected
                                          ? Colors.black
                                          : (_tasksByDate[
                                      _dateKey(date)]
                                          ?.isNotEmpty ??
                                          false)
                                          ? MainStyle.actionColor
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Карточка статистики выбранного дня
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
                  Text(
                    _selectedDateLabel.toUpperCase(),
                    style: AppTextStyles.miniGreenText,
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'План на день',
                          style: AppTextStyles.WhiteHeading.copyWith(
                            fontSize: 19,
                          ),
                        ),
                      ),

                      Text(
                        '${(_progress * 100).round()}%',
                        style: AppTextStyles.middleGreenText,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          icon: Icons.task_alt,
                          title: 'Выполнено',
                          value: '$_completedCount/${tasks.length}',
                        ),
                      ),

                      Expanded(
                        child: _StatItem(
                          icon: Icons.schedule,
                          title: 'Запланировано',
                          value: _formatDuration(_totalMinutes),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'РАСПИСАНИЕ',
                    style: AppTextStyles.middleGreenText,
                  ),
                ),

                Text(
                  '${tasks.length} задач',
                  style: AppTextStyles.hintText,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Задачи на $_selectedDateLabel',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 18),

            if (tasks.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF151A15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.event_note_outlined,
                      color: Colors.white38,
                      size: 42,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'На этот день задач пока нет.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Нажми «Добавить задачу», чтобы составить расписание.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.hintText,
                    ),
                  ],
                ),
              )
            else
              ...List.generate(tasks.length, (index) {
                final task = tasks[index];

                return _TimelineTaskCard(
                  task: task,
                  time: _formatTime(task.time),
                  duration: _formatDuration(task.duration),
                  isLast: index == tasks.length - 1,
                  onToggle: () => _toggleTask(task),
                  onDelete: () => _deleteTask(task),
                );
              }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// КАРТОЧКА ЗАДАЧИ НА ВРЕМЕННОЙ ЛИНИИ
// =====================================================

class _TimelineTaskCard extends StatelessWidget {
  final _DailyTask task;
  final String time;
  final String duration;
  final bool isLast;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TimelineTaskCard({
    required this.task,
    required this.time,
    required this.duration,
    required this.isLast,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Text(
                  time,
                  style: AppTextStyles.miniGreenText.copyWith(
                    fontSize: 11,
                    letterSpacing: 0,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isCompleted
                        ? MainStyle.successColor
                        : MainStyle.actionColor,
                    border: Border.all(
                      color: Colors.white.withAlpha(40),
                      width: 2,
                    ),
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                      ),
                      color: Colors.white12,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF151A15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: task.isCompleted
                      ? MainStyle.successColor
                      : Colors.white12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: (task.isCompleted
                              ? MainStyle.successColor
                              : MainStyle.actionColor)
                              .withAlpha(25),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(
                          task.isCompleted
                              ? Icons.check_circle
                              : task.icon,
                          color: task.isCompleted
                              ? MainStyle.successColor
                              : MainStyle.actionColor,
                          size: 21,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          task.title,
                          style: AppTextStyles.WhiteHeading.copyWith(
                            fontSize: 15,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? Colors.white54
                                : Colors.white,
                          ),
                        ),
                      ),

                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white54,
                          size: 20,
                        ),
                        color: const Color(0xFF202522),
                        onSelected: (value) {
                          if (value == 'delete') onDelete();
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'Удалить задачу',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    task.description,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Colors.white54,
                        size: 15,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        duration,
                        style: AppTextStyles.hintText.copyWith(
                          fontSize: 12,
                        ),
                      ),

                      const Spacer(),

                      InkWell(
                        onTap: onToggle,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: task.isCompleted
                                ? MainStyle.successColor.withAlpha(25)
                                : MainStyle.actionColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: task.isCompleted
                                  ? MainStyle.successColor
                                  : MainStyle.actionColor,
                            ),
                          ),
                          child: Text(
                            task.isCompleted
                                ? 'Выполнено'
                                : 'Завершить',
                            style: TextStyle(
                              color: task.isCompleted
                                  ? MainStyle.successColor
                                  : MainStyle.actionColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// СТАТИСТИКА
// =====================================================

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: MainStyle.actionColor,
          size: 20,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.WhiteHeading.copyWith(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppTextStyles.hintText.copyWith(
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================
// МОДЕЛЬ ЗАДАЧИ
// =====================================================

class _DailyTask {
  final String title;
  final String description;
  final TimeOfDay time;
  final int duration;
  final IconData icon;

  bool isCompleted;

  _DailyTask({
    required this.title,
    required this.description,
    required this.time,
    required this.duration,
    required this.icon,
    this.isCompleted = false,
  });
}

// =====================================================
// ДИАЛОГ ДОБАВЛЕНИЯ ЗАДАЧИ
// =====================================================

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController(text: '30');

  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time == null || !mounted) return;

    setState(() {
      _selectedTime = time;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final duration = int.tryParse(
      _durationController.text.trim(),
    );

    if (duration == null || duration < 1) return;

    final task = _DailyTask(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? 'Задача на сегодня.'
          : _descriptionController.text.trim(),
      time: _selectedTime,
      duration: duration,
      icon: Icons.task_alt,
    );

    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF151A15),
      title: const Text(
        'Новая задача',
        style: AppTextStyles.WhiteHeading,
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Название задачи'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введи название задачи';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  decoration: _inputDecoration('Описание'),
                ),

                const SizedBox(height: 14),

                InkWell(
                  onTap: _pickTime,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: MainStyle.actionColor,
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            'Время начала',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),

                        Text(
                          '${_selectedTime.hour.toString().padLeft(2, '0')}:'
                              '${_selectedTime.minute.toString().padLeft(2, '0')}',
                          style: AppTextStyles.middleGreenText,
                        ),

                        const SizedBox(width: 5),

                        const Icon(
                          Icons.edit_outlined,
                          color: Colors.white54,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Длительность в минутах'),
                  validator: (value) {
                    final minutes = int.tryParse(value?.trim() ?? '');

                    if (minutes == null || minutes < 1) {
                      return 'Введи длительность в минутах';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Отмена',
            style: TextStyle(color: Colors.white70),
          ),
        ),

        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: MainStyle.actionColor,
            foregroundColor: Colors.black,
          ),
          child: const Text(
            'Добавить',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white54),
    filled: true,
    fillColor: MainStyle.backgrountColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: MainStyle.actionColor,
      ),
    ),
  );
}