part of '../main.dart';

//=========================================================================
// Ui level select is here for start game from level page.
//=========================================================================
class LevelSelect extends StatelessWidget {
  const LevelSelect({required this.onBack, required this.onStart, super.key});

  final VoidCallback onBack;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            children: [
              HeaderRibbon(title: 'CHOOSE YOUR LEVEL', onBack: onBack),
              CutePanel(
                decoration: PanelDecoration.mushroom,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      DifficultyRow(
                        difficulty: Difficulty.easy,
                        title: 'EASY',
                        subtitle: '6 QUESTIONS',
                        icon: 'assets/decorations/leaf_10.png',
                      ),
                      DifficultyRow(
                        difficulty: Difficulty.medium,
                        title: 'MEDIUM',
                        subtitle: '5 QUESTIONS',
                        icon: 'assets/decorations/flower_14.png',
                      ),
                      DifficultyRow(
                        difficulty: Difficulty.hard,
                        title: 'HARD',
                        subtitle: '3 QUESTIONS',
                        icon: 'assets/decorations/mushroom_03.png',
                      ),
                      DifficultyRow(
                        difficulty: Difficulty.extreme,
                        title: 'EXTREME',
                        subtitle: '1 FINAL BOSS',
                        icon: 'assets/decorations/character_05.png',
                      ),
                      const SizedBox(height: 14),
                      CuteGameButton(
                        label: 'START RANDOM CAMPAIGN',
                        icon: Icons.play_arrow_rounded,
                        onPressed: onStart,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Questions are randomized within each level.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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
