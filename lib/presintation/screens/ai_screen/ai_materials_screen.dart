
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class AiMaterialsScreen extends StatefulWidget {
  const AiMaterialsScreen({super.key});

  @override
  State<AiMaterialsScreen> createState() =>
      _AiMaterialsScreenState();
}

class _AiMaterialsScreenState extends State<AiMaterialsScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'Все';

  final List<String> _categories = const [
    'Все',
    'Документация',
    'AI-модели',
    'Инструменты',
    'Обучение',
    'Промпты',
  ];

  final List<_AiMaterial> _materials = [
    _AiMaterial(
      title: 'Hugging Face',
      description:
      'Библиотека моделей искусственного интеллекта, '
          'датасеты и документация.',
      category: 'AI-модели',
      url: 'https://huggingface.co/',
      icon: Icons.hub_outlined,
      color: Color(0xFFFFC857),
    ),
    _AiMaterial(
      title: 'Gradio Documentation',
      description:
      'Документация для создания интерфейсов '
          'машинного обучения и AI-приложений.',
      category: 'Документация',
      url: 'https://www.gradio.app/docs',
      icon: Icons.menu_book_outlined,
      color: Color(0xFFCCE956),
    ),
    _AiMaterial(
      title: 'GitHub',
      description:
      'Исходный код, готовые проекты, примеры '
          'интеграции и библиотеки для AI.',
      category: 'Инструменты',
      url: 'https://github.com/',
      icon: Icons.code,
      color: Color(0xFFB69CFF),
    ),
    _AiMaterial(
      title: 'Prompt Engineering Guide',
      description:
      'Методы составления эффективных запросов '
          'для языковых моделей.',
      category: 'Промпты',
      url: 'https://www.promptingguide.ai/',
      icon: Icons.edit_note,
      color: Color(0xFF7DB9FF),
    ),
    _AiMaterial(
      title: 'Flutter Documentation',
      description:
      'Руководства по разработке мобильных приложений '
          'и подключению AI-сервисов.',
      category: 'Обучение',
      url: 'https://docs.flutter.dev/',
      icon: Icons.phone_android,
      color: Color(0xFF6ABE77),
    ),
    _AiMaterial(
      title: 'OpenAI API Documentation',
      description:
      'Документация по API, моделям и интеграции '
          'языковых моделей в приложения.',
      category: 'Документация',
      url: 'https://platform.openai.com/docs',
      icon: Icons.api,
      color: Color(0xFFCCE956),
    ),
  ];

  List<_AiMaterial> get _filteredMaterials {
    final query = _searchQuery.toLowerCase();

    return _materials.where((material) {
      final matchesCategory = _selectedCategory == 'Все' ||
          material.category == _selectedCategory;

      final matchesSearch =
          material.title.toLowerCase().contains(query) ||
              material.description.toLowerCase().contains(query) ||
              material.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openMaterial(_AiMaterial material) async {
    final uri = Uri.tryParse(material.url);

    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      _showMessage('Некорректная ссылка');
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        _showMessage('Не удалось открыть ссылку');
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Ошибка при открытии ссылки');
      }
    }
  }

  Future<void> _addMaterial() async {
    final material = await showDialog<_AiMaterial>(
      context: context,
      builder: (context) => _AddMaterialDialog(
        categories: _categories.where((e) => e != 'Все').toList(),
      ),
    );

    if (material == null || !mounted) return;

    setState(() {
      _materials.insert(0, material);
      _selectedCategory = material.category;
      _searchQuery = '';
      _searchController.clear();
    });

    _showMessage('Материал добавлен');
  }

  Future<void> _copyLink(_AiMaterial material) async {
    await Clipboard.setData(
      ClipboardData(text: material.url),
    );

    if (!mounted) return;
    _showMessage('Ссылка скопирована');
  }

  Future<void> _deleteMaterial(_AiMaterial material) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF151A15),
        title: const Text(
          'Удалить материал?',
          style: AppTextStyles.WhiteHeading,
        ),
        content: Text(
          '«${material.title}» будет удалён из библиотеки.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Отмена',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Удалить',
              style: TextStyle(color: MainStyle.dangerColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _materials.remove(material);
    });

    _showMessage('Материал удалён');
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final materials = _filteredMaterials;

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 3),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMaterial,
        backgroundColor: MainStyle.actionColor,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'Добавить материал',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            const Text(
              'AI RESOURCES',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 14),

            const Text(
              'Расширяй возможности AI.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Собирай полезную документацию, модели, '
                  'инструменты и обучающие материалы '
                  'в одной библиотеке.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 24),

            // Информационная карточка
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: MainStyle.actionColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: MainStyle.actionColor,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Библиотека AI',
                          style: AppTextStyles.WhiteHeading,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${_materials.length} материалов · '
                              '$_selectedCategory',
                          style: AppTextStyles.hintText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

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
                hintText: 'Найти материал...',
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

            const SizedBox(height: 24),

            const Text(
              'КАТЕГОРИИ',
              style: AppTextStyles.label,
            ),

            const SizedBox(height: 12),

            // Категории
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

            const SizedBox(height: 26),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'МАТЕРИАЛЫ',
                    style: AppTextStyles.middleGreenText,
                  ),
                ),
                Text(
                  '${materials.length}',
                  style: AppTextStyles.hintText,
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (materials.isEmpty)
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
                      Icons.search_off,
                      size: 40,
                      color: Colors.white38,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Материалы не найдены',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...materials.map(
                    (material) => _MaterialCard(
                  material: material,
                  onOpen: () => _openMaterial(material),
                  onCopy: () => _copyLink(material),
                  onDelete: () => _deleteMaterial(material),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// МОДЕЛЬ МАТЕРИАЛА
// =====================================================

class _AiMaterial {
  final String title;
  final String description;
  final String category;
  final String url;
  final IconData icon;
  final Color color;

  _AiMaterial({
    required this.title,
    required this.description,
    required this.category,
    required this.url,
    required this.icon,
    required this.color,
  });
}

// =====================================================
// КАРТОЧКА МАТЕРИАЛА
// =====================================================

class _MaterialCard extends StatelessWidget {
  final _AiMaterial material;
  final VoidCallback onOpen;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  const _MaterialCard({
    required this.material,
    required this.onOpen,
    required this.onCopy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 56,
                decoration: BoxDecoration(
                  color: material.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  material.icon,
                  color: material.color,
                  size: 27,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.category.toUpperCase(),
                      style: AppTextStyles.miniGreenText.copyWith(
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      material.title,
                      style: AppTextStyles.WhiteHeading.copyWith(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      material.description,
                      style: AppTextStyles.hintText.copyWith(
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      Uri.tryParse(material.url)?.host ??
                          material.url,
                      style: AppTextStyles.miniGreenText.copyWith(
                        fontSize: 10,
                        letterSpacing: 0,
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
                  if (value == 'copy') onCopy();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'copy',
                    child: Row(
                      children: [
                        Icon(
                          Icons.copy,
                          color: Colors.white70,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Копировать ссылку',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: MainStyle.dangerColor,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Удалить материал',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// ДИАЛОГ ДОБАВЛЕНИЯ МАТЕРИАЛА
// =====================================================

class _AddMaterialDialog extends StatefulWidget {
  final List<String> categories;

  const _AddMaterialDialog({
    required this.categories,
  });

  @override
  State<_AddMaterialDialog> createState() =>
      _AddMaterialDialogState();
}

class _AddMaterialDialogState extends State<_AddMaterialDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();

  late String _category;

  @override
  void initState() {
    super.initState();
    _category = widget.categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введи ссылку';
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

    final material = _AiMaterial(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? 'Описание не добавлено.'
          : _descriptionController.text.trim(),
      category: _category,
      url: _urlController.text.trim(),
      icon: _categoryIcon(_category),
      color: _categoryColor(_category),
    );

    Navigator.of(context).pop(material);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF151A15),
      title: const Text(
        'Новый материал',
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
                  decoration: _inputDecoration('Название'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введи название материала';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Описание'),
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

                TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Ссылка на ресурс'),
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
          child: const Text(
            'Добавить',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

// =====================================================
// СТИЛИ ФОРМЫ И ИКОНКИ КАТЕГОРИЙ
// =====================================================

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
    case 'Документация':
      return Icons.menu_book_outlined;
    case 'AI-модели':
      return Icons.hub_outlined;
    case 'Инструменты':
      return Icons.build_outlined;
    case 'Обучение':
      return Icons.school_outlined;
    case 'Промпты':
      return Icons.edit_note;
    default:
      return Icons.link;
  }
}

Color _categoryColor(String category) {
  switch (category) {
    case 'Документация':
      return const Color(0xFFCCE956);
    case 'AI-модели':
      return const Color(0xFFFFC857);
    case 'Инструменты':
      return const Color(0xFFB69CFF);
    case 'Обучение':
      return const Color(0xFF6ABE77);
    case 'Промпты':
      return const Color(0xFF7DB9FF);
    default:
      return MainStyle.actionColor;
  }
}