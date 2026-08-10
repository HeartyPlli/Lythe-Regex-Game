part of '../main.dart';

//=========================================================================
// Utility is here for turning difficulty to text label.
//=========================================================================
String difficultyLabel(Difficulty difficulty) {
  return switch (difficulty) {
    Difficulty.easy => 'EASY',
    Difficulty.medium => 'MEDIUM',
    Difficulty.hard => 'HARD',
    Difficulty.extreme => 'EXTREME',
  };
}
