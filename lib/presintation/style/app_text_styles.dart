import 'package:flutter/material.dart';

import 'main_style.dart';

class AppTextStyles {
  // Крупный / 32
  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.08,
    color: MainStyle.TextColor,
  );

  static const TextStyle titleText = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 1.08,
    color: MainStyle.actionColor,
  );

  // Заголовок / 20
  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.20,
    color: MainStyle.actionColor,
  );


  // Заголовок / 20
  static const TextStyle sccessHeading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.20,
    color: MainStyle.successColor,
  );

  static const TextStyle WhiteHeading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.20,
    color: MainStyle.TextColor,
  );

  // Основной текст / 14
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: MainStyle.TextColor,
  );

  static const TextStyle bodyRed = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: MainStyle.dangerColor,
  );

  // Метка / 10
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.20,
    letterSpacing: 2.0,
    color: Colors.grey
  );

  static const TextStyle hintText = TextStyle(
    color: Colors.white38,
    fontSize: 14,
  );

  static const TextStyle miniGreenText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.20,
    letterSpacing: 2.0,
    color: MainStyle.actionColor,
  );

  static const TextStyle middleText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.20,
    letterSpacing: 2.0,
    color: MainStyle.TextColor,
  );

  static const TextStyle middleGreenText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.20,
    letterSpacing: 2.0,
    color: MainStyle.actionColor,
  );

  // Вторичный текст
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: MainStyle.TextColor,
  );
  static const ButtonTextStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black);
}