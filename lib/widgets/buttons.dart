part of '../main.dart';

class CuteGameButton extends StatefulWidget {
  const CuteGameButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.large = false,
    this.green = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool large;
  final bool green;

  @override
  State<CuteGameButton> createState() => _CuteGameButtonState();
}

class _CuteGameButtonState extends State<CuteGameButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.green ? AppColors.green : AppColors.pink;
    final scale = _pressed ? 0.96 : (_hovered ? 1.025 : 1.0);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Container(
            constraints: BoxConstraints(
              minWidth: widget.large ? 300 : 220,
              minHeight: widget.large ? 76 : 56,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.brown, width: 2.4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brown.withValues(alpha: 0.35),
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.35),
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: AppColors.cream,
                  size: widget.large ? 38 : 24,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: widget.large ? 26 : 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                      shadows: [
                        Shadow(
                          color: AppColors.brown.withValues(alpha: 0.55),
                          offset: const Offset(1, 2),
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
  }
}

class CuteIconButton extends StatelessWidget {
  const CuteIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: CuteGameButton(
        label: label.toUpperCase(),
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
