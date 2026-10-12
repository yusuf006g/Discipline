
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

// =====================================================
// МОДЕЛИ
// =====================================================

class VideoLesson {
  final String title;
  final String description;
  final String duration;

  // Прямая ссылка на видео. Для демонстрационных видео
  // может быть null, тогда откроется поиск YouTube.
  final String? url;
  final String? searchQuery;

  bool isCompleted;

  VideoLesson({
    required this.title,
    required this.description,
    required this.duration,
    this.url,
    this.searchQuery,
    this.isCompleted = false,
  });
}

class VideoPlaylist {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<VideoLesson> videos;

  VideoPlaylist({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    List<VideoLesson>? videos,
  }) : videos = videos ?? [];
}

// =====================================================
// ДАННЫЕ
// Пока хранятся в памяти приложения.
// =====================================================

final List<VideoPlaylist> videoPlaylists = [
  VideoPlaylist(
    id: 'discipline',
    title: 'Дисциплина',
    description: 'Привычки, регулярность и сила воли.',
    icon: Icons.track_changes,
    color: const Color(0xFFCCE956),
    videos: [
      VideoLesson(
        title: 'Как развить самодисциплину',
        description: 'Как действовать, даже когда нет мотивации.',
        duration: '12 мин',
        searchQuery: 'как развить самодисциплину',
      ),
      VideoLesson(
        title: 'Сила ежедневных привычек',
        description: 'Маленькие действия и большие результаты.',
        duration: '18 мин',
        searchQuery: 'атомные привычки Джеймс Клир',
      ),
    ],
  ),
  VideoPlaylist(
    id: 'focus',
    title: 'Фокус и концентрация',
    description: 'Внимание, концентрация и глубокая работа.',
    icon: Icons.center_focus_strong,
    color: const Color(0xFF7DB9FF),
    videos: [
      VideoLesson(
        title: 'Как улучшить концентрацию',
        description: 'Учись сосредотачиваться на важных задачах.',
        duration: '14 мин',
        searchQuery: 'как улучшить концентрацию внимания',
      ),
      VideoLesson(
        title: 'Как убрать отвлечения',
        description: 'Создай условия для продуктивной работы.',
        duration: '10 мин',
        searchQuery: 'как перестать отвлекаться',
      ),
    ],
  ),
  VideoPlaylist(
    id: 'planning',
    title: 'Планирование',
    description: 'Цели, расписание и управление временем.',
    icon: Icons.calendar_month_outlined,
    color: const Color(0xFFB69CFF),
    videos: [
      VideoLesson(
        title: 'Планирование недели',
        description: 'Организуй задачи на ближайшие семь дней.',
        duration: '12 мин',
        searchQuery: 'как правильно планировать неделю',
      ),
    ],
  ),
];

VideoPlaylist? findPlaylist(String id) {
  for (final playlist in videoPlaylists) {
    if (playlist.id == id) return playlist;
  }
  return null;
}

// =====================================================
// 1. ЭКРАН ПЛЕЙЛИСТОВ
// Здесь нет общей статистики просмотров.
// =====================================================

class VideoLessonsScreen extends StatefulWidget {
  const VideoLessonsScreen({super.key});

  @override
  State<VideoLessonsScreen> createState() =>
      _VideoLessonsScreenState();
}

class _VideoLessonsScreenState extends State<VideoLessonsScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _createPlaylist() async {
    final playlist = await showDialog<VideoPlaylist>(
      context: context,
      builder: (_) => const _CreatePlaylistDialog(),
    );

    if (playlist == null || !mounted) return;

    setState(() {
      videoPlaylists.insert(0, playlist);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Плейлист создан'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.toLowerCase();

    final playlists = videoPlaylists.where((playlist) {
      return playlist.title.toLowerCase().contains(query) ||
          playlist.description.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 1),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPlaylist,
        backgroundColor: MainStyle.actionColor,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'Создать плейлист',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            const Text(
              'VIDEO ACADEMY',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 12),

            const Text(
              'Учись. Применяй. Расти.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Создавай собственные коллекции уроков '
                  'и собирай полезные видео в одном месте.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 26),

            // Поиск по плейлистам
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Найти плейлист...',
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

            const SizedBox(height: 28),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'МОИ ПЛЕЙЛИСТЫ',
                    style: AppTextStyles.middleGreenText,
                  ),
                ),
                Text(
                  '${playlists.length}',
                  style: AppTextStyles.hintText,
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (playlists.isEmpty)
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
                      Icons.video_library_outlined,
                      size: 40,
                      color: Colors.white38,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Плейлисты не найдены',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            ...playlists.map(
                  (playlist) => _PlaylistCard(
                playlist: playlist,
                onTap: () async {
                  await context.push(
                    '/video_lessons/${playlist.id}',
                  );

                  // Обновляем карточки при возвращении.
                  if (mounted) setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// 2. СТРАНИЦА ВНУТРИ ПЛЕЙЛИСТА
// Здесь находится статистика именно этого плейлиста.
// =====================================================

class VideoPlaylistScreen extends StatefulWidget {
  final String playlistId;

  const VideoPlaylistScreen({
    super.key,
    required this.playlistId,
  });

  @override
  State<VideoPlaylistScreen> createState() =>
      _VideoPlaylistScreenState();
}

class _VideoPlaylistScreenState extends State<VideoPlaylistScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addVideo(VideoPlaylist playlist) async {
    final video = await showDialog<VideoLesson>(
      context: context,
      builder: (_) => const _CreateVideoDialog(),
    );

    if (video == null || !mounted) return;

    setState(() {
      playlist.videos.add(video);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Видео добавлено в плейлист'),
      ),
    );
  }

  Future<void> _openVideo(VideoLesson video) async {
    final Uri uri;

    if (video.url != null && video.url!.isNotEmpty) {
      uri = Uri.parse(video.url!);
    } else {
      uri = Uri.https(
        'www.youtube.com',
        '/results',
        {'search_query': video.searchQuery ?? video.title},
      );
    }

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось открыть видео'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlist = findPlaylist(widget.playlistId);

    if (playlist == null) {
      return Scaffold(
        backgroundColor: MainStyle.backgrountColor,
        appBar: const AppBarWidget(),
        body: const Center(
          child: Text(
            'Плейлист не найден',
            style: AppTextStyles.body,
          ),
        ),
      );
    }

    final videos = playlist.videos.where((video) {
      final query = _searchQuery.toLowerCase();

      return video.title.toLowerCase().contains(query) ||
          video.description.toLowerCase().contains(query);
    }).toList();

    final completed =
        playlist.videos.where((video) => video.isCompleted).length;

    final total = playlist.videos.length;

    final progress = total == 0 ? 0.0 : completed / total;

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 1),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addVideo(playlist),
        backgroundColor: MainStyle.actionColor,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'Добавить видео',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            TextButton.icon(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                foregroundColor: MainStyle.actionColor,
                alignment: Alignment.centerLeft,
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Все плейлисты'),
            ),

            const SizedBox(height: 12),

            // Информация о текущем плейлисте
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: playlist.color.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: playlist.color.withAlpha(100),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    playlist.icon,
                    color: playlist.color,
                    size: 42,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    playlist.title,
                    style: AppTextStyles.display,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    playlist.description,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Статистика этого плейлиста
                  Row(
                    children: [
                      Expanded(
                        child: _PlaylistStat(
                          icon: Icons.video_library_outlined,
                          title: 'Всего видео',
                          value: '$total',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PlaylistStat(
                          icon: Icons.check_circle_outline,
                          title: 'Просмотрено',
                          value: '$completed',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Прогресс просмотра',
                          style: AppTextStyles.body,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: AppTextStyles.miniGreenText.copyWith(
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        playlist.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'ВИДЕОУРОКИ',
              style: AppTextStyles.middleGreenText,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value.trim());
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Найти видео в этом плейлисте...',
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
                  borderSide: const BorderSide(color: Colors.white12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: MainStyle.actionColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            if (videos.isEmpty)
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
                      Icons.play_circle_outline,
                      color: Colors.white38,
                      size: 38,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'В этом плейлисте пока нет видео.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Нажми «Добавить видео», чтобы добавить первое.',
                      style: AppTextStyles.hintText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            ...videos.asMap().entries.map(
                  (entry) => _VideoCard(
                number: entry.key + 1,
                video: entry.value,
                color: playlist.color,
                onOpen: () => _openVideo(entry.value),
                onToggleCompleted: () {
                  setState(() {
                    entry.value.isCompleted =
                    !entry.value.isCompleted;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// КАРТОЧКА ПЛЕЙЛИСТА — БЕЗ СТАТИСТИКИ
// =====================================================

class _PlaylistCard extends StatelessWidget {
  final VideoPlaylist playlist;
  final VoidCallback onTap;

  const _PlaylistCard({
    required this.playlist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 72,
                decoration: BoxDecoration(
                  color: playlist.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  playlist.icon,
                  size: 34,
                  color: playlist.color,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.title,
                      style: AppTextStyles.WhiteHeading.copyWith(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      playlist.description,
                      style: AppTextStyles.hintText.copyWith(
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Открыть плейлист',
                      style: AppTextStyles.miniGreenText.copyWith(
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: MainStyle.actionColor,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// СТАТИСТИКА ВНУТРИ ПЛЕЙЛИСТА
// =====================================================

class _PlaylistStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _PlaylistStat({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: MainStyle.actionColor,
            size: 22,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.titleText,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.hintText,
          ),
        ],
      ),
    );
  }
}

// =====================================================
// КАРТОЧКА ВИДЕО
// =====================================================

class _VideoCard extends StatelessWidget {
  final int number;
  final VideoLesson video;
  final Color color;
  final VoidCallback onOpen;
  final VoidCallback onToggleCompleted;

  const _VideoCard({
    required this.number,
    required this.video,
    required this.color,
    required this.onOpen,
    required this.onToggleCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: video.isCompleted
              ? MainStyle.successColor
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onOpen,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                video.isCompleted
                    ? Icons.check_circle
                    : Icons.play_circle_outline,
                color: color,
                size: 34,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: InkWell(
              onTap: onOpen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${number.toString().padLeft(2, '0')}  •  ${video.duration}',
                    style: AppTextStyles.miniGreenText.copyWith(
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    video.title,
                    style: AppTextStyles.WhiteHeading.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    video.description,
                    style: AppTextStyles.hintText.copyWith(
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          IconButton(
            tooltip: video.isCompleted
                ? 'Убрать отметку'
                : 'Отметить просмотренным',
            onPressed: onToggleCompleted,
            icon: Icon(
              video.isCompleted
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
              color: video.isCompleted
                  ? MainStyle.successColor
                  : Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ДИАЛОГ СОЗДАНИЯ ПЛЕЙЛИСТА
// =====================================================

class _CreatePlaylistDialog extends StatefulWidget {
  const _CreatePlaylistDialog();

  @override
  State<_CreatePlaylistDialog> createState() =>
      _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState
    extends State<_CreatePlaylistDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final playlist = VideoPlaylist(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      icon: Icons.video_library_outlined,
      color: MainStyle.actionColor,
    );

    Navigator.of(context).pop(playlist);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF151A15),
      title: const Text(
        'Новый плейлист',
        style: AppTextStyles.WhiteHeading,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: _dialogDecoration('Название плейлиста'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введи название';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: _dialogDecoration('Описание'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Добавь описание';
                  }
                  return null;
                },
              ),
            ],
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
          child: const Text('Создать'),
        ),
      ],
    );
  }
}

// =====================================================
// ДИАЛОГ РУЧНОГО ДОБАВЛЕНИЯ ВИДЕО
// =====================================================

class _CreateVideoDialog extends StatefulWidget {
  const _CreateVideoDialog();

  @override
  State<_CreateVideoDialog> createState() =>
      _CreateVideoDialogState();
}

class _CreateVideoDialogState extends State<_CreateVideoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  String? _validateYouTubeUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Вставь ссылку на YouTube';
    }

    final uri = Uri.tryParse(value.trim());

    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        !(uri.host == 'youtu.be' ||
            uri.host.endsWith('.youtube.com') ||
            uri.host == 'youtube.com')) {
      return 'Введи корректную ссылку YouTube';
    }

    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final video = VideoLesson(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? 'Дополнительное описание не добавлено.'
          : _descriptionController.text.trim(),
      duration: _durationController.text.trim().isEmpty
          ? 'Не указано'
          : _durationController.text.trim(),
      url: _urlController.text.trim(),
    );

    Navigator.of(context).pop(video);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF151A15),
      title: const Text(
        'Добавить видео',
        style: AppTextStyles.WhiteHeading,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: _dialogDecoration('Название видео'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введи название';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                decoration: _dialogDecoration('Описание'),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _durationController,
                style: const TextStyle(color: Colors.white),
                decoration: _dialogDecoration('Длительность, например 12 мин'),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _urlController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.url,
                decoration: _dialogDecoration('Ссылка на YouTube'),
                validator: _validateYouTubeUrl,
              ),
            ],
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
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}

// =====================================================
// ОБЩИЙ СТИЛЬ ПОЛЕЙ ДИАЛОГОВ
// =====================================================

InputDecoration _dialogDecoration(String label) {
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