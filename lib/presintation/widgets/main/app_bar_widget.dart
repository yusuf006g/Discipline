import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MainStyle.backgrountColor,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          Image.asset(
            'assets/images/mini_logo.png',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 10),
          const Text(
            'Discipline',
            style: AppTextStyles.heading,
          ),
        ],
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: MainStyle.actionColor,
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: MainStyle.actionColor,
        ),
      ),
    );
  }
}