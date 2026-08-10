part of '../main.dart';

enum Difficulty { easy, medium, hard, extreme }

enum GameScreen { loading, menu, levels, play, leaderboard, howToPlay, result }

enum EmoteState {
  none,
  loading,
  incorrect,
  timeOut,
  failed,
  extremeHard,
  success,
  logout,
}

class RegexQuestion {
  const RegexQuestion({
    required this.difficulty,
    required this.pattern,
    required this.hint,
    required this.example,
  });

  final Difficulty difficulty;
  final String pattern;
  final String hint;
  final String example;
}

class LeaderboardEntry {
  const LeaderboardEntry(
    this.rank,
    this.player,
    this.score,
    this.level,
    this.asset,
  );

  final int rank;
  final String player;
  final int score;
  final String level;
  final String asset;
}
