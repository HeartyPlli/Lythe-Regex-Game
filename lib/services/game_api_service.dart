import 'dart:convert';

import 'http_transport.dart';

//=========================================================================
// Service api is here for questions players results and leaderboard.
//=========================================================================
class GameApiException implements Exception {
  const GameApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

//=========================================================================
// This class is about ApiPlayer thing.
//=========================================================================
class ApiPlayer {
  const ApiPlayer({
    required this.id,
    required this.username,
    required this.avatar,
  });

  final int id;
  final String username;
  final String avatar;
}

//=========================================================================
// This class is about ApiQuestion thing.
//=========================================================================
class ApiQuestion {
  const ApiQuestion({
    required this.id,
    required this.levelId,
    required this.difficulty,
    required this.question,
    required this.answer,
    required this.points,
  });

  final int id;
  final int levelId;
  final String difficulty;
  final String question;
  final String answer;
  final int points;
}

//=========================================================================
// This class is about ApiLeaderboardEntry thing.
//=========================================================================
class ApiLeaderboardEntry {
  const ApiLeaderboardEntry({
    required this.rank,
    required this.username,
    required this.avatar,
    required this.score,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.timedOutAnswers,
    required this.completedAt,
  });

  final int rank;
  final String username;
  final String avatar;
  final int score;
  final int correctAnswers;
  final int wrongAnswers;
  final int timedOutAnswers;
  final String completedAt;
}

//=========================================================================
// This class is about GameApiService thing.
//=========================================================================
class GameApiService {
  GameApiService({String baseUrl = 'http://localhost/lythe/backend/api'})
    : _baseUri = Uri.parse(baseUrl.endsWith('/') ? baseUrl : '$baseUrl/');

  final Uri _baseUri;

  //=========================================================================
  // This function create player from app input.
  //=========================================================================
  Future<ApiPlayer> createPlayer({
    required String username,
    required String avatar,
  }) async {
    final data = await _post('players/create.php', {
      'username': username,
      'avatar': avatar,
    });
    return ApiPlayer(
      id: _asInt(data['id']),
      username: data['username'] as String? ?? username,
      avatar: data['avatar'] as String? ?? avatar,
    );
  }

  //=========================================================================
  // This function get campaign questions from backend.
  //=========================================================================
  Future<List<ApiQuestion>> getCampaignQuestions() async {
    final data = await _get('questions/campaign.php');
    final questions = data['questions'];
    if (questions is! List) {
      throw const GameApiException('Question response is missing questions.');
    }
    return [
      for (final item in questions)
        if (item is Map<String, Object?>)
          ApiQuestion(
            id: _asInt(item['id']),
            levelId: _asInt(item['level_id']),
            difficulty: item['difficulty'] as String? ?? 'easy',
            question: item['question'] as String? ?? '',
            answer: item['answer'] as String? ?? '',
            points: _asInt(item['points'], fallback: 10),
          ),
    ];
  }

  //=========================================================================
  // This function save player score after game.
  //=========================================================================
  Future<void> saveResult({
    required int playerId,
    required int score,
    required int correctAnswers,
    required int wrongAnswers,
    required int timedOutAnswers,
    required int timeUsed,
    required int totalQuestions,
  }) async {
    await _post('results/save.php', {
      'player_id': playerId,
      'level_id': 4,
      'score': score,
      'correct_answers': correctAnswers,
      'wrong_answers': wrongAnswers,
      'timed_out_answers': timedOutAnswers,
      'time_used': timeUsed,
      'total_questions': totalQuestions,
    });
  }

  //=========================================================================
  // This function get leaderboard data from backend.
  //=========================================================================
  Future<List<ApiLeaderboardEntry>> getLeaderboard() async {
    final data = await _get('results/leaderboard.php');
    final entries = data['entries'];
    if (entries is! List) {
      throw const GameApiException('Leaderboard response is missing entries.');
    }
    return [
      for (final item in entries)
        if (item is Map<String, Object?>)
          ApiLeaderboardEntry(
            rank: _asInt(item['rank']),
            username: item['username'] as String? ?? 'Player',
            avatar: item['avatar'] as String? ?? 'character_01.png',
            score: _asInt(item['score']),
            correctAnswers: _asInt(item['correct_answers']),
            wrongAnswers: _asInt(item['wrong_answers']),
            timedOutAnswers: _asInt(item['timed_out_answers']),
            completedAt: item['completed_at'] as String? ?? '',
          ),
    ];
  }

  //=========================================================================
  // This function do GET request to api.
  //=========================================================================
  Future<Map<String, Object?>> _get(String path) async {
    final response = await HttpTransport.get(_baseUri.resolve(path));
    return _decodeResponse(response);
  }

  //=========================================================================
  // This function do POST request to api.
  //=========================================================================
  Future<Map<String, Object?>> _post(
    String path,
    Map<String, Object?> body,
  ) async {
    final response = await HttpTransport.postJson(_baseUri.resolve(path), body);
    return _decodeResponse(response);
  }

  //=========================================================================
  // This function decode api answer and check success.
  //=========================================================================
  Map<String, Object?> _decodeResponse(HttpResponseData response) {
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, Object?>) {
      throw const GameApiException('Invalid API response.');
    }
    if (decoded['success'] != true) {
      throw GameApiException(decoded['message'] as String? ?? 'API error.');
    }
    final data = decoded['data'];
    if (data is Map<String, Object?>) {
      return data;
    }
    if (data is List) {
      return {'entries': data};
    }
    return {};
  }

  //=========================================================================
  // This function change api value to int safely.
  //=========================================================================
  static int _asInt(Object? value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
