CREATE DATABASE IF NOT EXISTS game_database
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE game_database;

CREATE TABLE IF NOT EXISTS players (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_players_username (username),
  KEY idx_players_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS levels (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  level_name VARCHAR(80) NOT NULL,
  difficulty ENUM('easy', 'medium', 'hard', 'extreme') NOT NULL,
  time_limit SMALLINT UNSIGNED NOT NULL,
  UNIQUE KEY uq_levels_difficulty (difficulty),
  KEY idx_levels_difficulty (difficulty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS questions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  level_id INT UNSIGNED NOT NULL,
  question VARCHAR(255) NOT NULL,
  answer VARCHAR(255) NOT NULL,
  points SMALLINT UNSIGNED NOT NULL DEFAULT 10,
  CONSTRAINT fk_questions_level
    FOREIGN KEY (level_id) REFERENCES levels(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  UNIQUE KEY uq_questions_level_question (level_id, question),
  KEY idx_questions_level_id (level_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS game_results (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  player_id INT UNSIGNED NOT NULL,
  level_id INT UNSIGNED NOT NULL,
  score INT UNSIGNED NOT NULL,
  correct_answers SMALLINT UNSIGNED NOT NULL,
  wrong_answers SMALLINT UNSIGNED NOT NULL,
  time_used SMALLINT UNSIGNED NOT NULL,
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
  KEY idx_game_results_level_id (level_id),
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

INSERT IGNORE INTO questions (level_id, question, answer, points) VALUES
  (1, 'One or more lowercase letters.', '^[a-z]+$', 10),
  (1, 'Only numbers are allowed.', '^[0-9]+$', 10),
  (1, 'Match the exact word cat.', '^cat$', 10),
  (1, 'Use uppercase letters only.', '^[A-Z]+$', 10),
  (1, 'Any three characters.', '^.{3}$', 10),
  (1, 'Exactly four lowercase letters.', '^[a-z]{4}$', 10),
  (1, 'h followed by one or more i letters.', '^hi+$', 10),
  (1, 'A single lowercase vowel.', '^[aeiou]$', 10),
  (1, 'Type bug or bee.', '^(bug|bee)$', 10),
  (1, 'One lowercase letter, then one digit.', '^[a-z][0-9]$', 10),
  (2, 'Lowercase word with 3 to 6 letters.', '^[a-z]{3,6}$', 10),
  (2, 'Capitalized word.', '^[A-Z][a-z]+$', 10),
  (2, 'Two digits, dash, two digits.', '^\\d{2}-\\d{2}$', 10),
  (2, 'mush or mushroom.', '^mush(room)?$', 10),
  (2, 'Lowercase word, @, lowercase word.', '^[a-z]+@[a-z]+$', 10),
  (2, 'Repeat ha from 2 to 4 times.', '^(ha){2,4}$', 10),
  (2, 'Lowercase consonants only.', '^[bcdfghjklmnpqrstvwxyz]+$', 10),
  (2, 'Hex color with # and six uppercase hex digits.', '^#[0-9A-F]{6}$', 10),
  (3, 'At least 5 letters/digits and includes a number.', '^(?=.*[0-9])[A-Za-z0-9]{5,}$', 10),
  (3, 'Filename ending in .png or .jpg.', '^\\w+\\.(png|jpg)$', 10),
  (3, 'Color, dash, plant word.', '^(red|pink|green)-(leaf|flower)$', 10),
  (3, 'Date shaped like yyyy/mm/dd.', '^\\d{4}/\\d{2}/\\d{2}$', 10),
  (3, 'Lowercase word, dash, uppercase word.', '^[a-z]{2,}-[A-Z]{2,}$', 10),
  (4, '8+ letters/digits with at least one uppercase and one number.', '^(?=.{8,}$)(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]+$', 10);
