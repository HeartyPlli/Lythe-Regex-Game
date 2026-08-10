part of '../main.dart';

String difficultyLabel(Difficulty difficulty) {
  return switch (difficulty) {
    Difficulty.easy => 'EASY',
    Difficulty.medium => 'MEDIUM',
    Difficulty.hard => 'HARD',
    Difficulty.extreme => 'EXTREME',
  };
}
