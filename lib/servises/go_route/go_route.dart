
import 'package:go_router/go_router.dart';

import 'package:discipline/presintation/screens/ai_screen/ai_chat_screen.dart';
import 'package:discipline/presintation/screens/ai_screen/ai_lessons_screen.dart';
import 'package:discipline/presintation/screens/ai_screen/ai_materials_screen.dart';
import 'package:discipline/presintation/screens/ai_screen/ai_screen.dart';

import 'package:discipline/presintation/screens/auth/auth_hobby_screen.dart';
import 'package:discipline/presintation/screens/auth/auth_login_screen.dart';
import 'package:discipline/presintation/screens/auth/auth_main.dart';
import 'package:discipline/presintation/screens/auth/auth_registrate_screen.dart';

import 'package:discipline/presintation/screens/award_screen/about_us_screen.dart';
import 'package:discipline/presintation/screens/award_screen/award_screen.dart';
import 'package:discipline/presintation/screens/award_screen/prizes_screen.dart';
import 'package:discipline/presintation/screens/award_screen/settings_screen.dart';
import 'package:discipline/presintation/screens/award_screen/week_xp_screen.dart';

import 'package:discipline/presintation/screens/home_%20screen/audio_lessons_screen.dart';
import 'package:discipline/presintation/screens/home_%20screen/book_screen.dart';
import 'package:discipline/presintation/screens/home_%20screen/home_screen.dart';
import 'package:discipline/presintation/screens/home_%20screen/video_lessons_screen.dart';

import 'package:discipline/presintation/screens/plan_screen/daily_schedule_screen.dart';
import 'package:discipline/presintation/screens/plan_screen/focuse_screen.dart';
import 'package:discipline/presintation/screens/plan_screen/goal_path_screen.dart';
import 'package:discipline/presintation/screens/plan_screen/plan_screen.dart';

import 'package:discipline/presintation/screens/schedule_screen/app_blocker_screen.dart';
import 'package:discipline/presintation/screens/schedule_screen/schedule_screen.dart';
import 'package:discipline/presintation/screens/schedule_screen/statistics_screen.dart';
import 'package:discipline/presintation/screens/splash_screen/splash_screen.dart';

import 'package:discipline/presintation/widgets/main/buttom_nav_bar.dart';

import '../../presintation/screens/schedule_screen/schedule_widget_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',

  routes: [
    // =========================
    // SPLASH
    // =========================

    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // =========================
    // AUTH
    // Нижняя панель здесь не отображается
    // =========================

    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthMain(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthLoginScreen(),
    ),

    GoRoute(
      path: '/registrate',
      builder: (context, state) => const AuthRegistrateScreen(),
    ),

    GoRoute(
      path: '/hobby',
      builder: (context, state) => const AuthHobbyScreen(),
    ),

    // =========================
    // MAIN APP
    // Нижняя панель доступна
    // на каждом экране внутри веток
    // =========================

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ButtomNavBar(
          navigationShell: navigationShell,
        );
      },

      branches: [
        // =================================
        // 0. HOME
        // =================================

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),

            GoRoute(
              path: '/book_screen',
              builder: (context, state) => const BooksScreen(),
            ),

            GoRoute(
              path: '/audio_lessons',
              builder: (context, state) => const AudioLessonsScreen(),
            ),

            GoRoute(
              path: '/video_lessons',
              builder: (context, state) => const VideoLessonsScreen(),
              routes: [
                GoRoute(
                  path: ':playlistId',
                  builder: (context, state) => VideoPlaylistScreen(
                    playlistId: state.pathParameters['playlistId']!,
                  ),
                ),
              ],
            ),
          ],
        ),

        // =================================
        // 1. PLAN
        // =================================

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/plan',
              builder: (context, state) => const PlanScreen(),
            ),

            GoRoute(
              path: '/planTwo',
              builder: (context, state) => const PlanSecendPart(),
            ),

            GoRoute(
              path: '/planThree',
              builder: (context, state) => const PlanThirdPart(),
            ),

            GoRoute(
              path: '/goal_path',
              builder: (context, state) => const GoalPathScreen(),
            ),

            GoRoute(
              path: '/daily_schedule',
              builder: (context, state) => const DailyScheduleScreen(),
            ),

            GoRoute(
              path: '/focus',
              builder: (context, state) => const FocuseScreen(),
            ),
          ],
        ),

        // =================================
        // 2. AI
        // =================================

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/ai',
              builder: (context, state) => const AiScreen(),
            ),

            GoRoute(
              path: '/ai_chat',
              builder: (context, state) => const AiChatScreen(),
            ),

            GoRoute(
              path: '/aiTwo',
              builder: (context, state) => const AiTwo(),
            ),

            GoRoute(
              path: '/ai_lesson',
              builder: (context, state) => const AiLessonsScreen(),
            ),

            GoRoute(
              path: '/ai_material',
              builder: (context, state) => const AiMaterialsScreen(),
            ),
          ],
        ),

        // =================================
        // 3. SCHEDULE
        // =================================

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/schedule',
              builder: (context, state) => const ScheduleScreen(),
            ),

            GoRoute(
              path: '/schedule_widget',
              builder: (context, state) => const ScheduleWidgetScreen(),
            ),

            GoRoute(
              path: '/app_blocker',
              builder: (context, state) => const AppBlockerScreen(),
            ),

            GoRoute(
              path: '/statistics',
              builder: (context, state) => const StatisticsScreen(),
            ),
          ],
        ),

        // =================================
        // 4. AWARD
        // =================================

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/award',
              builder: (context, state) => const AwardScreen(),
            ),

            GoRoute(
              path: '/week_xp',
              builder: (context, state) => const WeekXpScreen(),
            ),

            GoRoute(
              path: '/prizes',
              builder: (context, state) => const PrizesScreen(),
            ),

            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),

            GoRoute(
              path: '/about_us',
              builder: (context, state) => const AboutUsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);