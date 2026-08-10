part of '../main.dart';

//=========================================================================
// Ui game component is here for cards bars badges and score tiles.
//=========================================================================
class DifficultyRow extends StatelessWidget {
  const DifficultyRow({
    required this.difficulty,
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final Difficulty difficulty;
  final String title;
  final String subtitle;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.difficulty(difficulty);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.peachStroke, width: 2),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 52, height: 52, fit: BoxFit.contain),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.brown,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            difficulty == Difficulty.extreme
                ? Icons.workspace_premium
                : Icons.star,
            color: AppColors.gold,
            size: 34,
          ),
        ],
      ),
    );
  }
}

//=========================================================================
// This class is about GameTopBar thing.
//=========================================================================
class GameTopBar extends StatelessWidget {
  const GameTopBar({
    required this.difficulty,
    required this.index,
    required this.total,
    required this.secondsLeft,
    required this.onBack,
    super.key,
  });

  final Difficulty difficulty;
  final int index;
  final int total;
  final int secondsLeft;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final progress = (index + 1) / total;
    final lowTime = secondsLeft <= 5;
    return CutePanel(
      decoration: lowTime
          ? PanelDecoration.mushroom
          : difficulty == Difficulty.extreme
          ? PanelDecoration.night
          : PanelDecoration.leaf,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                IconButton.filled(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.cream,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.difficulty(difficulty),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.brown, width: 2),
                  ),
                  child: Text(
                    difficultyLabel(difficulty),
                    style: TextStyle(
                      color: AppColors.cream,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Question ${index + 1} / $total',
                  style: TextStyle(
                    color: AppColors.brown,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                TimerPill(seconds: secondsLeft),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 13,
                color: AppColors.pink,
                backgroundColor: AppColors.brown.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//=========================================================================
// This class is about TimerPill thing.
//=========================================================================
class TimerPill extends StatelessWidget {
  const TimerPill({required this.seconds, super.key});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.peachStroke, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: AppColors.pink, size: 22),
          const SizedBox(width: 4),
          Text(
            '${seconds}s',
            style: TextStyle(
              color: AppColors.brown,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

//=========================================================================
// This class is about BrownBadge thing.
//=========================================================================
class BrownBadge extends StatelessWidget {
  const BrownBadge({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.brown,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: AppColors.cream, fontWeight: FontWeight.w900),
      ),
    );
  }
}

//=========================================================================
// This class is about PinkLabel thing.
//=========================================================================
class PinkLabel extends StatelessWidget {
  const PinkLabel({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.pink,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Text(
        text,
        style: TextStyle(color: AppColors.cream, fontWeight: FontWeight.w900),
      ),
    );
  }
}

//=========================================================================
// This class is about HintBox thing.
//=========================================================================
class HintBox extends StatelessWidget {
  const HintBox({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.peachStroke, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lightbulb, color: AppColors.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.brown,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//=========================================================================
// This class is about locked hint box thing.
//=========================================================================
class LockedHintBox extends StatelessWidget {
  const LockedHintBox({
    required this.text,
    required this.unlocked,
    required this.canUnlock,
    required this.onUnlock,
    super.key,
  });

  final String text;
  final bool unlocked;
  final bool canUnlock;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final shownText = unlocked
        ? text
        : canUnlock
        ? 'Hint is locked. Tap to unlock. This will take 5 points.'
        : 'Hint is locked. You need at least 5 points to unlock it.';
    return GestureDetector(
      onTap: unlocked || !canUnlock ? null : onUnlock,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: unlocked ? AppColors.cream : AppColors.palePink,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.peachStroke, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              unlocked ? Icons.lightbulb : Icons.lock,
              color: unlocked ? AppColors.gold : AppColors.pink,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                shownText,
                style: TextStyle(
                  color: AppColors.brown,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//=========================================================================
// This class is about ScoreTile thing.
//=========================================================================
class ScoreTile extends StatelessWidget {
  const ScoreTile({
    required this.label,
    required this.value,
    this.icon,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.peachStroke, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: AppColors.pink),
          if (icon != null) const SizedBox(width: 6),
          Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.pink,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.brown,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//=========================================================================
// This class is about LeaderboardRow thing.
//=========================================================================
class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({required this.entry, super.key});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.peachStroke, width: 1.5),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '${entry.rank}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.brown,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Image.asset(entry.asset, width: 42, height: 42, fit: BoxFit.contain),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              entry.player,
              style: TextStyle(
                color: AppColors.brown,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            '${entry.score}',
            style: TextStyle(
              color: AppColors.brown,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 70,
            child: Text(
              entry.level,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.pink,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//=========================================================================
// This class is about PodiumPlace thing.
//=========================================================================
class PodiumPlace extends StatelessWidget {
  const PodiumPlace({
    required this.rank,
    required this.asset,
    required this.height,
    super.key,
  });

  final int rank;
  final String asset;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(asset, width: 78, height: 78, fit: BoxFit.contain),
        Container(
          width: 80,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: rank == 1 ? AppColors.pink : AppColors.lightBrown,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            border: Border.all(color: AppColors.brown, width: 2),
          ),
          child: Text(
            '$rank',
            style: TextStyle(
              color: AppColors.cream,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

//=========================================================================
// This class is about InfoCard thing.
//=========================================================================
class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.peachStroke, width: 2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.green,
              foregroundColor: AppColors.cream,
              child: Icon(icon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.brown,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.brown.withValues(alpha: 0.82),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
