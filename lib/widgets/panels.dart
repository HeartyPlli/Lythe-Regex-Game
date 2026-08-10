part of '../main.dart';

//=========================================================================
// Ui panels is here for reusable cute panel and header ribbon.
//=========================================================================
enum PanelDecoration { blossom, leaf, mushroom, character, meadow, night }

class CutePanel extends StatelessWidget {
  const CutePanel({
    required this.child,
    this.dark = false,
    this.decoration = PanelDecoration.blossom,
    super.key,
  });

  final Widget child;
  final bool dark;
  final PanelDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 760),
      decoration: BoxDecoration(
        color: dark ? AppColors.plum.withValues(alpha: 0.96) : AppColors.panel,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: dark ? AppColors.brown : AppColors.peachStroke,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.withValues(alpha: 0.22),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(children: [..._insideBorderDecorations(), child]),
    );
  }

  List<Widget> _insideBorderDecorations() {
    return switch (decoration) {
      PanelDecoration.blossom => [
        _PanelDecorationImage(
          top: 8,
          left: 12,
          asset: 'assets/decorations/flower_06.png',
          width: 34,
        ),
        _PanelDecorationImage(
          bottom: 8,
          right: 12,
          asset: 'assets/decorations/leaf_01.png',
          width: 38,
        ),
      ],
      PanelDecoration.leaf => [
        _PanelDecorationImage(
          top: 8,
          right: 12,
          asset: 'assets/decorations/leaf_02.png',
          width: 42,
        ),
        _PanelDecorationImage(
          bottom: 8,
          left: 12,
          asset: 'assets/decorations/flower_14.png',
          width: 34,
        ),
      ],
      PanelDecoration.mushroom => [
        _PanelDecorationImage(
          bottom: 8,
          left: 12,
          asset: 'assets/decorations/mushroom_06.png',
          width: 46,
        ),
        _PanelDecorationImage(
          top: 8,
          right: 12,
          asset: 'assets/decorations/flower_16.png',
          width: 42,
        ),
      ],
      PanelDecoration.character => [
        _PanelDecorationImage(
          bottom: 6,
          left: 10,
          asset: 'assets/decorations/character_02.png',
          width: 46,
        ),
        _PanelDecorationImage(
          top: 8,
          right: 12,
          asset: 'assets/decorations/leaf_10.png',
          width: 38,
        ),
      ],
      PanelDecoration.meadow => [
        _PanelDecorationImage(
          top: 8,
          left: 12,
          asset: 'assets/decorations/flower_34.png',
          width: 54,
        ),
        _PanelDecorationImage(
          bottom: 8,
          right: 12,
          asset: 'assets/decorations/mushroom_15.png',
          width: 52,
        ),
      ],
      PanelDecoration.night => [
        _PanelDecorationImage(
          top: 8,
          right: 12,
          asset: 'assets/decorations/character_05.png',
          width: 46,
        ),
        _PanelDecorationImage(
          bottom: 8,
          left: 12,
          asset: 'assets/decorations/mushroom_14.png',
          width: 48,
        ),
      ],
    };
  }
}

//=========================================================================
// This class is about _PanelDecorationImage thing.
//=========================================================================
class _PanelDecorationImage extends StatelessWidget {
  const _PanelDecorationImage({
    required this.asset,
    required this.width,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  final String asset;
  final double width;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: IgnorePointer(
        child: Image.asset(asset, width: width, fit: BoxFit.contain),
      ),
    );
  }
}

//=========================================================================
// This class is about HeaderRibbon thing.
//=========================================================================
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
