<?php

declare(strict_types=1);

require_once __DIR__ . '/../../config/response.php';
require_once __DIR__ . '/../../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    send_json(false, 'Method not allowed.', null, 405);
}

$levelId = require_int($_GET, 'level_id');

try {
    $pdo = Database::connect();

    $levelStmt = $pdo->prepare(
        'SELECT id, level_name, difficulty, time_limit
         FROM levels
         WHERE id = :level_id'
    );
    $levelStmt->execute(['level_id' => $levelId]);
    $level = $levelStmt->fetch();

    if (!$level) {
        send_json(false, 'Level not found.', null, 404);
    }

    $questionStmt = $pdo->prepare(
        'SELECT id, level_id, question, answer, points
         FROM questions
         WHERE level_id = :level_id
         ORDER BY RAND()'
    );
    $questionStmt->execute(['level_id' => $levelId]);

    send_json(true, 'Questions retrieved successfully.', [
        'level' => $level,
        'questions' => $questionStmt->fetchAll(),
    ]);
} catch (PDOException) {
    send_json(false, 'Could not retrieve questions.', null, 500);
}
