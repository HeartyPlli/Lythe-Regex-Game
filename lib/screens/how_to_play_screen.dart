part of '../main.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            children: [
              HeaderRibbon(title: 'GAME INFO', onBack: onBack),
              CutePanel(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: const [
                      InfoCard(
                        icon: Icons.shuffle,
                        title: 'RANDOMIZED',
                        subtitle: 'Every campaign shuffles questions.',
                      ),
                      InfoCard(
                        icon: Icons.timer,
                        title: '15 SECONDS',
                        subtitle: 'Easy, Medium, and Hard rounds.',
                      ),
                      InfoCard(
                        icon: Icons.alarm_on,
                        title: '20 SECONDS',
                        subtitle: 'Extreme Final Boss only.',
                      ),
                      InfoCard(
                        icon: Icons.star,
                        title: '+10 POINTS',
                        subtitle: 'Correct answer plus time bonus.',
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
