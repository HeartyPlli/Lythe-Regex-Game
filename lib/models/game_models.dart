part of '../main.dart';

//=========================================================================
// Data model is here for game screen question and leaderboard.
//=========================================================================
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

//=========================================================================
// This enum is about EmoteState choices.
//=========================================================================
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

//=========================================================================
// This class is about RegexQuestion thing.
//=========================================================================
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

//=========================================================================
// This class is about LeaderboardEntry thing.
//=========================================================================
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
