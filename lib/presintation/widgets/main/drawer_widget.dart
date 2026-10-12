import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';

class DrawerWidget extends StatelessWidget {
  final int part;

  const DrawerWidget({
    super.key,
    required this.part,
  });

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: MainStyle.backgrountColor,
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: Image.asset(
                'assets/images/mini_logo.png',
                width: 32,
                height: 32,
              ),
              title: const Text(
                'Discipline',
                style: AppTextStyles.heading,
              ),
              trailing: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: MainStyle.actionColor,
                ),
              ),
            ),

            const Divider(
              color: MainStyle.actionColor,
            ),

            _menuItem(
              context: context,
              location: location,
              route: _firstRoute,
              title: _firstTitle,
              icon: _firstIcon,
            ),

            _menuItem(
              context: context,
              location: location,
              route: _secondRoute,
              title: _secondTitle,
              icon: _secondIcon,
            ),

            _menuItem(
              context: context,
              location: location,
              route: _thirdRoute,
              title: _thirdTitle,
              icon: _thirdIcon,
            ),

            _menuItem(
              context: context,
              location: location,
              route: _fourthRoute,
              title: _fourthTitle,
              icon: _fourthIcon,
            ),
          ],
        ),
      ),
    );
  }

  // Иконка первого пункта
  IconData get _firstIcon {
    switch (part) {
      case 1:
        return Icons.home;
      case 2:
        return Icons.track_changes;
      case 3:
        return Icons.auto_awesome_outlined;
      case 4:
        return Icons.insights_outlined;
      default:
        return Icons.emoji_events_outlined;
    }
  }

// Иконка второго пункта
  IconData get _secondIcon {
    switch (part) {
      case 1:
        return Icons.queue_music;
      case 2:
        return Icons.route_outlined;
      case 3:
        return Icons.psychology_outlined;
      case 4:
        return Icons.calendar_month_outlined;
      default:
        return Icons.settings;
    }
  }

// Иконка третьего пункта
  IconData get _thirdIcon {
    switch (part) {
      case 1:
        return Icons.menu_book_outlined;
      case 2:
        return Icons.calendar_view_day_outlined;
      case 3:
        return Icons.quiz_outlined;
      case 4:
        return Icons.phonelink_lock;
      default:
        return Icons.card_giftcard;
    }
  }

// Иконка четвёртого пункта
  IconData get _fourthIcon {
    switch (part) {
      case 1:
        return Icons.video_library_outlined;
      case 2:
        return Icons.bolt_outlined;
      case 3:
        return Icons.source_outlined;
      case 4:
        return Icons.bar_chart;
      default:
        return Icons.pending_outlined;
    }
  }

  String get _firstRoute {
    switch (part) {
      case 1:
        return '/home';
      case 2:
        return '/plan';
      case 3:
        return '/ai_chat';
      case 4:
        return '/schedule';
      default:
        return '/award';
    }
  }

  String get _firstTitle {
    switch (part) {
      case 1:
        return 'Главный экран';
      case 2:
        return 'Экран для планировки';
      case 3:
        return 'AI';
      case 4:
        return 'Показатели';
      default:
        return 'Награды';
    }
  }

  String get _secondRoute {
    switch (part) {
      case 1:
        return '/audio_lessons';
      case 2:
        return '/goal_path';
      case 3:
        return '/ai';
      case 4:
        return '/schedule_widget';
      default:
        return '/settings';
    }
  }

  String get _secondTitle {
    switch (part) {
      case 1:
        return 'Аудио уроки и песни';
      case 2:
        return 'Путь вышей цели';
      case 3:
        return 'Тест с AI';
      case 4:
        return 'Календарь';
      default:
        return 'Настройки';
    }
  }

  String get _thirdRoute {
    switch (part) {
      case 1:
        return '/book_screen';
      case 2:
        return '/daily_schedule';
      case 3:
        return '/ai_lesson';
      case 4:
        return '/app_blocker';
      default:
        return '/prizes';
    }
  }

  String get _thirdTitle {
    switch (part) {
      case 1:
        return 'Книги';
      case 2:
        return 'График на каждый день';
      case 3:
        return 'Занатии с AI';
      case 4:
        return 'Блокировка приложений';
      default:
        return 'Призы';
    }
  }

  String get _fourthRoute {
    switch (part) {
      case 1:
        return '/video_lessons';
      case 2:
        return '/focus';
      case 3:
        return '/ai_material';
      case 4:
        return '/statistics';
      default:
        return '/about_us';
    }
  }

  String get _fourthTitle {
    switch (part) {
      case 1:
        return 'Видео уроки';
      case 2:
        return 'ультра строгий режим';
      case 3:
        return 'Дополнительные Материалы для AI';
      case 4:
        return 'Показатели по уровню статистики';
      default:
        return 'О нас';
    }
  }

  Widget _menuItem({
    required BuildContext context,
    required String location,
    required String route,
    required String title,
    required IconData icon,
  }) {
    final bool isSelected = location == route;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tileColor:
        isSelected ? MainStyle.actionColor : Colors.transparent,
        leading: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight:
            isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: () {
          Navigator.pop(context);

          if (location != route) {
            context.go(route);
          }
        },
      ),
    );
  }
}