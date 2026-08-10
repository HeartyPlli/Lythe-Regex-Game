<?php

declare(strict_types=1);

require_once __DIR__ . '/../../config/response.php';
require_once __DIR__ . '/../../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    send_json(false, 'Method not allowed.', null, 405);
}

$playerId = require_int($_GET, 'id');

try {
    $pdo = Database::connect();
    $stmt = $pdo->prepare(
        'SELECT id, username, avatar, created_at
         FROM players
         WHERE id = :id'
    );
    $stmt->execute(['id' => $playerId]);
    $player = $stmt->fetch();

    if (!$player) {
        send_json(false, 'Player not found.', null, 404);
    }

    send_json(true, 'Player retrieved successfully.', $player);
} catch (PDOException) {
    send_json(false, 'Could not retrieve player.', null, 500);
}
