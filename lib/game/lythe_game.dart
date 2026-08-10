part of '../main.dart';

//=========================================================================
// Game logic is here for question timer score and screen change.
//=========================================================================
class LytheGame extends StatefulWidget {
  const LytheGame({super.key});

  @override
  State<LytheGame> createState() => _LytheGameState();
}

//=========================================================================
// This class is about _LytheGameState thing.
//=========================================================================
class _LytheGameState extends State<LytheGame> {
  final Random _random = Random();
  final GameApiService _api = GameApiService();
  final TextEditingController _answerController = TextEditingController();

  late List<RegexQuestion> _campaign;
  List<LeaderboardEntry> _leaderboard = const [];
  GameScreen _screen = GameScreen.loading;
  EmoteState _emote = EmoteState.none;
  Timer? _timer;
  int? _playerId;
  String _username = '';
  String _selectedAvatar = 'character_01.png';
  int _currentIndex = 0;
  int _secondsLeft = 15;
  int _score = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  int _timedOutAnswers = 0;
  int _timeUsed = 0;
  bool _showCorrect = false;
  bool _showWrong = false;
  bool _showFailure = false;
  bool _showLogout = false;
  bool _showExtremeIntro = false;
  bool _hintUnlocked = false;

  RegexQuestion get _currentQuestion => _campaign[_currentIndex];

  int get _totalQuestions => _campaign.length;

  bool get _isExtreme => _currentQuestion.difficulty == Difficulty.extreme;

  @override
  void initState() {
    super.initState();
    _campaign = _buildLocalCampaign();

    //=========================================================================
    // This block show loading first then go menu.
    //=========================================================================
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }
      setState(() => _screen = GameScreen.menu);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  //=========================================================================
  // This function make local question list if api no work.
  //=========================================================================
  List<RegexQuestion> _buildLocalCampaign() {
    final questions = _localQuestionBank();
    return [
      ..._pickQuestions(questions, Difficulty.easy, 6),
      ..._pickQuestions(questions, Difficulty.medium, 5),
      ..._pickQuestions(questions, Difficulty.hard, 3),
      ..._pickQuestions(questions, Difficulty.extreme, 1),
    ];
  }

  //=========================================================================
  // This function pick random questions by difficulty.
  //=========================================================================
  List<RegexQuestion> _pickQuestions(
    List<RegexQuestion> questions,
    Difficulty difficulty,
    int count,
  ) {
    final pool = questions.where((q) => q.difficulty == difficulty).toList()
      ..shuffle(_random);
    return pool.take(min(pool.length, count)).toList();
  }

  //=========================================================================
  // This function hold local regex questions.
  //=========================================================================
  List<RegexQuestion> _localQuestionBank() {
    return const [
      RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[a-z]+$',
        hint: 'One or more lowercase letters.',
        example: 'hello',
      ),
      RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[0-9]+$',
        hint: 'Only numbers are allowed.',
        example: '12345',
      ),
      RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^cat$',
        hint: 'Match the exact word cat.',
        example: 'cat',
      ),
      RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[A-Z]+$',
        hint: 'Use uppercase letters only.',
        example: 'LYTHE',
      ),
      RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^.{3}$',
        hint: 'Any three characters.',
        example: 'sun',
      ),
      RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[a-z]{4}$',
        hint: 'Exactly four lowercase letters.',
        example: 'leaf',
      ),
      RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^hi+$',
        hint: 'h followed by one or more i letters.',
        example: 'hiii',
      ),
      RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[aeiou]$',
        hint: 'A single lowercase vowel.',
        example: 'a',
      ),
      RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^(bug|bee)$',
        hint: 'Type bug or bee.',
        example: 'bee',
      ),
      RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[a-z][0-9]$',
        hint: 'One lowercase letter, then one digit.',
        example: 'b7',
      ),
      RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^[a-z]{3,6}$',
        hint: 'Lowercase word with 3 to 6 letters.',
        example: 'flower',
      ),
      RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^[A-Z][a-z]+$',
        hint: 'Capitalized word.',
        example: 'Lythe',
      ),
      RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^\d{2}-\d{2}$',
        hint: 'Two digits, dash, two digits.',
        example: '08-10',
      ),
      RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^mush(room)?$',
        hint: 'mush or mushroom.',
        example: 'mushroom',
      ),
      RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^[a-z]+@[a-z]+$',
        hint: 'Lowercase word, @, lowercase word.',
        example: 'leaf@lythe',
      ),
      RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^(ha){2,4}$',
        hint: 'Repeat ha from 2 to 4 times.',
        example: 'hahaha',
      ),
      RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^[bcdfghjklmnpqrstvwxyz]+$',
        hint: 'Lowercase consonants only.',
        example: 'sprout',
      ),
      RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^#[0-9A-F]{6}$',
        hint: 'Hex color with # and six uppercase hex digits.',
        example: '#FF99AA',
      ),
      RegexQuestion(
        difficulty: Difficulty.hard,
        pattern: r'^(?=.*[0-9])[A-Za-z0-9]{5,}$',
        hint: 'At least 5 letters/digits and includes a number.',
        example: 'petal7',
      ),
      RegexQuestion(
        difficulty: Difficulty.hard,
        pattern: r'^\w+\.(png|jpg)$',
        hint: 'Filename ending in .png or .jpg.',
        example: 'flower.png',
      ),
      RegexQuestion(
        difficulty: Difficulty.hard,
        pattern: r'^(red|pink|green)-(leaf|flower)$',
        hint: 'Color, dash, plant word.',
        example: 'pink-flower',
      ),
      RegexQuestion(
        difficulty: Difficulty.hard,
        pattern: r'^\d{4}/\d{2}/\d{2}$',
        hint: 'Date shaped like yyyy/mm/dd.',
        example: '2026/08/10',
      ),
      RegexQuestion(
        difficulty: Difficulty.hard,
        pattern: r'^[a-z]{2,}-[A-Z]{2,}$',
        hint: 'Lowercase word, dash, uppercase word.',
        example: 'boss-REGEX',
      ),
      RegexQuestion(
        difficulty: Difficulty.extreme,
        pattern: r'^(?=.{8,}$)(?=.*[A-Z])(?=.*\d)[A-Za-z\d]+$',
        hint: '8+ letters/digits with at least one uppercase and one number.',
        example: 'Lythe2026',
      ),
      RegexQuestion(
        difficulty: Difficulty.extreme,
        pattern: r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{9,}$',
        hint: '9+ characters with lowercase, uppercase, and a number.',
        example: 'RegexBoss7',
      ),
    ];
  }

  //=========================================================================
  // This function start new game and reset score.
  //=========================================================================
  Future<void> _startCampaign() async {
    _timer?.cancel();
    var campaign = _buildLocalCampaign();
    try {
      final apiQuestions = await _api.getCampaignQuestions();
      final converted = apiQuestions.map(_fromApiQuestion).toList();
      if (converted.isNotEmpty) {
        campaign = converted;
      }
    } catch (_) {
      campaign = _buildLocalCampaign();
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _campaign = campaign;
      _currentIndex = 0;
      _score = 0;
      _correctAnswers = 0;
      _wrongAnswers = 0;
      _timedOutAnswers = 0;
      _timeUsed = 0;
      _screen = GameScreen.play;
      _showCorrect = false;
      _showWrong = false;
      _showFailure = false;
      _showExtremeIntro = false;
      _hintUnlocked = false;
      _emote = EmoteState.none;
    });
    _prepareQuestion();
  }

  //=========================================================================
  // This function convert backend question to game question.
  //=========================================================================
  RegexQuestion _fromApiQuestion(ApiQuestion question) {
    return RegexQuestion(
      id: question.id,
      levelId: question.levelId,
      difficulty: _difficultyFromString(question.difficulty),
      pattern: question.answer,
      hint: question.question,
      example: _exampleForDifficulty(
        _difficultyFromString(question.difficulty),
      ),
      points: question.points,
    );
  }

  //=========================================================================
  // This function change difficulty text to enum.
  //=========================================================================
  Difficulty _difficultyFromString(String difficulty) {
    return switch (difficulty.toLowerCase()) {
      'medium' => Difficulty.medium,
      'hard' => Difficulty.hard,
      'extreme' => Difficulty.extreme,
      _ => Difficulty.easy,
    };
  }

  //=========================================================================
  // This function give sample answer by difficulty.
  //=========================================================================
  String _exampleForDifficulty(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.easy => 'hello',
      Difficulty.medium => 'flower',
      Difficulty.hard => 'pink-flower',
      Difficulty.extreme => 'Lythe2026',
    };
  }

  //=========================================================================
  // This function show loading before doing next action.
  //=========================================================================
  Future<void> _showLoadingThen(FutureOr<void> Function() action) async {
    _timer?.cancel();
    setState(() {
      _screen = GameScreen.loading;
      _emote = EmoteState.none;
      _showCorrect = false;
      _showWrong = false;
      _showFailure = false;
      _showLogout = false;
      _showExtremeIntro = false;
    });
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    await action();
  }

  //=========================================================================
  // This function save player name then start campaign.
  //=========================================================================
  Future<void> _confirmPlayer(String username, String avatar) async {
    _username = username;
    _selectedAvatar = avatar;
    try {
      final player = await _api.createPlayer(
        username: username,
        avatar: avatar,
      );
      _playerId = player.id;
      _username = player.username;
      _selectedAvatar = player.avatar;
    } catch (_) {
      _playerId = null;
    }
    if (!mounted) {
      return;
    }
    await _showLoadingThen(_startCampaign);
  }

  //=========================================================================
  // This function prepare answer box and timer for question.
  //=========================================================================
  void _prepareQuestion() {
    _timer?.cancel();
    _answerController.clear();
    _secondsLeft = _isExtreme ? 20 : 15;
    _hintUnlocked = false;
    if (_isExtreme) {
      setState(() {
        _emote = EmoteState.extremeHard;
        _showExtremeIntro = true;
      });
      Future<void>.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted || _screen != GameScreen.play) {
          return;
        }
        setState(() {
          _showExtremeIntro = false;
          _emote = EmoteState.none;
        });
        _startTimer();
      });
      return;
    }
    _startTimer();
  }

  //=========================================================================
  // This function run countdown timer.
  //=========================================================================
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted ||
          _showCorrect ||
          _showWrong ||
          _showFailure ||
          _showLogout) {
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        _handleTimeOut();
      } else {
        setState(() {
          _secondsLeft -= 1;
          _timeUsed += 1;
        });
      }
    });
  }

  //=========================================================================
  // This function check answer with regex.
  //=========================================================================
  void _handleSubmit() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty || _showCorrect || _showWrong || _showFailure) {
      return;
    }

    final matcher = RegExp(_currentQuestion.pattern);
    _timer?.cancel();
    if (matcher.hasMatch(answer)) {
      setState(() {
        _correctAnswers += 1;
        _score += _currentQuestion.points + _secondsLeft;
        _showCorrect = true;
        _emote = EmoteState.success;
      });
    } else {
      setState(() {
        _wrongAnswers += 1;
        _showWrong = true;
        _emote = EmoteState.none;
      });
    }
  }

  //=========================================================================
  // This function unlock hint and take 5 score.
  //=========================================================================
  void _unlockHint() {
    if (_hintUnlocked || _score < 5) {
      return;
    }
    setState(() {
      _score -= 5;
      _hintUnlocked = true;
    });
  }

  //=========================================================================
  // This function show timeout popup.
  //=========================================================================
  void _handleTimeOut() {
    setState(() {
      _secondsLeft = 0;
      _timeUsed += 1;
      _timedOutAnswers += 1;
      _showFailure = true;
      _emote = EmoteState.failed;
    });
  }

  //=========================================================================
  // This function finish game and go leaderboard later.
  //=========================================================================
  Future<void> _finishGame() async {
    _timer?.cancel();
    await _saveResult();
    setState(() {
      _screen = GameScreen.result;
      _showCorrect = false;
      _showWrong = false;
      _showFailure = false;
      _hintUnlocked = false;
      _emote = EmoteState.none;
    });
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    await _openLeaderboard();
  }

  //=========================================================================
  // This function send final score to backend.
  //=========================================================================
  Future<void> _saveResult() async {
    if (_playerId == null) {
      try {
        final player = await _api.createPlayer(
          username: _username,
          avatar: _selectedAvatar,
        );
        _playerId = player.id;
      } catch (_) {
        return;
      }
    }
    try {
      await _api.saveResult(
        playerId: _playerId!,
        score: _score,
        correctAnswers: _correctAnswers,
        wrongAnswers: _wrongAnswers,
        timedOutAnswers: _timedOutAnswers,
        timeUsed: _timeUsed,
        totalQuestions: _totalQuestions,
      );
    } catch (_) {
      return;
    }
  }

  //=========================================================================
  // This function move to next question or finish game.
  //=========================================================================
  void _nextQuestion() {
    _timer?.cancel();
    if (_currentIndex >= _totalQuestions - 1) {
      unawaited(_finishGame());
      return;
    }
    setState(() {
      _currentIndex += 1;
      _showCorrect = false;
      _showWrong = false;
      _showFailure = false;
      _hintUnlocked = false;
      _emote = EmoteState.none;
    });
    _prepareQuestion();
  }

  //=========================================================================
  // This function open logout popup.
  //=========================================================================
  void _openLogoutDialog() {
    _timer?.cancel();
    setState(() {
      _showLogout = true;
      _emote = EmoteState.logout;
    });
  }

  //=========================================================================
  // This function close logout popup or go menu.
  //=========================================================================
  void _closeLogoutDialog({bool exitToMenu = false}) {
    setState(() {
      _showLogout = false;
      _emote = EmoteState.none;
      if (exitToMenu) {
        _screen = GameScreen.menu;
        _showCorrect = false;
        _showWrong = false;
        _showFailure = false;
        _showExtremeIntro = false;
      }
    });
    if (!exitToMenu &&
        _screen == GameScreen.play &&
        !_showCorrect &&
        !_showWrong &&
        !_showFailure &&
        !_showExtremeIntro) {
      _startTimer();
    }
  }

  //=========================================================================
  // This function get leaderboard and open leaderboard screen.
  //=========================================================================
  Future<void> _openLeaderboard() async {
    try {
      final entries = await _api.getLeaderboard();
      if (mounted) {
        setState(() {
          _leaderboard = [
            for (final entry in entries)
              LeaderboardEntry(
                entry.rank,
                entry.username,
                entry.score,
                'Complete',
                'assets/decorations/${entry.avatar}',
                correctAnswers: entry.correctAnswers,
                wrongAnswers: entry.wrongAnswers,
                timedOutAnswers: entry.timedOutAnswers,
              ),
          ];
          _screen = GameScreen.leaderboard;
          _emote = EmoteState.none;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _screen = GameScreen.leaderboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_screen != GameScreen.menu) const AnimatedGameBackground(),
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _buildScreen(),
            ),
          ),
          if (_emote != EmoteState.none) EmoteLayer(state: _emote),
          if (_showCorrect)
            _CorrectPopup(question: _currentQuestion, onNext: _nextQuestion),
          if (_showWrong)
            _WrongPopup(question: _currentQuestion, onNext: _nextQuestion),
          if (_showFailure)
            _FailurePopup(question: _currentQuestion, onSkip: _nextQuestion),
          if (_showExtremeIntro) const _ExtremeIntro(),
          if (_showLogout)
            _LogoutDialog(
              onCancel: () => _closeLogoutDialog(),
              onConfirm: () => _closeLogoutDialog(exitToMenu: true),
            ),
        ],
      ),
    );
  }

  //=========================================================================
  // This function choose which screen to show.
  //=========================================================================
  Widget _buildScreen() {
    return switch (_screen) {
      GameScreen.loading => const LoadingScreen(),
      GameScreen.menu => MainMenu(
        key: const ValueKey('menu'),
        onStart: () => _showLoadingThen(
          () => setState(() => _screen = GameScreen.playerSetup),
        ),
        onLeaderboard: () => unawaited(_openLeaderboard()),
        onHowToPlay: () => setState(() => _screen = GameScreen.howToPlay),
        onLogout: _openLogoutDialog,
      ),
      GameScreen.playerSetup => PlayerSetupScreen(
        key: const ValueKey('player-setup'),
        onBack: () => setState(() => _screen = GameScreen.menu),
        onConfirm: (username, avatar) =>
            unawaited(_confirmPlayer(username, avatar)),
      ),
      GameScreen.levels => LevelSelect(
        key: const ValueKey('levels'),
        onBack: () => setState(() => _screen = GameScreen.menu),
        onStart: () => _showLoadingThen(_startCampaign),
      ),
      GameScreen.play => PlayScreen(
        key: const ValueKey('play'),
        question: _currentQuestion,
        index: _currentIndex,
        total: _totalQuestions,
        secondsLeft: _secondsLeft,
        score: _score,
        hintUnlocked: _hintUnlocked,
        answerController: _answerController,
        onSubmit: _handleSubmit,
        onUnlockHint: _unlockHint,
        onBack: _openLogoutDialog,
      ),
      GameScreen.leaderboard => LeaderboardScreen(
        key: const ValueKey('leaderboard'),
        entries: _leaderboard,
        onBack: () => setState(() => _screen = GameScreen.menu),
      ),
      GameScreen.howToPlay => HowToPlayScreen(
        key: const ValueKey('how-to-play'),
        onBack: () => setState(() => _screen = GameScreen.menu),
      ),
      GameScreen.result => ResultScreen(
        key: const ValueKey('result'),
        score: _score,
        onLeaderboard: () => unawaited(_openLeaderboard()),
        onPlayAgain: () => setState(() => _screen = GameScreen.playerSetup),
      ),
    };
  }
}
