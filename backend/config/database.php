<?php

declare(strict_types=1);

//=========================================================================
// Database connection is here for MySQL game data.
//=========================================================================
final class Database
{
    //=========================================================================
    // Database login setting is here.
    //=========================================================================
    private const HOST = '127.0.0.1';
    private const DB_NAME = 'game_database';
    private const USERNAME = 'root';
    private const PASSWORD = '';
    private const CHARSET = 'utf8mb4';

    //=========================================================================
    // This function connect PHP to database.
    //=========================================================================
    public static function connect(): PDO
    {
        $dsn = sprintf(
            'mysql:host=%s;dbname=%s;charset=%s',
            self::HOST,
            self::DB_NAME,
            self::CHARSET
        );

        return new PDO($dsn, self::USERNAME, self::PASSWORD, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]);
    }
}
