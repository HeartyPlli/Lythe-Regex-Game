part of '../main.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({
    required this.question,
    required this.index,
    required this.total,
    required this.secondsLeft,
    required this.score,
    required this.answerController,
    required this.onSubmit,
    required this.onBack,
    super.key,
  });

  final RegexQuestion question;
  final int index;
  final int total;
  final int secondsLeft;
  final int score;
  final TextEditingController answerController;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final difficultyColor = AppColors.difficulty(question.difficulty);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  GameTopBar(
                    difficulty: question.difficulty,
                    index: index,
                    total: total,
                    secondsLeft: secondsLeft,
                    onBack: onBack,
                  ),
                  const SizedBox(height: 16),
                  CutePanel(
                    decoration: question.difficulty == Difficulty.extreme
                        ? PanelDecoration.night
                        : PanelDecoration.leaf,
                    child: Padding(
                      padding: EdgeInsets.all(compact ? 16 : 24),
                      child: Column(
                        children: [
                          BrownBadge(text: 'REGULAR EXPRESSION'),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 22,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cream,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.peachStroke,
                                width: 2,
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                question.pattern,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: difficultyColor,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: PinkLabel(
                              text: 'Enter a string that matches:',
                            ),
                          ),
                          TextField(
                            controller: answerController,
                            onSubmitted: (_) => onSubmit(),
                            decoration: InputDecoration(
                              hintText: 'Type your answer here...',
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.9),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 18,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: AppColors.brown.withValues(
                                    alpha: 0.45,
                                  ),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: AppColors.pink,
                                  width: 3,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: AppColors.brown,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          HintBox(text: question.hint),
                          const SizedBox(height: 18),
                          CuteGameButton(
                            label: 'SUBMIT',
                            icon: Icons.near_me,
                            onPressed: onSubmit,
                            green: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ScoreTile(label: 'SCORE', value: '$score'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ScoreTile(
                          label: 'TIME LEFT',
                          value: '${secondsLeft}s',
                          icon: Icons.alarm,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
