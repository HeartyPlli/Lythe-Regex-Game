<?php

declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

function send_json(bool $success, string $message, mixed $data = null, int $statusCode = 200): never
{
    http_response_code($statusCode);

    $response = [
        'success' => $success,
        'message' => $message,
    ];

    if ($data !== null) {
        $response['data'] = $data;
    }

    echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
    exit;
}

function read_json_body(): array
{
    $rawBody = file_get_contents('php://input');
    if ($rawBody === false || trim($rawBody) === '') {
        return [];
    }

    $decoded = json_decode($rawBody, true);
    if (!is_array($decoded)) {
        send_json(false, 'Invalid JSON body.', null, 400);
    }

    return $decoded;
}

function require_int(array $source, string $key, int $min = 1): int
{
    if (!isset($source[$key]) || filter_var($source[$key], FILTER_VALIDATE_INT) === false) {
        send_json(false, "Missing or invalid {$key}.", null, 400);
    }

    $value = (int) $source[$key];
    if ($value < $min) {
        send_json(false, "{$key} must be at least {$min}.", null, 400);
    }

    return $value;
}

function clean_string(mixed $value): string
{
    return trim(strip_tags((string) $value));
}
