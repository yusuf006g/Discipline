
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'Все';

  final List<String> _categories = [
    'Все',
    'Дисциплина',
    'Психология',
    'Продуктивность',
    'Бизнес',
    'Саморазвитие',
    'Образование',
  ];

  final List<_Book> _books = [
    _Book(
      title: 'Атомные привычки',
      author: 'Джеймс Клир',
      description:
      'Как небольшие привычки помогают добиваться больших результатов.',
      category: 'Дисциплина',
      pages: 320,
      icon: Icons.track_changes,
      color: Color(0xFFCCE956),
    ),
    _Book(
      title: 'Глубокая работа',
      author: 'Кэл Ньюпорт',
      description:
      'Как концентрироваться на важных задачах и меньше отвлекаться.',
      category: 'Продуктивность',
      pages: 304,
      icon: Icons.center_focus_strong,
      color: Color(0xFF7DB9FF),
    ),
    _Book(
      title: 'Эссенциализм',
      author: 'Грег Маккеон',
      description:
      'Как выделять главное и избавляться от лишнего.',
      category: 'Саморазвитие',
      pages: 272,
      icon: Icons.filter_list,
      color: Color(0xFFDFAE54),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Book> get _filteredBooks {
    final query = _searchQuery.toLowerCase();

    return _books.where((book) {
      final matchesCategory = _selectedCategory == 'Все' ||
          book.category == _selectedCategory;

      final matchesSearch =
          book.title.toLowerCase().contains(query) ||
              book.author.toLowerCase().contains(query) ||
              book.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get _readingCount =>
      _books.where((book) => book.progress > 0 && book.progress < 1).length;

  Future<void> _addBook() async {
    final book = await showDialog<_Book>(
      context: context,
      builder: (context) => _AddBookDialog(
        categories: _categories.where((e) => e != 'Все').toList(),
      ),
    );

    if (book == null || !mounted) return;

    setState(() {
      _books.insert(0, book);
      _selectedCategory = book.category;
      _searchQuery = '';
      _searchController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Книга добавлена в библиотеку'),
      ),
    );
  }

  Future<void> _openBook(_Book book) async {
    if (book.url == null || book.url!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Для этой книги ссылка не добавлена.',
          ),
        ),
      );
      return;
    }

    final uri = Uri.tryParse(book.url!);

    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Некорректная ссылка на книгу'),
        ),
      );
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не удалось открыть книгу'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось открыть ссылку'),
        ),
      );
    }
  }

  void _changeProgress(_Book book) {
    setState(() {
      if (book.progress >= 1) {
        book.progress = 0;
      } else {
        book.progress = (book.progress + 0.1).clamp(0.0, 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final books = _filteredBooks;

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 1),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addBook,
        backgroundColor: MainStyle.actionColor,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'Добавить книгу',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            const Text(
              'DISCIPLINE LIBRARY',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 12),

            const Text(
              'Развивай свой разум.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Собирай полезные книги, выбирай категории '
                  'и отслеживай свой прогресс.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 24),

            // Статистика библиотеки
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.menu_book_outlined,
                    title: 'Всего книг',
                    value: '${_books.length}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.auto_stories_outlined,
                    title: 'Читаю сейчас',
                    value: '$_readingCount',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

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
                hintText: 'Найти книгу или автора...',
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

            const SizedBox(height: 24),

            const Text(
              'КАТЕГОРИИ',
              style: AppTextStyles.label,
            ),

            const SizedBox(height: 14),

            // Выбор категории
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

            const SizedBox(height: 28),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'МОЯ БИБЛИОТЕКА',
                    style: AppTextStyles.middleGreenText,
                  ),
                ),
                Text(
                  '${books.length} книг',
                  style: AppTextStyles.hintText,
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (books.isEmpty)
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
                      Icons.menu_book_outlined,
                      color: Colors.white38,
                      size: 40,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Книги не найдены',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Попробуй другую категорию или добавь книгу.',
                      style: AppTextStyles.hintText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            ...books.map(
                  (book) => _BookCard(
                book: book,
                onOpen: () => _openBook(book),
                onProgressChanged: () => _changeProgress(book),
                onDelete: () {
                  setState(() {
                    _books.remove(book);
                  });
                },
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
// МОДЕЛЬ КНИГИ
// =====================================================

class _Book {
  final String title;
  final String author;
  final String description;
  final String category;
  final int pages;
  final IconData icon;
  final Color color;
  final String? url;

  double progress;

  _Book({
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.pages,
    required this.icon,
    required this.color,
    this.url,
    this.progress = 0,
  });
}

// =====================================================
// КАРТОЧКА КНИГИ
// =====================================================

class _BookCard extends StatelessWidget {
  final _Book book;
  final VoidCallback onOpen;
  final VoidCallback onProgressChanged;
  final VoidCallback onDelete;

  const _BookCard({
    required this.book,
    required this.onOpen,
    required this.onProgressChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final completed = book.progress >= 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: completed
              ? MainStyle.successColor
              : Colors.white12,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 82,
                height: 112,
                decoration: BoxDecoration(
                  color: book.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: book.color.withAlpha(100),
                  ),
                ),
                child: Icon(
                  book.icon,
                  color: book.color,
                  size: 38,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.category.toUpperCase(),
                      style: AppTextStyles.miniGreenText.copyWith(
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      book.title,
                      style: AppTextStyles.WhiteHeading.copyWith(
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      book.author,
                      style: AppTextStyles.hintText,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      book.description,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${book.pages} страниц',
                      style: AppTextStyles.hintText.copyWith(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white54,
                ),
                color: const Color(0xFF202522),
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Удалить книгу',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (book.progress > 0) ...[
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: book.progress,
                      minHeight: 5,
                      backgroundColor: Colors.white12,
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(
                        MainStyle.actionColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  '${(book.progress * 100).round()}%',
                  style: AppTextStyles.miniGreenText.copyWith(
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onProgressChanged,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: MainStyle.actionColor,
                    side: const BorderSide(
                      color: MainStyle.actionColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    completed
                        ? Icons.restart_alt
                        : Icons.menu_book_outlined,
                    size: 18,
                  ),
                  label: Text(
                    completed
                        ? 'Начать заново'
                        : 'Обновить прогресс',
                  ),
                ),
              ),

              if (book.url != null && book.url!.isNotEmpty) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Открыть книгу',
                  onPressed: onOpen,
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: MainStyle.actionColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ДИАЛОГ ДОБАВЛЕНИЯ КНИГИ
// =====================================================

class _AddBookDialog extends StatefulWidget {
  final List<String> categories;

  const _AddBookDialog({
    required this.categories,
  });

  @override
  State<_AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<_AddBookDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pagesController = TextEditingController();
  final _urlController = TextEditingController();

  late String _category = widget.categories.first;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _pagesController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;

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

    final pages = int.tryParse(_pagesController.text.trim());

    final book = _Book(
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? 'Описание не добавлено.'
          : _descriptionController.text.trim(),
      category: _category,
      pages: pages!,
      url: _urlController.text.trim().isEmpty
          ? null
          : _urlController.text.trim(),
      icon: _categoryIcon(_category),
      color: _categoryColor(_category),
    );

    Navigator.of(context).pop(book);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF151A15),
      title: const Text(
        'Добавить книгу',
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
                _formField(
                  controller: _titleController,
                  label: 'Название книги',
                  requiredField: true,
                ),

                const SizedBox(height: 12),

                _formField(
                  controller: _authorController,
                  label: 'Автор',
                  requiredField: true,
                ),

                const SizedBox(height: 12),

                _formField(
                  controller: _descriptionController,
                  label: 'Описание',
                  maxLines: 3,
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _category,
                  dropdownColor: const Color(0xFF202522),
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Категория'),
                  items: widget.categories.map((category) {
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

                _formField(
                  controller: _pagesController,
                  label: 'Количество страниц',
                  keyboardType: TextInputType.number,
                  requiredField: true,
                  validator: (value) {
                    final pages = int.tryParse(value?.trim() ?? '');

                    if (pages == null || pages < 1) {
                      return 'Введи количество страниц';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                _formField(
                  controller: _urlController,
                  label: 'Ссылка на книгу (необязательно)',
                  keyboardType: TextInputType.url,
                  validator: _validateUrl,
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

Widget _formField({
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
    decoration: _inputDecoration(label),
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

IconData _categoryIcon(String category) {
  switch (category) {
    case 'Дисциплина':
      return Icons.track_changes;
    case 'Психология':
      return Icons.psychology_outlined;
    case 'Продуктивность':
      return Icons.center_focus_strong;
    case 'Бизнес':
      return Icons.trending_up;
    case 'Образование':
      return Icons.school_outlined;
    default:
      return Icons.menu_book_outlined;
  }
}

Color _categoryColor(String category) {
  switch (category) {
    case 'Дисциплина':
      return const Color(0xFFCCE956);
    case 'Психология':
      return const Color(0xFFFF9B85);
    case 'Продуктивность':
      return const Color(0xFF7DB9FF);
    case 'Бизнес':
      return const Color(0xFFDFAE54);
    case 'Образование':
      return const Color(0xFFB69CFF);
    default:
      return MainStyle.actionColor;
  }
}

// =====================================================
// СТАТИСТИКА
// =====================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
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