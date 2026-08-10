part of '../main.dart';

class _CorrectPopup extends StatelessWidget {
  const _CorrectPopup({required this.question, required this.onNext});

  final RegexQuestion question;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return PopupScrim(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const ConfettiOverlay(),
          AnimatedAppear(
            child: CutePanel(
              decoration: PanelDecoration.blossom,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/image/Yay.png',
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'CORRECT!',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Great job! That is a match!',
                      style: TextStyle(
                        color: AppColors.brown,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    HintBox(text: 'You earned +10 points and a time bonus.'),
                    const SizedBox(height: 16),
                    CuteGameButton(
                      label: 'NEXT QUESTION',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: onNext,
                      green: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FailurePopup extends StatelessWidget {
  const _FailurePopup({required this.question, required this.onSkip});

  final RegexQuestion question;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return PopupScrim(
      child: AnimatedAppear(
        child: CutePanel(
          decoration: PanelDecoration.character,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/image/Sad.png',
                  height: 132,
                  fit: BoxFit.contain,
                ),
                Text(
                  'TIME IS UP!',
                  style: TextStyle(
                    color: AppColors.pink,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                HintBox(text: 'Correct answer example: ${question.example}'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    CuteGameButton(
                      label: 'NEXT QUESTION',
                      icon: Icons.skip_next,
                      onPressed: onSkip,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExtremeIntro extends StatelessWidget {
  const _ExtremeIntro();

  @override
  Widget build(BuildContext context) {
    return PopupScrim(
      transparent: true,
      child: AnimatedAppear(
        child: CutePanel(
          dark: true,
          decoration: PanelDecoration.night,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/image/Shock.png',
                  height: 170,
                  fit: BoxFit.contain,
                ),
                Text(
                  'EXTREME FINAL BOSS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.palePink,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '20 seconds. One question. Deep breath.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.cream,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog({required this.onCancel, required this.onConfirm});

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return PopupScrim(
      child: AnimatedAppear(
        child: CutePanel(
          decoration: PanelDecoration.meadow,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/image/Oh.png',
                  height: 160,
                  fit: BoxFit.contain,
                ),
                Text(
                  'Are you sure you want to log out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.brown,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    CuteGameButton(
                      label: 'CANCEL',
                      icon: Icons.close,
                      onPressed: onCancel,
                      green: true,
                    ),
                    CuteGameButton(
                      label: 'LOG OUT',
                      icon: Icons.logout,
                      onPressed: onConfirm,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
