<?php

declare(strict_types=1);

require_once __DIR__ . '/../../config/response.php';
require_once __DIR__ . '/../../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    send_json(false, 'Method not allowed.', null, 405);
}

try {
    $pdo = Database::connect();
    $stmt = $pdo->query(
        'SELECT
            p.username,
            p.avatar,
            gr.score,
            gr.correct_answers,
            gr.wrong_answers,
            gr.timed_out_answers,
            gr.completed_at
         FROM game_results gr
         INNER JOIN players p ON p.id = gr.player_id
         ORDER BY gr.score DESC, gr.correct_answers DESC, gr.completed_at ASC
         LIMIT 10'
    );

    $entries = [];
    $rank = 1;
    foreach ($stmt->fetchAll() as $row) {
        $row['rank'] = $rank++;
        $entries[] = $row;
    }

    send_json(true, 'Leaderboard retrieved successfully.', [
        'entries' => $entries,
    ]);
} catch (PDOException) {
    send_json(false, 'Could not retrieve leaderboard.', null, 500);
}
