
import 'package:flutter/material.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _dailyReminder = true;
  bool _sound = true;
  bool _vibration = false;

  TimeOfDay _reminderTime = const TimeOfDay(
    hour: 20,
    minute: 0,
  );

  String _language = 'Русский';

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectReminderTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: MainStyle.actionColor,
              onPrimary: Colors.black,
              surface: Color(0xFF151A15),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null || !mounted) return;

    setState(() {
      _reminderTime = time;
    });
  }

  Future<void> _selectLanguage() async {
    final language = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF151A15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        final languages = [
          ('Русский', 'RU'),
          ('English', 'EN'),
          ('한국어', 'KO'),
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Язык приложения',
                  style: AppTextStyles.WhiteHeading,
                ),
                const SizedBox(height: 16),

                ...languages.map((item) {
                  final selected = _language == item.$1;

                  return ListTile(
                    leading: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? MainStyle.actionColor.withAlpha(25)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.$2,
                        style: TextStyle(
                          color: selected
                              ? MainStyle.actionColor
                              : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      item.$1,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(
                      Icons.check_circle,
                      color: MainStyle.actionColor,
                    )
                        : null,
                    onTap: () => Navigator.pop(context, item.$1),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    if (language == null || !mounted) return;

    setState(() {
      _language = language;
    });

    _showMessage(
      'Выбран язык: $language. Для перевода остальных экранов '
          'нужно подключить локализацию.',
    );
  }

  void _resetSettings() {
    setState(() {
      _notifications = true;
      _dailyReminder = true;
      _sound = true;
      _vibration = false;
      _reminderTime = const TimeOfDay(hour: 20, minute: 0);
      _language = 'Русский';
    });

    _showMessage('Настройки сброшены');
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151A15),
          title: const Text(
            'Сбросить настройки?',
            style: AppTextStyles.WhiteHeading,
          ),
          content: const Text(
            'Все параметры на этой странице вернутся '
                'к исходным значениям.',
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: MainStyle.actionColor,
                foregroundColor: Colors.black,
              ),
              child: const Text('Сбросить'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      _resetSettings();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 5),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          children: [
            const Text(
              'PREFERENCES',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 14),

            const Text(
              'Настройки.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Настрой Discipline под себя и свой ритм жизни.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 26),

            // Профиль
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF151A15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: MainStyle.actionColor,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: MainStyle.actionColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: MainStyle.actionColor,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discipline',
                          style: AppTextStyles.WhiteHeading,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Твой личный центр управления',
                          style: AppTextStyles.hintText,
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.tune,
                    color: MainStyle.actionColor,
                    size: 24,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const _SectionTitle(
              title: 'УВЕДОМЛЕНИЯ',
              description: 'Управляй своими напоминаниями.',
            ),

            const SizedBox(height: 12),

            _SettingsGroup(
              children: [
                _SwitchTile(
                  icon: Icons.notifications_outlined,
                  title: 'Уведомления',
                  subtitle: 'Разрешить уведомления приложения',
                  value: _notifications,
                  onChanged: (value) {
                    setState(() {
                      _notifications = value;

                      if (!value) {
                        _dailyReminder = false;
                      }
                    });
                  },
                ),

                if (_notifications) ...[
                  const _SettingsDivider(),

                  _SwitchTile(
                    icon: Icons.alarm_outlined,
                    title: 'Ежедневное напоминание',
                    subtitle: 'Не забывай о своих целях',
                    value: _dailyReminder,
                    onChanged: (value) {
                      setState(() {
                        _dailyReminder = value;
                      });
                    },
                  ),

                  if (_dailyReminder) ...[
                    const _SettingsDivider(),

                    _ActionTile(
                      icon: Icons.schedule,
                      title: 'Время напоминания',
                      subtitle: 'Когда напомнить о целях',
                      trailing: _formatTime(_reminderTime),
                      onTap: _selectReminderTime,
                    ),
                  ],
                ],
              ],
            ),

            const SizedBox(height: 28),

            const _SectionTitle(
              title: 'ЗВУК И ВИБРАЦИЯ',
              description: 'Настрой отклик приложения.',
            ),

            const SizedBox(height: 12),

            _SettingsGroup(
              children: [
                _SwitchTile(
                  icon: Icons.volume_up_outlined,
                  title: 'Звуковые эффекты',
                  subtitle: 'Звук при действиях в приложении',
                  value: _sound,
                  onChanged: (value) {
                    setState(() {
                      _sound = value;
                    });
                  },
                ),

                const _SettingsDivider(),

                _SwitchTile(
                  icon: Icons.vibration,
                  title: 'Вибрация',
                  subtitle: 'Тактильная обратная связь',
                  value: _vibration,
                  onChanged: (value) {
                    setState(() {
                      _vibration = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 28),

            const _SectionTitle(
              title: 'ВНЕШНИЙ ВИД',
              description: 'Настрой внешний вид приложения.',
            ),

            const SizedBox(height: 12),

            _SettingsGroup(
              children: [
                _ActionTile(
                  icon: Icons.palette_outlined,
                  title: 'Тема оформления',
                  subtitle: 'Тёмная тема Discipline',
                  trailing: 'DARK',
                  onTap: () {
                    _showMessage(
                      'Сейчас доступна тёмная тема.',
                    );
                  },
                ),

                const _SettingsDivider(),

                _ActionTile(
                  icon: Icons.language,
                  title: 'Язык приложения',
                  subtitle: 'Выбери предпочитаемый язык',
                  trailing: _language,
                  onTap: _selectLanguage,
                ),
              ],
            ),

            const SizedBox(height: 28),

            const _SectionTitle(
              title: 'ДАННЫЕ И ПРИЛОЖЕНИЕ',
              description: 'Управление настройками.',
            ),

            const SizedBox(height: 12),

            _SettingsGroup(
              children: [
                _ActionTile(
                  icon: Icons.restart_alt,
                  title: 'Сбросить настройки',
                  subtitle: 'Вернуть исходные значения',
                  trailing: '',
                  onTap: _confirmReset,
                  iconColor: MainStyle.warningColor,
                ),

                const _SettingsDivider(),

                const _ActionTile(
                  icon: Icons.info_outline,
                  title: 'О приложении',
                  subtitle: 'Discipline · Версия 1.0.0',
                  trailing: '',
                  iconColor: MainStyle.actionColor,
                ),
              ],
            ),

            const SizedBox(height: 28),

            Center(
              child: Text(
                'DISCIPLINE',
                style: AppTextStyles.miniGreenText.copyWith(
                  letterSpacing: 3,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Маленькие действия. Большие изменения.',
              textAlign: TextAlign.center,
              style: AppTextStyles.hintText.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// ЗАГОЛОВОК РАЗДЕЛА
// =====================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final String description;

  const _SectionTitle({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.middleGreenText.copyWith(
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: AppTextStyles.hintText,
        ),
      ],
    );
  }
}

// =====================================================
// ГРУППА НАСТРОЕК
// =====================================================

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

// =====================================================
// РАЗДЕЛИТЕЛЬ
// =====================================================

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Colors.white10,
      indent: 58,
      endIndent: 14,
    );
  }
}

// =====================================================
// ПЕРЕКЛЮЧАТЕЛЬ
// =====================================================

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MainStyle.actionColor.withAlpha(20),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: MainStyle.actionColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.WhiteHeading.copyWith(
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: AppTextStyles.hintText.copyWith(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: MainStyle.actionColor,
            activeThumbColor: Colors.black,
          ),
        ],
      ),
    );
  }
}

// =====================================================
// НАСТРОЙКА С ПЕРЕХОДОМ
// =====================================================

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback? onTap;
  final Color iconColor;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
    this.iconColor = MainStyle.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 5,
      ),

      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: iconColor.withAlpha(20),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),

      title: Text(
        title,
        style: AppTextStyles.WhiteHeading.copyWith(
          fontSize: 14,
        ),
      ),

      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: AppTextStyles.hintText.copyWith(
            height: 1.4,
          ),
        ),
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing.isNotEmpty)
            Text(
              trailing,
              style: AppTextStyles.miniGreenText.copyWith(
                letterSpacing: 0,
              ),
            ),

          if (onTap != null)
            const SizedBox(width: 4),

          if (onTap != null)
            const Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
        ],
      ),
    );
  }
}