part of '../main.dart';

//=========================================================================
// Ui how to play is here for showing game info and rules.
//=========================================================================
class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    //=========================================================================
    // Ui this is make the how to play page know screen size.
    //=========================================================================
    return LayoutBuilder(
      builder: (context, constraints) {
        //=========================================================================
        // Ui this scroll is for small screen so it no overflow.
        //=========================================================================
        return SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 36),
            //=========================================================================
            // Ui this center put all the game info in middle.
            //=========================================================================
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //=========================================================================
                    // Ui this is title and back button.
                    //=========================================================================
                    HeaderRibbon(title: 'GAME INFO', onBack: onBack),
                    //=========================================================================
                    // Ui this panel show the rules card.
                    //=========================================================================
                    CutePanel(
                      decoration: PanelDecoration.meadow,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        //=========================================================================
                        // Ui this wrap make card go next line when screen small.
                        //=========================================================================
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: const [
                            InfoCard(
                              icon: Icons.shuffle,
                              title: '15 QUESTIONS',
                              subtitle: '6 Easy, 5 Medium, 3 Hard, 1 Extreme.',
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
          ),
        );
      },
    );
  }
}
