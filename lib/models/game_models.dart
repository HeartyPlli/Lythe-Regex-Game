part of '../main.dart';

enum Difficulty { easy, medium, hard, extreme }

enum GameScreen {
  loading,
  menu,
  playerSetup,
  levels,
  play,
  leaderboard,
  howToPlay,
  result,
}

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
    this.id,
    this.levelId,
    this.points = 10,
  });

  final Difficulty difficulty;
  final String pattern;
  final String hint;
  final String example;
  final int? id;
  final int? levelId;
  final int points;
}

class LeaderboardEntry {
  const LeaderboardEntry(
    this.rank,
    this.player,
    this.score,
    this.level,
    this.asset, {
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.timedOutAnswers = 0,
  });

  final int rank;
  final String player;
  final int score;
  final String level;
  final String asset;
  final int correctAnswers;
  final int wrongAnswers;
  final int timedOutAnswers;
}
