<?php

declare(strict_types=1);

require_once __DIR__ . '/../../config/response.php';
require_once __DIR__ . '/../../config/database.php';

//=========================================================================
// Api save result is here for store score after game.
//=========================================================================
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    send_json(false, 'Method not allowed.', null, 405);
}

//=========================================================================
// This block read score data from app.
//=========================================================================
$body = read_json_body();
$playerId = require_int($body, 'player_id');
$levelId = require_int($body, 'level_id');
$score = require_int($body, 'score', 0);
$correctAnswers = require_int($body, 'correct_answers', 0);
$wrongAnswers = require_int($body, 'wrong_answers', 0);
$timedOutAnswers = require_int($body, 'timed_out_answers', 0);
$totalQuestions = require_int($body, 'total_questions', 1);
$timeUsed = require_int($body, 'time_used', 0);

try {
    $pdo = Database::connect();

    //=========================================================================
    // This query check player exist before saving score.
    //=========================================================================
    $playerStmt = $pdo->prepare('SELECT id FROM players WHERE id = :id');
    $playerStmt->execute(['id' => $playerId]);
    if (!$playerStmt->fetch()) {
        send_json(false, 'Player not found.', null, 404);
    }

    //=========================================================================
    // This query check level exist before saving score.
    //=========================================================================
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

    //=========================================================================
    // This block validate score count and time is not weird.
    //=========================================================================
    $answeredCount = $correctAnswers + $wrongAnswers + $timedOutAnswers;

    if ($answeredCount !== $totalQuestions) {
        send_json(false, 'Answered count must match total questions.', null, 422);
    }

    $maxPossibleScore = ($correctAnswers * 10) + ($correctAnswers * 20);
    if ($score > $maxPossibleScore) {
        send_json(false, 'Score is higher than the allowed maximum for this result.', null, 422);
    }

    $maxPossibleTime = max(1, $totalQuestions) * 20;
    if ($timeUsed > $maxPossibleTime) {
        send_json(false, 'Time used is higher than the allowed maximum for this level.', null, 422);
    }

    //=========================================================================
    // This query save final game result.
    //=========================================================================
    $stmt = $pdo->prepare(
        'INSERT INTO game_results
            (player_id, level_id, score, correct_answers, wrong_answers, timed_out_answers, total_questions, time_used)
         VALUES
            (:player_id, :level_id, :score, :correct_answers, :wrong_answers, :timed_out_answers, :total_questions, :time_used)'
    );
    $stmt->execute([
        'player_id' => $playerId,
        'level_id' => $levelId,
        'score' => $score,
        'correct_answers' => $correctAnswers,
        'wrong_answers' => $wrongAnswers,
        'timed_out_answers' => $timedOutAnswers,
        'total_questions' => $totalQuestions,
        'time_used' => $timeUsed,
    ]);

    send_json(true, 'Game result saved successfully.', [
        'id' => (int) $pdo->lastInsertId(),
        'player_id' => $playerId,
        'level_id' => $levelId,
        'score' => $score,
        'correct_answers' => $correctAnswers,
        'wrong_answers' => $wrongAnswers,
        'timed_out_answers' => $timedOutAnswers,
        'total_questions' => $totalQuestions,
        'time_used' => $timeUsed,
    ], 201);
} catch (PDOException) {
    send_json(false, 'Could not save game result.', null, 500);
}
