-- Run this in phpMyAdmin or MySQL before using the Lythe leaderboard.
-- It saves player names, selected character images, and game scores permanently.

CREATE DATABASE IF NOT EXISTS game_database
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE game_database;

CREATE TABLE IF NOT EXISTS players (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  avatar VARCHAR(80) NOT NULL DEFAULT 'character_01.png',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_players_username (username),
  KEY idx_players_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS levels (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  level_name VARCHAR(80) NOT NULL,
  difficulty ENUM('easy', 'medium', 'hard', 'extreme') NOT NULL,
  time_limit SMALLINT UNSIGNED NOT NULL,
  UNIQUE KEY uq_levels_difficulty (difficulty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS game_results (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  player_id INT UNSIGNED NOT NULL,
  level_id INT UNSIGNED NOT NULL,
  score INT UNSIGNED NOT NULL,
  correct_answers SMALLINT UNSIGNED NOT NULL,
  wrong_answers SMALLINT UNSIGNED NOT NULL,
  timed_out_answers SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  total_questions SMALLINT UNSIGNED NOT NULL DEFAULT 15,
  time_used SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  completed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_game_results_player
    FOREIGN KEY (player_id) REFERENCES players(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_game_results_level
    FOREIGN KEY (level_id) REFERENCES levels(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  KEY idx_game_results_player_id (player_id),
  KEY idx_game_results_score (score),
  KEY idx_game_results_completed_at (completed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO levels (id, level_name, difficulty, time_limit) VALUES
  (1, 'Easy', 'easy', 15),
  (2, 'Medium', 'medium', 15),
  (3, 'Hard', 'hard', 15),
  (4, 'Extreme Final Boss', 'extreme', 20)
ON DUPLICATE KEY UPDATE
  level_name = VALUES(level_name),
  time_limit = VALUES(time_limit);

-- Save or update a player automatically after name/avatar selection.
-- Replace sample values with the app input.
INSERT INTO players (username, avatar)
VALUES ('SamplePlayer', 'character_01.png')
ON DUPLICATE KEY UPDATE avatar = VALUES(avatar);

-- Save a finished game result.
-- Replace these sample values with the app values.
INSERT INTO game_results (
  player_id,
  level_id,
  score,
  correct_answers,
  wrong_answers,
  timed_out_answers,
  total_questions,
  time_used
) VALUES (
  1,
  4,
  100,
  10,
  3,
  2,
  15,
  120
);

-- Display leaderboard with player name and selected character.
SELECT
  p.username,
  p.avatar AS character_image,
  gr.score,
  gr.correct_answers,
  gr.wrong_answers,
  gr.timed_out_answers,
  gr.completed_at
FROM game_results gr
INNER JOIN players p ON p.id = gr.player_id
ORDER BY gr.score DESC, gr.correct_answers DESC, gr.completed_at ASC
LIMIT 10;
