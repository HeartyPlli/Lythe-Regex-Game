part of '../main.dart';

//=========================================================================
// Ui colors is here for all app color theme.
//=========================================================================
class AppColors {
  static const pink = Color(0xffec6680);
  static const palePink = Color(0xffffccd5);
  static const brown = Color(0xff6f3b20);
  static const lightBrown = Color(0xffc78a55);
  static const green = Color(0xff6c9a33);
  static const panel = Color(0xffffe6c4);
  static const cream = Color(0xfffff6e9);
  static const peachStroke = Color(0xffd99a76);
  static const gold = Color(0xffffb633);
  static const plum = Color(0xff5a3554);

  static Color difficulty(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.easy => green,
      Difficulty.medium => const Color(0xffe99821),
      Difficulty.hard => const Color(0xffd84d4d),
      Difficulty.extreme => const Color(0xff8d4ca4),
    };
  }
}
