<?php

declare(strict_types=1);

require_once __DIR__ . '/../../config/response.php';
require_once __DIR__ . '/../../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    send_json(false, 'Method not allowed.', null, 405);
}

$body = read_json_body();
$playerId = require_int($body, 'player_id');
$levelId = require_int($body, 'level_id');
$score = require_int($body, 'score', 0);
$correctAnswers = require_int($body, 'correct_answers', 0);
$wrongAnswers = require_int($body, 'wrong_answers', 0);
$timeUsed = require_int($body, 'time_used', 0);

try {
    $pdo = Database::connect();

    $playerStmt = $pdo->prepare('SELECT id FROM players WHERE id = :id');
    $playerStmt->execute(['id' => $playerId]);
    if (!$playerStmt->fetch()) {
        send_json(false, 'Player not found.', null, 404);
    }

    $levelStmt = $pdo->prepare(
        'SELECT id, time_limit
         FROM levels
         WHERE id = :id'
    );
    $levelStmt->execute(['id' => $levelId]);
    $level = $levelStmt->fetch();
    if (!$level) {
        send_json(false, 'Level not found.', null, 404);
    }

    $questionCountStmt = $pdo->prepare('SELECT COUNT(*) FROM questions WHERE level_id = :level_id');
    $questionCountStmt->execute(['level_id' => $levelId]);
    $questionCount = (int) $questionCountStmt->fetchColumn();
    $answeredCount = $correctAnswers + $wrongAnswers;

    if ($answeredCount > $questionCount) {
        send_json(false, 'Answered count is greater than the number of questions for this level.', null, 422);
    }

    $maxPossibleScore = ($correctAnswers * 10) + ($correctAnswers * (int) $level['time_limit']);
    if ($score > $maxPossibleScore) {
        send_json(false, 'Score is higher than the allowed maximum for this result.', null, 422);
    }

    $maxPossibleTime = max(1, $questionCount) * (int) $level['time_limit'];
    if ($timeUsed > $maxPossibleTime) {
        send_json(false, 'Time used is higher than the allowed maximum for this level.', null, 422);
    }

    $stmt = $pdo->prepare(
        'INSERT INTO game_results
            (player_id, level_id, score, correct_answers, wrong_answers, time_used)
         VALUES
            (:player_id, :level_id, :score, :correct_answers, :wrong_answers, :time_used)'
    );
    $stmt->execute([
        'player_id' => $playerId,
        'level_id' => $levelId,
        'score' => $score,
        'correct_answers' => $correctAnswers,
        'wrong_answers' => $wrongAnswers,
        'time_used' => $timeUsed,
    ]);

    send_json(true, 'Game result saved successfully.', [
        'id' => (int) $pdo->lastInsertId(),
        'player_id' => $playerId,
        'level_id' => $levelId,
        'score' => $score,
        'correct_answers' => $correctAnswers,
        'wrong_answers' => $wrongAnswers,
        'time_used' => $timeUsed,
    ], 201);
} catch (PDOException) {
    send_json(false, 'Could not save game result.', null, 500);
}
