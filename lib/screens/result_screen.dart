part of '../main.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    required this.score,
    required this.onLeaderboard,
    required this.onPlayAgain,
    super.key,
  });

  final int score;
  final VoidCallback onLeaderboard;
  final VoidCallback onPlayAgain;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ConfettiOverlay(huge: true),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: CutePanel(
                decoration: PanelDecoration.blossom,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/image/Yay.png',
                        height: 190,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        'GAME FINISHED!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.pink,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Amazing work!',
                        style: TextStyle(
                          color: AppColors.brown,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'YOUR FINAL SCORE',
                        style: TextStyle(
                          color: AppColors.brown,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '$score',
                        style: TextStyle(
                          color: AppColors.pink,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          CuteGameButton(
                            label: 'VIEW LEADERBOARD',
                            icon: Icons.emoji_events,
                            onPressed: onLeaderboard,
                            green: true,
                          ),
                          CuteGameButton(
                            label: 'PLAY AGAIN',
                            icon: Icons.replay,
                            onPressed: onPlayAgain,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
