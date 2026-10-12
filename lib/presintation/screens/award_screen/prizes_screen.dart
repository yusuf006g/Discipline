
import 'package:flutter/material.dart';

import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';

class PrizesScreen extends StatefulWidget {
  const PrizesScreen({super.key});

  @override
  State<PrizesScreen> createState() => _PrizesScreenState();
}

class _PrizesScreenState extends State<PrizesScreen> {
  int _xpBalance = 2450;

  String _selectedCategory = 'Все';

  final List<String> _categories = const [
    'Все',
    'Отдых',
    'Обучение',
    'Бонусы',
    'Особенные',
  ];

  final List<_Prize> _prizes = [
    _Prize(
      id: 'rest',
      title: 'Время для отдыха',
      description:
      'Разреши себе 30 минут отдыха без чувства вины.',
      category: 'Отдых',
      cost: 100,
      icon: Icons.weekend_outlined,
      color: Color(0xFF6ABE77),
      tag: 'ПРОСТОЙ ПРИЗ',
    ),
    _Prize(
      id: 'music',
      title: 'Музыкальная пауза',
      description:
      '30 минут любимой музыки после завершения задач.',
      category: 'Отдых',
      cost: 150,
      icon: Icons.headphones,
      color: Color(0xFF7DB9FF),
      tag: 'ОТДЫХ',
    ),
    _Prize(
      id: 'movie',
      title: 'Вечер кино',
      description:
      'Выдели время на любимый фильм после продуктивного дня.',
      category: 'Отдых',
      cost: 300,
      icon: Icons.movie_outlined,
      color: Color(0xFFB69CFF),
      tag: 'ПОПУЛЯРНОЕ',
    ),
    _Prize(
      id: 'book',
      title: 'Новая книга',
      description:
      'Награди себя новой книгой для развития.',
      category: 'Обучение',
      cost: 500,
      icon: Icons.menu_book_outlined,
      color: Color(0xFFCCE956),
      tag: 'РАЗВИТИЕ',
    ),
    _Prize(
      id: 'hobby',
      title: 'Время для хобби',
      description:
      'Посвяти час своему любимому занятию.',
      category: 'Бонусы',
      cost: 350,
      icon: Icons.palette_outlined,
      color: Color(0xFFFF9B85),
      tag: 'БОНУС',
    ),
    _Prize(
      id: 'special',
      title: 'Большая награда',
      description:
      'Особенное вознаграждение за серьёзный результат.',
      category: 'Особенные',
      cost: 1000,
      icon: Icons.workspace_premium_outlined,
      color: Color(0xFFDFAE54),
      tag: 'ОСОБЕННАЯ',
    ),
  ];

  List<_Prize> get _filteredPrizes {
    if (_selectedCategory == 'Все') {
      return _prizes;
    }

    return _prizes
        .where((prize) => prize.category == _selectedCategory)
        .toList();
  }

  int get _claimedCount =>
      _prizes.where((prize) => prize.isClaimed).length;

  Future<void> _claimPrize(_Prize prize) async {
    if (prize.isClaimed) return;

    if (_xpBalance < prize.cost) {
      _showMessage(
        'Не хватает ${prize.cost - _xpBalance} XP для этой награды.',
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151A15),
          title: const Text(
            'Получить награду?',
            style: AppTextStyles.WhiteHeading,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                prize.icon,
                size: 44,
                color: prize.color,
              ),
              const SizedBox(height: 14),
              Text(
                prize.title,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 8),
              Text(
                'Будет списано ${prize.cost} XP.',
                style: AppTextStyles.hintText,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: MainStyle.actionColor,
                foregroundColor: Colors.black,
              ),
              child: const Text('Получить'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _xpBalance -= prize.cost;
      prize.isClaimed = true;
    });

    _showMessage('Награда «${prize.title}» получена!');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prizes = _filteredPrizes;

    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 0),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          children: [
            const Text(
              'REWARD STORE',
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 14),

            const Text(
              'Заслуженные призы.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: 8),

            Text(
              'Работай над собой, зарабатывай XP '
                  'и награждай себя за результат.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 24),

            // Баланс XP
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151A15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: MainStyle.actionColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.bolt,
                        color: MainStyle.actionColor,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'ТВОЙ БАЛАНС',
                        style: AppTextStyles.miniGreenText,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$_xpBalance',
                        style: AppTextStyles.display.copyWith(
                          fontSize: 42,
                          color: MainStyle.actionColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 7),
                        child: Text(
                          'XP',
                          style: AppTextStyles.WhiteHeading,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Получено наград: $_claimedCount',
                    style: AppTextStyles.hintText,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'КАТЕГОРИИ',
              style: AppTextStyles.label,
            ),

            const SizedBox(height: 14),

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
                    'ДОСТУПНЫЕ НАГРАДЫ',
                    style: AppTextStyles.middleGreenText,
                  ),
                ),
                Text(
                  '${prizes.length}',
                  style: AppTextStyles.hintText,
                ),
              ],
            ),

            const SizedBox(height: 16),

            ...prizes.map(
                  (prize) => _PrizeCard(
                prize: prize,
                canAfford: _xpBalance >= prize.cost,
                onClaim: () => _claimPrize(prize),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF151A15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: MainStyle.actionColor,
                    size: 25,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Награждай себя осознанно.',
                          style: AppTextStyles.WhiteHeading,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Призы помогают отмечать прогресс. '
                              'Сначала выполни важные дела, '
                              'а затем наслаждайся заслуженным отдыхом.',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// МОДЕЛЬ ПРИЗА
// =====================================================

class _Prize {
  final String id;
  final String title;
  final String description;
  final String category;
  final int cost;
  final IconData icon;
  final Color color;
  final String tag;

  bool isClaimed;

  _Prize({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.cost,
    required this.icon,
    required this.color,
    required this.tag,
    this.isClaimed = false,
  });
}

// =====================================================
// КАРТОЧКА ПРИЗА
// =====================================================

class _PrizeCard extends StatelessWidget {
  final _Prize prize;
  final bool canAfford;
  final VoidCallback onClaim;

  const _PrizeCard({
    required this.prize,
    required this.canAfford,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final claimed = prize.isClaimed;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF151A15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: claimed
              ? MainStyle.successColor
              : Colors.white12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 62,
                decoration: BoxDecoration(
                  color: prize.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  prize.icon,
                  color: prize.color,
                  size: 30,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prize.tag,
                      style: AppTextStyles.miniGreenText.copyWith(
                        color: prize.color,
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      prize.title,
                      style: AppTextStyles.WhiteHeading.copyWith(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      prize.description,
                      style: AppTextStyles.hintText.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.bolt,
                color: MainStyle.actionColor,
                size: 20,
              ),

              const SizedBox(width: 5),

              Text(
                '${prize.cost} XP',
                style: AppTextStyles.middleGreenText.copyWith(
                  fontSize: 17,
                  letterSpacing: 0,
                ),
              ),

              const Spacer(),

              if (claimed)
                const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: MainStyle.successColor,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Получено',
                      style: TextStyle(
                        color: MainStyle.successColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              else
                ElevatedButton(
                  onPressed: canAfford ? onClaim : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainStyle.actionColor,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white10,
                    disabledForegroundColor: Colors.white38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    canAfford ? 'Получить' : 'Не хватает XP',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}