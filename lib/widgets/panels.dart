part of '../main.dart';

class CutePanel extends StatelessWidget {
  const CutePanel({required this.child, this.dark = false, super.key});

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 680),
      decoration: BoxDecoration(
        color: dark ? AppColors.plum.withValues(alpha: 0.96) : AppColors.panel,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: dark ? AppColors.brown : AppColors.peachStroke,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.withValues(alpha: 0.22),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 12,
            child: Image.asset('assets/decorations/flower_06.png', width: 34),
          ),
          Positioned(
            bottom: 8,
            right: 12,
            child: Image.asset('assets/decorations/leaf_01.png', width: 38),
          ),
          child,
        ],
      ),
    );
  }
}

class HeaderRibbon extends StatelessWidget {
  const HeaderRibbon({required this.title, required this.onBack, super.key});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          IconButton.filled(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.pink,
              foregroundColor: AppColors.cream,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.brown, width: 2),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.cream,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
