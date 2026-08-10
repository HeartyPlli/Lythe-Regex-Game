<?php

declare(strict_types=1);

require_once __DIR__ . '/../../config/response.php';
require_once __DIR__ . '/../../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    send_json(false, 'Method not allowed.', null, 405);
}

$playerId = require_int($_GET, 'player_id');

try {
    $pdo = Database::connect();

    $playerStmt = $pdo->prepare('SELECT id, username, avatar FROM players WHERE id = :id');
    $playerStmt->execute(['id' => $playerId]);
    $player = $playerStmt->fetch();
    if (!$player) {
        send_json(false, 'Player not found.', null, 404);
    }

    $stmt = $pdo->prepare(
        'SELECT
            gr.id,
            gr.player_id,
            gr.level_id,
            l.level_name,
            l.difficulty,
            gr.score,
            gr.correct_answers,
            gr.wrong_answers,
            gr.timed_out_answers,
            gr.total_questions,
            gr.time_used,
            gr.completed_at
         FROM game_results gr
         INNER JOIN levels l ON l.id = gr.level_id
         WHERE gr.player_id = :player_id
         ORDER BY gr.completed_at DESC, gr.id DESC'
    );
    $stmt->execute(['player_id' => $playerId]);

    send_json(true, 'Player results retrieved successfully.', [
        'player' => $player,
        'results' => $stmt->fetchAll(),
    ]);
} catch (PDOException) {
    send_json(false, 'Could not retrieve player results.', null, 500);
}
