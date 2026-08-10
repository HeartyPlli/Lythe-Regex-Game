part of '../main.dart';

class LytheGame extends StatefulWidget {
  const LytheGame({super.key});

  @override
  State<LytheGame> createState() => _LytheGameState();
}

class _LytheGameState extends State<LytheGame> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  final List<LeaderboardEntry> _baseLeaderboard = const [
    LeaderboardEntry(
      1,
      'CookieBunny',
      260,
      'Extreme',
      'assets/decorations/character_02.png',
    ),
    LeaderboardEntry(
      2,
      'MatchMaster',
      230,
      'Hard',
      'assets/decorations/character_06.png',
    ),
    LeaderboardEntry(
      3,
      'RegexNinja',
      210,
      'Hard',
      'assets/decorations/character_05.png',
    ),
    LeaderboardEntry(
      4,
      'CodeKitten',
      180,
      'Medium',
      'assets/decorations/character_08.png',
    ),
    LeaderboardEntry(
      5,
      'PatternPanda',
      150,
      'Medium',
      'assets/decorations/character_07.png',
    ),
  ];

  late List<RegexQuestion> _campaign;
  GameScreen _screen = GameScreen.loading;
  EmoteState _emote = EmoteState.none;
  Timer? _timer;
  int _currentIndex = 0;
  int _secondsLeft = 15;
  int _score = 0;
  bool _showCorrect = false;
  bool _showFailure = false;
  bool _showLogout = false;
  bool _showExtremeIntro = false;

  RegexQuestion get _currentQuestion => _campaign[_currentIndex];

  int get _totalQuestions => _campaign.length;

  bool get _isExtreme => _currentQuestion.difficulty == Difficulty.extreme;

  @override
  void initState() {
    super.initState();
    _campaign = _buildCampaign();
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _screen = GameScreen.menu;
        _emote = EmoteState.none;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  List<RegexQuestion> _buildCampaign() {
    final easy = [
      const RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[a-z]+$',
        hint: 'One or more lowercase letters.',
        example: 'hello',
      ),
      const RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[0-9]+$',
        hint: 'Only numbers are allowed.',
        example: '12345',
      ),
      const RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^cat$',
        hint: 'Match the exact word cat.',
        example: 'cat',
      ),
      const RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[A-Z]+$',
        hint: 'Use uppercase letters only.',
        example: 'LYTHE',
      ),
      const RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^.{3}$',
        hint: 'Any three characters.',
        example: 'sun',
      ),
      const RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[a-z]{4}$',
        hint: 'Exactly four lowercase letters.',
        example: 'leaf',
      ),
      const RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^hi+$',
        hint: 'h followed by one or more i letters.',
        example: 'hiii',
      ),
      const RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[aeiou]$',
        hint: 'A single lowercase vowel.',
        example: 'a',
      ),
      const RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^(bug|bee)$',
        hint: 'Type bug or bee.',
        example: 'bee',
      ),
      const RegexQuestion(
        difficulty: Difficulty.easy,
        pattern: r'^[a-z][0-9]$',
        hint: 'One lowercase letter, then one digit.',
        example: 'b7',
      ),
    ]..shuffle(_random);

    final medium = [
      const RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^[a-z]{3,6}$',
        hint: 'Lowercase word with 3 to 6 letters.',
        example: 'flower',
      ),
      const RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^[A-Z][a-z]+$',
        hint: 'Capitalized word.',
        example: 'Lythe',
      ),
      const RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^\d{2}-\d{2}$',
        hint: 'Two digits, dash, two digits.',
        example: '08-10',
      ),
      const RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^mush(room)?$',
        hint: 'mush or mushroom.',
        example: 'mushroom',
      ),
      const RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^[a-z]+@[a-z]+$',
        hint: 'Lowercase word, @, lowercase word.',
        example: 'leaf@lythe',
      ),
      const RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^(ha){2,4}$',
        hint: 'Repeat ha from 2 to 4 times.',
        example: 'hahaha',
      ),
      const RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^[bcdfghjklmnpqrstvwxyz]+$',
        hint: 'Lowercase consonants only.',
        example: 'sprout',
      ),
      const RegexQuestion(
        difficulty: Difficulty.medium,
        pattern: r'^#[0-9A-F]{6}$',
        hint: 'Hex color with # and six uppercase hex digits.',
        example: '#FF99AA',
      ),
    ]..shuffle(_random);

    final hard = [
      const RegexQuestion(
        difficulty: Difficulty.hard,
        pattern: r'^(?=.*[0-9])[A-Za-z0-9]{5,}$',
        hint: 'At least 5 letters/digits and includes a number.',
        example: 'petal7',
      ),
      const RegexQuestion(
        difficulty: Difficulty.hard,
        pattern: r'^\w+\.(png|jpg)$',
        hint: 'Filename ending in .png or .jpg.',
        example: 'flower.png',
      ),
      const RegexQuestion(
        difficulty: Difficulty.hard,
        pattern: r'^(red|pink|green)-(leaf|flower)$',
        hint: 'Color, dash, plant word.',
        example: 'pink-flower',
      ),
      const RegexQuestion(
        difficulty: Difficulty.hard,
        pattern: r'^\d{4}/\d{2}/\d{2}$',
        hint: 'Date shaped like yyyy/mm/dd.',
        example: '2026/08/10',
      ),
      const RegexQuestion(
        difficulty: Difficulty.hard,
        pattern: r'^[a-z]{2,}-[A-Z]{2,}$',
        hint: 'Lowercase word, dash, uppercase word.',
        example: 'boss-REGEX',
      ),
    ]..shuffle(_random);

    final extreme = [
      const RegexQuestion(
        difficulty: Difficulty.extreme,
        pattern: r'^(?=.{8,}$)(?=.*[A-Z])(?=.*\d)[A-Za-z\d]+$',
        hint: '8+ letters/digits with at least one uppercase and one number.',
        example: 'Lythe2026',
      ),
    ];

    return [...easy, ...medium, ...hard, ...extreme];
  }

  void _startCampaign() {
    _timer?.cancel();
    setState(() {
      _campaign = _buildCampaign();
      _currentIndex = 0;
      _score = 0;
      _screen = GameScreen.play;
      _showCorrect = false;
      _showFailure = false;
      _showExtremeIntro = false;
      _emote = EmoteState.none;
    });
    _prepareQuestion();
  }

  void _showLoadingThen(VoidCallback action) {
    _timer?.cancel();
    setState(() {
      _screen = GameScreen.loading;
      _emote = EmoteState.none;
      _showCorrect = false;
      _showFailure = false;
      _showLogout = false;
      _showExtremeIntro = false;
    });
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      action();
    });
  }

  void _prepareQuestion() {
    _timer?.cancel();
    _answerController.clear();
    _secondsLeft = _isExtreme ? 20 : 15;
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

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _showCorrect || _showFailure || _showLogout) {
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        _handleTimeOut();
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  void _handleSubmit() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty || _showCorrect || _showFailure) {
      return;
    }

    final matcher = RegExp(_currentQuestion.pattern);
    if (matcher.hasMatch(answer)) {
      _timer?.cancel();
      setState(() {
        _score += 10 + _secondsLeft;
        _showCorrect = true;
        _emote = EmoteState.success;
      });
    } else {
      setState(() => _emote = EmoteState.incorrect);
      Future<void>.delayed(const Duration(milliseconds: 650), () {
        if (mounted && _emote == EmoteState.incorrect) {
          setState(() => _emote = EmoteState.none);
        }
      });
    }
  }

  void _handleTimeOut() {
    setState(() {
      _secondsLeft = 0;
      _showFailure = true;
      _emote = EmoteState.failed;
    });
  }

  void _nextQuestion() {
    _timer?.cancel();
    if (_currentIndex >= _totalQuestions - 1) {
      setState(() {
        _screen = GameScreen.result;
        _showCorrect = false;
        _showFailure = false;
        _emote = EmoteState.success;
      });
      return;
    }
    setState(() {
      _currentIndex += 1;
      _showCorrect = false;
      _showFailure = false;
      _emote = EmoteState.none;
    });
    _prepareQuestion();
  }

  void _retryQuestion() {
    setState(() {
      _showFailure = false;
      _emote = EmoteState.none;
    });
    _prepareQuestion();
  }

  void _openLogoutDialog() {
    _timer?.cancel();
    setState(() {
      _showLogout = true;
      _emote = EmoteState.logout;
    });
  }

  void _closeLogoutDialog({bool exitToMenu = false}) {
    setState(() {
      _showLogout = false;
      _emote = EmoteState.none;
      if (exitToMenu) {
        _screen = GameScreen.menu;
        _showCorrect = false;
        _showFailure = false;
        _showExtremeIntro = false;
      }
    });
    if (!exitToMenu &&
        _screen == GameScreen.play &&
        !_showCorrect &&
        !_showFailure &&
        !_showExtremeIntro) {
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGameBackground(),
          const DecorativeBorder(),
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
          if (_showFailure)
            _FailurePopup(
              question: _currentQuestion,
              onRetry: _retryQuestion,
              onSkip: _nextQuestion,
            ),
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

  Widget _buildScreen() {
    return switch (_screen) {
      GameScreen.loading => const LoadingScreen(),
      GameScreen.menu => MainMenu(
        key: const ValueKey('menu'),
        onStart: () =>
            _showLoadingThen(() => setState(() => _screen = GameScreen.levels)),
        onLeaderboard: () => setState(() => _screen = GameScreen.leaderboard),
        onHowToPlay: () => setState(() => _screen = GameScreen.howToPlay),
        onLogout: _openLogoutDialog,
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
        answerController: _answerController,
        onSubmit: _handleSubmit,
        onBack: _openLogoutDialog,
      ),
      GameScreen.leaderboard => LeaderboardScreen(
        key: const ValueKey('leaderboard'),
        entries: _leaderboardEntries(),
        onBack: () => setState(() => _screen = GameScreen.menu),
      ),
      GameScreen.howToPlay => HowToPlayScreen(
        key: const ValueKey('how-to-play'),
        onBack: () => setState(() => _screen = GameScreen.menu),
      ),
      GameScreen.result => ResultScreen(
        key: const ValueKey('result'),
        score: _score,
        onLeaderboard: () => setState(() => _screen = GameScreen.leaderboard),
        onPlayAgain: _startCampaign,
      ),
    };
  }

  List<LeaderboardEntry> _leaderboardEntries() {
    final entries = [
      ..._baseLeaderboard,
      if (_score > 0)
        LeaderboardEntry(
          6,
          'You',
          _score,
          _score >= 240
              ? 'Extreme'
              : _score >= 170
              ? 'Hard'
              : 'Medium',
          'assets/decorations/character_01.png',
        ),
    ]..sort((a, b) => b.score.compareTo(a.score));

    return [
      for (var i = 0; i < min(entries.length, 6); i++)
        LeaderboardEntry(
          i + 1,
          entries[i].player,
          entries[i].score,
          entries[i].level,
          entries[i].asset,
        ),
    ];
  }
}
