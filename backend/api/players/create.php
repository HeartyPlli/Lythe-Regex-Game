<?php

declare(strict_types=1);

require_once __DIR__ . '/../../config/response.php';
require_once __DIR__ . '/../../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    send_json(false, 'Method not allowed.', null, 405);
}

$body = read_json_body();
$username = clean_string($body['username'] ?? '');

if ($username === '' || strlen($username) < 3 || strlen($username) > 50) {
    send_json(false, 'Username must be between 3 and 50 characters.', null, 400);
}

if (!preg_match('/^[A-Za-z0-9_ ]+$/', $username)) {
    send_json(false, 'Username may only contain letters, numbers, spaces, and underscores.', null, 400);
}

try {
    $pdo = Database::connect();

    $stmt = $pdo->prepare('INSERT INTO players (username) VALUES (:username)');
    $stmt->execute(['username' => $username]);

    send_json(true, 'Player created successfully.', [
        'id' => (int) $pdo->lastInsertId(),
        'username' => $username,
    ], 201);
} catch (PDOException $exception) {
    if ($exception->getCode() === '23000') {
        send_json(false, 'Username already exists.', null, 409);
    }

    send_json(false, 'Could not create player.', null, 500);
}
