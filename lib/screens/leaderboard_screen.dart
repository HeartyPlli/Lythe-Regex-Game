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
                decoration: PanelDecoration.character,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      if (entries.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (entries.length > 1)
                              PodiumPlace(
                                rank: 2,
                                asset: entries[1].asset,
                                height: 86,
                              ),
                            PodiumPlace(
                              rank: 1,
                              asset: entries.first.asset,
                              height: 126,
                            ),
                            if (entries.length > 2)
                              PodiumPlace(
                                rank: 3,
                                asset: entries[2].asset,
                                height: 78,
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        for (final entry in entries)
                          LeaderboardRow(entry: entry),
                      ] else
                        HintBox(
                          text:
                              'No recorded scores yet. Play a game to appear here!',
                        ),
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
