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
        'SELECT l.id, l.level_name, l.difficulty, l.time_limit, COUNT(q.id) AS question_count
         FROM levels l
         LEFT JOIN questions q ON q.level_id = l.id
         GROUP BY l.id, l.level_name, l.difficulty, l.time_limit
         ORDER BY FIELD(l.difficulty, "easy", "medium", "hard", "extreme")'
    );

    send_json(true, 'Levels retrieved successfully.', $stmt->fetchAll());
} catch (PDOException) {
    send_json(false, 'Could not retrieve levels.', null, 500);
}
