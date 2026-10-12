import 'package:discipline/presintation/style/main_style.dart';
import 'package:flutter/material.dart';

class FireWidget extends StatelessWidget {
  final int firePoint;
  const FireWidget({super.key, required this.firePoint});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MainStyle.warningColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(4),
        child: Row(
          children: [
            Icon(Icons.local_fire_department_outlined),
            Text('$firePoint', style: TextStyle(color: Colors.black,))
          ],
        ),
      ),
    );
  }
}
