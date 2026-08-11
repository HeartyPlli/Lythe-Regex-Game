part of '../main.dart';

//=========================================================================
// Ui home menu is here for start leaderboard and how to play.
//=========================================================================
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
        final pageHeight = max(
          constraints.maxHeight,
          compact ? 1160.0 : 1120.0,
        );
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: pageHeight),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/image/Background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 14,
                  child: Text(
                    'LYTHE â™¥',
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
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      compact ? 70 : 68,
                      24,
                      compact ? 150 : 190,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.95, end: 1),
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeOut,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
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
                          const SizedBox(height: 46),
                          CutePanel(
                            decoration: PanelDecoration.blossom,
                            maxWidth: 900,
                            borderWidth: 6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 34,
                                vertical: 28,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'About',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.brown,
                                      fontSize: compact ? 21 : 26,
                                      fontWeight: FontWeight.w900,
                                      height: 1.2,
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  Text(
                                    'Lythe RegEx Game is an interactive game designed '
                                    'to make learning and practicing Regular Expressions '
                                    '(RegEx) more fun, engaging, and enjoyable.\n\n'
                                    'In each round, players are given a random RegEx '
                                    'pattern and must enter a string that matches it.\n\n'
                                    'Each correct answer earns 10 points, while 1 point '
                                    'is deducted for every second taken. Players may also '
                                    'use a Hint when they need help, but each hint costs '
                                    '5 points.\n\n'
                                    'The game combines speed, accuracy, and problem-solving '
                                    'skills, because with RegEx, even one tiny symbol can '
                                    'make all the difference!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.brown,
                                      fontSize: compact ? 14 : 17,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Text(
                                    'Learn the pattern. Match the string. Beat the clock.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.brown,
                                      fontSize: compact ? 15 : 19,
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    '✦ Become the RegEx Champion! ✦',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.brown,
                                      fontSize: compact ? 16 : 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CutePanel(
                            decoration: PanelDecoration.leaf,
                            maxWidth: 900,
                            borderWidth: 6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 28,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // LEFT FLOWER
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    
                                  ),

                                  // CENTERED CREDITS
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 680,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Credits',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.brown,
                                            fontSize: compact ? 21 : 26,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          'Heart Cagadas • Athea Jean Angcog • Lyzel Mae Talisic',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.brown,
                                            fontSize: compact ? 15 : 19,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          'BSCS-3 | Bachelor of Science in Computer Science',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.brown.withValues(alpha: 0.75),
                                            fontSize: compact ? 12 : 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        Text(
                                          'Designed, developed, and brought to life by the '
                                          'Lythe Team.\n'
                                          'Turning Regular Expressions into a game, '
                                          'one pattern at a time. ♡',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.brown,
                                            fontSize: compact ? 12 : 15,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.italic,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // RIGHT LEAF
                                  Align(
                                    alignment: Alignment.centerRight,
                                    
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
            ),
          ),
        );
      },
    );
  }
}
