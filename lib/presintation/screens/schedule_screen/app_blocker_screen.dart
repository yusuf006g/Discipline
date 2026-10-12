
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class AppBlockerScreen extends StatefulWidget {
  const AppBlockerScreen({super.key});

  @override
  State<AppBlockerScreen> createState() =>
      _AppBlockerScreenState();
}

class _AppBlockerScreenState extends State<AppBlockerScreen> {
  static const String _storageKey = 'blocked_app_packages';

  List<AppInfo> _apps = [];
  final Set<String> _selectedPackages = {};

  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';
  String? _errorMessage;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    if (!Platform.isAndroid) {
      setState(() {
        _loading = false;
        _errorMessage =
        'Выбор установленных приложений доступен на Android.';
      });
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      final savedPackages =
          prefs.getStringList(_storageKey) ?? [];

      final apps = await InstalledApps.getInstalledApps(
        excludeSystemApps: true,
        excludeNonLaunchableApps: true,
        withIcon: true,
        detectPlatformType: false,
      );

      apps.sort(
            (a, b) => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
      );

      final installedPackages =
      apps.map((app) => app.packageName).toSet();

      if (!mounted) return;

      setState(() {
        _apps = apps;
        _selectedPackages.addAll(
          savedPackages.where(
                (package) => installedPackages.contains(package),
          ),
        );
        _loading = false;
        _errorMessage = apps.isEmpty
            ? 'Список приложений пуст. Проверь доступ к приложениям на устройстве.'
            : null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'Не удалось загрузить приложения: $e';
      });
    }
  }

  List<AppInfo> get _filteredApps {
    final query = _searchQuery.toLowerCase();

    return _apps.where((app) {
      return app.name.toLowerCase().contains(query) ||
          app.packageName.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _toggleApp(
      AppInfo app,
      bool selected,
      ) async {
    setState(() {
      if (selected) {
        _selectedPackages.add(app.packageName);
      } else {
        _selectedPackages.remove(app.packageName);
      }
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setStringList(
        _storageKey,
        _selectedPackages.toList(),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось сохранить выбор приложений'),
        ),
      );
    }
  }

  Future<void> _clearSelection() async {
    setState(() {
      _selectedPackages.clear();
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(_storageKey, []);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps = _filteredApps;

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 4),

      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'APP CONTROL',
                    style: AppTextStyles.heading,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Выбери приложения.',
                    style: AppTextStyles.display,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Отметь приложения, от которых хочешь '
                        'отвлечься во время фокус-сессии.',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Статистика выбора
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151A15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: MainStyle.actionColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.phonelink_lock,
                          color: MainStyle.actionColor,
                          size: 30,
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Выбрано приложений',
                                style: AppTextStyles.body,
                              ),

                              const SizedBox(height: 4),

                              Text(
                                '${_selectedPackages.length}',
                                style: AppTextStyles.titleText,
                              ),
                            ],
                          ),
                        ),

                        if (_selectedPackages.isNotEmpty)
                          TextButton(
                            onPressed: _clearSelection,
                            child: const Text(
                              'Сбросить',
                              style: TextStyle(
                                color: MainStyle.actionColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Поиск приложений
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Найти приложение...',
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

                          setState(() {
                            _searchQuery = '';
                          });
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

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'ПРИЛОЖЕНИЯ НА УСТРОЙСТВЕ',
                          style: AppTextStyles.label,
                        ),
                      ),

                      Text(
                        '${filteredApps.length}',
                        style: AppTextStyles.hintText,
                      ),

                      const SizedBox(width: 10),

                      IconButton(
                        tooltip: 'Обновить список',
                        onPressed: () {
                          setState(() {
                            _loading = true;
                            _errorMessage = null;
                          });

                          _loadApps();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: MainStyle.actionColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Состояния загрузки и ошибки
            if (_loading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: MainStyle.actionColor,
                  ),
                ),
              )
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: MainStyle.warningColor,
                          size: 42,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          _errorMessage!,
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _loading = true;
                              _errorMessage = null;
                            });

                            _loadApps();
                          },
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (filteredApps.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'Приложения не найдены',
                      style: AppTextStyles.body,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      24,
                    ),
                    itemCount: filteredApps.length,
                    itemBuilder: (context, index) {
                      final app = filteredApps[index];

                      final selected = _selectedPackages.contains(
                        app.packageName,
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151A15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? MainStyle.actionColor
                                : Colors.white12,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),

                          leading: SizedBox(
                            width: 44,
                            height: 44,
                            child: app.icon != null
                                ? Image.memory(
                              app.icon!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) {
                                return const Icon(
                                  Icons.android,
                                  color: MainStyle.actionColor,
                                  size: 34,
                                );
                              },
                            )
                                : const Icon(
                              Icons.android,
                              color: MainStyle.actionColor,
                              size: 34,
                            ),
                          ),

                          title: Text(
                            app.name,
                            style: AppTextStyles.WhiteHeading.copyWith(
                              fontSize: 15,
                            ),
                          ),

                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              app.packageName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.hintText.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),

                          trailing: Switch.adaptive(
                            value: selected,
                            activeTrackColor: MainStyle.actionColor,
                            activeThumbColor: Colors.black,
                            onChanged: (value) {
                              _toggleApp(app, value);
                            },
                          ),

                          onTap: () {
                            _toggleApp(app, !selected);
                          },
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}