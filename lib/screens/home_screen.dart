part of '../main.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({
    required this.onStart,
    required this.onLeaderboard,
    required this.onHowToPlay,
    required this.onLogout,
    super.key,
  });

  final VoidCallback onStart;
  final VoidCallback onLeaderboard;
  final VoidCallback onHowToPlay;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final compact = width < 560;
        return Stack(
          children: [
            Positioned(
              top: 8,
              left: 14,
              child: Text(
                'LYTHE ♥',
                style: TextStyle(
                  color: AppColors.brown,
                  fontSize: compact ? 30 : 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 14,
              child: Row(
                children: [
                  CuteIconButton(
                    icon: Icons.settings,
                    label: 'Settings',
                    onPressed: onHowToPlay,
                  ),
                  const SizedBox(width: 10),
                  CuteIconButton(
                    icon: Icons.logout,
                    label: 'Logout',
                    onPressed: onLogout,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, compact ? 70 : 68, 24, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.95, end: 1),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOut,
                        builder: (context, scale, child) {
                          return Transform.scale(scale: scale, child: child);
                        },
                        child: Image.asset(
                          'assets/image/Name_Logo.png',
                          width: compact ? width * 0.86 : 600,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 18),
                      CuteGameButton(
                        label: 'START GAME',
                        icon: Icons.play_arrow_rounded,
                        onPressed: onStart,
                        large: true,
                      ),
                      const SizedBox(height: 16),
                      CuteGameButton(
                        label: 'LEADERBOARD',
                        icon: Icons.emoji_events,
                        onPressed: onLeaderboard,
                      ),
                      const SizedBox(height: 16),
                      CutePanel(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 24,
                          ),
                          child: Text(
                            'Challenge your brain and master regular expressions!\n\nSolve fun pattern matching puzzles and become the ReGex Champion!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.brown,
                              fontSize: compact ? 18 : 22,
                              height: 1.35,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CutePanel(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/decorations/flower_02.png',
                                width: 54,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 14),
                              Flexible(
                                child: Text(
                                  'Created with ♥ by Lythe',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.brown,
                                    fontSize: compact ? 18 : 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Image.asset(
                                'assets/decorations/leaf_02.png',
                                width: 54,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 18,
              child: Image.asset(
                'assets/decorations/character_03.png',
                width: compact ? 108 : 152,
              ),
            ),
            Positioned(
              right: 16,
              bottom: 18,
              child: Image.asset(
                'assets/decorations/character_01.png',
                width: compact ? 108 : 152,
              ),
            ),
          ],
        );
      },
    );
  }
}
