
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class AudioLessonsScreen extends StatefulWidget {
  const AudioLessonsScreen({super.key});

  @override
  State<AudioLessonsScreen> createState() =>
      _AudioLessonsScreenState();
}

class _AudioLessonsScreenState extends State<AudioLessonsScreen> {
  final AudioPlayer _player = AudioPlayer();

  late final StreamSubscription<PlayerState> _playerSubscription;

  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'Все';

  _AudioTrack? _currentTrack;
  bool _isPlaying = false;
  bool _isLoadingAudio = false;
  String? _audioError;

  final List<String> _categories = const [
    'Все',
    'Аудиоуроки',
    'Песни',
    'Медитации',
  ];

  final List<_AudioTrack> _tracks = [
    _AudioTrack(
      id: 'audio_1',
      title: 'Утренний настрой',
      creator: 'Аудиоурок',
      description: 'Начни день с ясной целью и правильным настроем.',
      category: 'Аудиоуроки',
      durationLabel: '10 мин',
      icon: Icons.wb_sunny_outlined,
      color: Color(0xFFCCE956),
      url: '',
    ),
    _AudioTrack(
      id: 'audio_2',
      title: 'Музыка для глубокого фокуса',
      creator: 'Focus Music',
      description: 'Музыкальный фон для концентрации на работе.',
      category: 'Песни',
      durationLabel: 'Неизвестно',
      icon: Icons.headphones,
      color: Color(0xFF7DB9FF),
      url: '',
    ),
    _AudioTrack(
      id: 'audio_3',
      title: 'Спокойствие и дыхание',
      creator: 'Практика осознанности',
      description: 'Спокойная аудиопрактика для отдыха и восстановления.',
      category: 'Медитации',
      durationLabel: '8 мин',
      icon: Icons.spa_outlined,
      color: Color(0xFFB69CFF),
      url: '',
    ),
    _AudioTrack(
      id: 'audio_4',
      title: 'Сила привычек',
      creator: 'Аудиоурок',
      description: 'Как постепенно создавать полезные привычки.',
      category: 'Аудиоуроки',
      durationLabel: '15 мин',
      icon: Icons.track_changes,
      color: Color(0xFF6ABE77),
      url: '',
    ),
    _AudioTrack(
      id: 'audio_5',
      title: 'Энергия для тренировки',
      creator: 'Workout Music',
      description: 'Музыка для тренировок и активной работы.',
      category: 'Песни',
      durationLabel: 'Неизвестно',
      icon: Icons.bolt,
      color: Color(0xFFFF9B85),
      url: '',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _playerSubscription = _player.playerStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state.playing;
        _isLoadingAudio =
            state.processingState == ProcessingState.loading ||
                state.processingState == ProcessingState.buffering;
      });

      if (state.processingState == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _playerSubscription.cancel();
    _player.dispose();
    super.dispose();
  }

  List<_AudioTrack> get _filteredTracks {
    final query = _searchQuery.toLowerCase();

    return _tracks.where((track) {
      final categoryMatches = _selectedCategory == 'Все' ||
          track.category == _selectedCategory;

      final searchMatches =
          track.title.toLowerCase().contains(query) ||
              track.creator.toLowerCase().contains(query) ||
              track.description.toLowerCase().contains(query);

      return categoryMatches && searchMatches;
    }).toList();
  }

  int get _lessonCount =>
      _tracks.where((track) => track.category == 'Аудиоуроки').length;

  int get _songCount =>
      _tracks.where((track) => track.category == 'Песни').length;

  String _formatDuration(Duration? duration) {
    if (duration == null) return '—';

    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds =
    (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  Future<void> _playTrack(_AudioTrack track) async {
    if (track.url.trim().isEmpty) {
      _showMessage(
        'Для этого примера ещё не добавлена аудиоссылка. '
            'Добавь своё аудио через кнопку «Добавить аудио».',
      );
      return;
    }

    final uri = Uri.tryParse(track.url);

    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      _showMessage('Некорректная ссылка на аудиофайл.');
      return;
    }

    try {
      if (_currentTrack?.id == track.id) {
        if (_player.playing) {
          await _player.pause();
        } else {
          unawaited(_player.play());
        }
        return;
      }

      setState(() {
        _currentTrack = track;
        _audioError = null;
      });

      await _player.setUrl(track.url);

      if (!mounted) return;

      unawaited(_player.play());
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _audioError = 'Не удалось загрузить аудио.';
        _isPlaying = false;
      });
    }
  }

  Future<void> _seekAudio(double seconds) async {
    await _player.seek(
      Duration(seconds: seconds.round()),
    );
  }

  Future<void> _addAudio() async {
    final track = await showDialog<_AudioTrack>(
      context: context,
      builder: (context) => const _AddAudioDialog(),
    );

    if (track == null || !mounted) return;

    setState(() {
      _tracks.insert(0, track);
      _selectedCategory = track.category;
      _searchQuery = '';
      _searchController.clear();
    });

    _showMessage('Аудиозапись добавлена');
  }

  Future<void> _deleteTrack(_AudioTrack track) async {
    if (_currentTrack?.id == track.id) {
      await _player.stop();

      if (!mounted) return;

      setState(() {
        _currentTrack = null;
        _isPlaying = false;
      });
    }

    setState(() {
      _tracks.remove(track);
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tracks = _filteredTracks;

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 1),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAudio,
        backgroundColor: MainStyle.actionColor,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'Добавить аудио',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            const Text(
              'AUDIO LIBRARY',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 14),

            const Text(
              'Слушай и развивайся.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Аудиоуроки, музыка для концентрации '
                  'и время для восстановления.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 24),

            // Статистика
            Row(
              children: [
                Expanded(
                  child: _AudioStat(
                    icon: Icons.school_outlined,
                    title: 'Аудиоуроки',
                    value: '$_lessonCount',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AudioStat(
                    icon: Icons.music_note,
                    title: 'Музыка',
                    value: '$_songCount',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            // Текущий аудиоплеер
            if (_currentTrack != null) ...[
              _buildPlayer(_currentTrack!),
              const SizedBox(height: 26),
            ],

            // Поиск
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Найти аудио...',
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

            const SizedBox(height: 22),

            const Text(
              'КАТЕГОРИИ',
              style: AppTextStyles.label,
            ),

            const SizedBox(height: 12),

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
                        setState(() => _selectedCategory = category);
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
                        color: selected ? Colors.black : Colors.white70,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 26),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'МОЯ АУДИОТЕКА',
                    style: AppTextStyles.middleGreenText,
                  ),
                ),
                Text(
                  '${tracks.length} записей',
                  style: AppTextStyles.hintText,
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (tracks.isEmpty)
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
                      Icons.headphones_outlined,
                      size: 40,
                      color: Colors.white38,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Аудиозаписи не найдены',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...tracks.map(
                    (track) => _AudioTrackCard(
                  track: track,
                  isCurrent: _currentTrack?.id == track.id,
                  isPlaying:
                  _currentTrack?.id == track.id && _isPlaying,
                  onPlay: () => _playTrack(track),
                  onFavorite: () {
                    setState(() {
                      track.isFavorite = !track.isFavorite;
                    });
                  },
                  onDelete: () => _deleteTrack(track),
                ),
              ),

            const SizedBox(height: 20),

            Text(
              'Создавай свою библиотеку и выбирай '
                  'подходящий звук для каждого занятия.',
              textAlign: TextAlign.center,
              style: AppTextStyles.hintText.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer(_AudioTrack track) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MainStyle.actionColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'СЕЙЧАС ИГРАЕТ',
            style: AppTextStyles.miniGreenText,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: track.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  track.icon,
                  color: track.color,
                  size: 29,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.WhiteHeading.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      track.creator,
                      style: AppTextStyles.hintText,
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: _isLoadingAudio
                    ? null
                    : () => _playTrack(track),
                icon: _isLoadingAudio
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: MainStyle.actionColor,
                  ),
                )
                    : Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: MainStyle.actionColor,
                  size: 42,
                ),
              ),
            ],
          ),

          if (_audioError != null) ...[
            const SizedBox(height: 10),
            Text(
              _audioError!,
              style: AppTextStyles.bodyRed,
            ),
          ],

          const SizedBox(height: 10),

          StreamBuilder<Duration>(
            stream: _player.positionStream,
            initialData: Duration.zero,
            builder: (context, positionSnapshot) {
              final position =
                  positionSnapshot.data ?? Duration.zero;

              return StreamBuilder<Duration?>(
                stream: _player.durationStream,
                builder: (context, durationSnapshot) {
                  final duration = durationSnapshot.data ??
                      Duration.zero;

                  final maxSeconds =
                  duration.inSeconds.toDouble();

                  final currentSeconds =
                  position.inSeconds.toDouble().clamp(
                    0.0,
                    maxSeconds > 0 ? maxSeconds : 1.0,
                  );

                  return Column(
                    children: [
                      Slider(
                        value: currentSeconds,
                        min: 0,
                        max: maxSeconds > 0 ? maxSeconds : 1,
                        onChanged: duration == Duration.zero
                            ? null
                            : (value) => _seekAudio(value),
                        activeColor: MainStyle.actionColor,
                        inactiveColor: Colors.white12,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _formatDuration(position),
                              style: AppTextStyles.hintText,
                            ),
                            const Spacer(),
                            Text(
                              _formatDuration(duration),
                              style: AppTextStyles.hintText,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================
// МОДЕЛЬ АУДИОЗАПИСИ
// =====================================================

class _AudioTrack {
  final String id;
  final String title;
  final String creator;
  final String description;
  final String category;
  final String durationLabel;
  final IconData icon;
  final Color color;
  final String url;

  bool isFavorite;

  _AudioTrack({
    required this.id,
    required this.title,
    required this.creator,
    required this.description,
    required this.category,
    required this.durationLabel,
    required this.icon,
    required this.color,
    required this.url,
    this.isFavorite = false,
  });
}

// =====================================================
// КАРТОЧКА АУДИОЗАПИСИ
// =====================================================

class _AudioTrackCard extends StatelessWidget {
  final _AudioTrack track;
  final bool isCurrent;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;

  const _AudioTrackCard({
    required this.track,
    required this.isCurrent,
    required this.isPlaying,
    required this.onPlay,
    required this.onFavorite,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent
              ? MainStyle.actionColor
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onPlay,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: track.color.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: track.color,
                size: 32,
              ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: InkWell(
              onTap: onPlay,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.category.toUpperCase(),
                    style: AppTextStyles.miniGreenText.copyWith(
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    track.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.WhiteHeading.copyWith(
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    track.creator,
                    style: AppTextStyles.hintText,
                  ),

                  const SizedBox(height: 7),

                  Text(
                    track.durationLabel,
                    style: AppTextStyles.hintText.copyWith(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 4),

          Column(
            children: [
              IconButton(
                tooltip: track.isFavorite
                    ? 'Убрать из избранного'
                    : 'В избранное',
                onPressed: onFavorite,
                icon: Icon(
                  track.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: track.isFavorite
                      ? MainStyle.dangerColor
                      : Colors.white54,
                  size: 21,
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
                      'Удалить',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================
// СТАТИСТИКА
// =====================================================

class _AudioStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _AudioStat({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: MainStyle.actionColor,
            size: 24,
          ),

          const SizedBox(height: 12),

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
// ДИАЛОГ ДОБАВЛЕНИЯ АУДИО
// =====================================================

class _AddAudioDialog extends StatefulWidget {
  const _AddAudioDialog();

  @override
  State<_AddAudioDialog> createState() => _AddAudioDialogState();
}

class _AddAudioDialogState extends State<_AddAudioDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _creatorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _urlController = TextEditingController();

  String _category = 'Аудиоуроки';

  static const _categories = [
    'Аудиоуроки',
    'Песни',
    'Медитации',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _creatorController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Добавь ссылку на аудиофайл';
    }

    final uri = Uri.tryParse(value.trim());

    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      return 'Введи корректную ссылку';
    }

    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final colors = <String, Color>{
      'Аудиоуроки': MainStyle.actionColor,
      'Песни': const Color(0xFF7DB9FF),
      'Медитации': const Color(0xFFB69CFF),
    };

    final icons = <String, IconData>{
      'Аудиоуроки': Icons.school_outlined,
      'Песни': Icons.music_note,
      'Медитации': Icons.spa_outlined,
    };

    final track = _AudioTrack(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      creator: _creatorController.text.trim().isEmpty
          ? 'Без указания автора'
          : _creatorController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? 'Описание не добавлено.'
          : _descriptionController.text.trim(),
      category: _category,
      durationLabel: _durationController.text.trim().isEmpty
          ? 'Неизвестно'
          : _durationController.text.trim(),
      icon: icons[_category]!,
      color: colors[_category]!,
      url: _urlController.text.trim(),
    );

    Navigator.of(context).pop(track);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF151A15),
      title: const Text(
        'Добавить аудио',
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
                _field(
                  controller: _titleController,
                  label: 'Название',
                  requiredField: true,
                ),

                const SizedBox(height: 12),

                _field(
                  controller: _creatorController,
                  label: 'Автор или исполнитель',
                ),

                const SizedBox(height: 12),

                _field(
                  controller: _descriptionController,
                  label: 'Описание',
                  maxLines: 2,
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _category,
                  dropdownColor: const Color(0xFF202522),
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Категория'),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _category = value);
                    }
                  },
                ),

                const SizedBox(height: 12),

                _field(
                  controller: _durationController,
                  label: 'Длительность, например 12 мин',
                ),

                const SizedBox(height: 12),

                _field(
                  controller: _urlController,
                  label: 'Прямая ссылка на аудиофайл',
                  keyboardType: TextInputType.url,
                  requiredField: true,
                  validator: _validateUrl,
                ),

                const SizedBox(height: 8),

                Text(
                  'Нужна прямая ссылка на доступный аудиофайл. '
                      'Ссылка на страницу YouTube обычно не подойдёт.',
                  style: AppTextStyles.hintText.copyWith(
                    fontSize: 11,
                    height: 1.5,
                  ),
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
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}

// =====================================================
// СТИЛЬ ПОЛЕЙ
// =====================================================

Widget _field({
  required TextEditingController controller,
  required String label,
  bool requiredField = false,
  int maxLines = 1,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: Colors.white),
    maxLines: maxLines,
    keyboardType: keyboardType,
    decoration: _decoration(label),
    validator: validator ??
            (value) {
          if (requiredField &&
              (value == null || value.trim().isEmpty)) {
            return 'Заполни это поле';
          }
          return null;
        },
  );
}

InputDecoration _decoration(String label) {
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