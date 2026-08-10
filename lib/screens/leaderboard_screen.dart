part of '../main.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({
    required this.entries,
    required this.onBack,
    super.key,
  });

  final List<LeaderboardEntry> entries;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            children: [
              HeaderRibbon(title: 'LEADERBOARD', onBack: onBack),
              CutePanel(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PodiumPlace(
                            rank: 2,
                            asset: 'assets/decorations/character_08.png',
                            height: 86,
                          ),
                          PodiumPlace(
                            rank: 1,
                            asset: 'assets/decorations/character_01.png',
                            height: 126,
                          ),
                          PodiumPlace(
                            rank: 3,
                            asset: 'assets/decorations/character_07.png',
                            height: 78,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      for (final entry in entries) LeaderboardRow(entry: entry),
                      const SizedBox(height: 14),
                      HintBox(text: 'You are doing great! Keep it up!'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
