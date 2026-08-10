<?php

declare(strict_types=1);

require_once __DIR__ . '/../../config/response.php';
require_once __DIR__ . '/../../config/database.php';

//=========================================================================
// Api campaign questions is here for full game question set.
//=========================================================================
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    send_json(false, 'Method not allowed.', null, 405);
}

//=========================================================================
// This block set how many question per difficulty.
//=========================================================================
$limits = [
    'easy' => 6,
    'medium' => 5,
    'hard' => 3,
    'extreme' => 1,
];

try {
    $pdo = Database::connect();
    $questions = [];

    //=========================================================================
    // This query get random questions by difficulty.
    //=========================================================================
    $stmt = $pdo->prepare(
        'SELECT
            q.id,
            q.level_id,
            l.difficulty,
            q.question,
            q.answer,
            q.points
         FROM questions q
         INNER JOIN levels l ON l.id = q.level_id
         WHERE l.difficulty = :difficulty
         ORDER BY RAND()
         LIMIT :limit'
    );

    //=========================================================================
    // This loop build the full campaign question list.
    //=========================================================================
    foreach ($limits as $difficulty => $limit) {
        $stmt->bindValue(':difficulty', $difficulty, PDO::PARAM_STR);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        $questions = array_merge($questions, $stmt->fetchAll());
    }

    send_json(true, 'Campaign questions retrieved successfully.', [
        'total' => count($questions),
        'questions' => $questions,
    ]);
} catch (PDOException) {
    send_json(false, 'Could not retrieve campaign questions.', null, 500);
}
