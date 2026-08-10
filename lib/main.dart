import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

part 'models/game_models.dart';
part 'game/lythe_game.dart';
part 'screens/loading_screen.dart';
part 'screens/home_screen.dart';
part 'screens/level_select_screen.dart';
part 'screens/play_screen.dart';
part 'screens/leaderboard_screen.dart';
part 'screens/how_to_play_screen.dart';
part 'screens/result_screen.dart';
part 'widgets/background.dart';
part 'widgets/decorative_border.dart';
part 'widgets/emote_layer.dart';
part 'widgets/popups.dart';
part 'widgets/buttons.dart';
part 'widgets/panels.dart';
part 'widgets/game_components.dart';
part 'widgets/animation_helpers.dart';
part 'widgets/confetti.dart';
part 'utils/difficulty_label.dart';
part 'theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lythe Regex Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffec6680),
          brightness: Brightness.light,
        ),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const LytheGame(),
    );
  }
}
