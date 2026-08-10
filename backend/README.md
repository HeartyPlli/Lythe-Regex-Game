# Lythe Game Backend

PHP/MySQL backend for the Flutter game. It uses PDO, prepared statements, and JSON responses.

## Setup

1. Start Apache and MySQL in XAMPP.
2. Open phpMyAdmin.
3. Import `backend/database.sql`, or paste it into the SQL tab for `game_database`.
4. Place this project where Apache can serve it, or configure Apache to serve the project folder.

Default XAMPP database credentials in `backend/config/database.php`:

- Host: `127.0.0.1`
- Database: `game_database`
- Username: `root`
- Password: empty

## Endpoints

Create player:

```http
POST /backend/api/players/create.php
Content-Type: application/json

{"username":"CookieBunny"}
```

Get player:

```http
GET /backend/api/players/get.php?id=1
```

Get levels:

```http
GET /backend/api/levels/index.php
```

Get randomized questions for a level:

```http
GET /backend/api/questions/by-level.php?level_id=1
```

Save result:

```http
POST /backend/api/results/save.php
Content-Type: application/json

{
  "player_id": 1,
  "level_id": 1,
  "score": 100,
  "correct_answers": 5,
  "wrong_answers": 1,
  "time_used": 42
}
```

Get player results:

```http
GET /backend/api/results/by-player.php?player_id=1
```
