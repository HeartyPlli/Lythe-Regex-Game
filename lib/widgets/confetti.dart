part of '../main.dart';

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({this.huge = false, super.key});

  final bool huge;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.huge
        ? const Duration(seconds: 4)
        : const Duration(seconds: 3),
  )..repeat();
  late final List<_ConfettiPiece> _pieces = List.generate(
    widget.huge ? 180 : 80,
    (index) => _ConfettiPiece(Random(index + 7)),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Positioned.fill(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => CustomPaint(
            painter: _ConfettiPainter(_pieces, _controller.value),
          ),
        ),
      ),
    );
  }
}

class _ConfettiPiece {
  _ConfettiPiece(Random random)
    : x = random.nextDouble(),
      y = random.nextDouble(),
      speed = 0.35 + random.nextDouble() * 0.65,
      size = 5 + random.nextDouble() * 7,
      color = [
        AppColors.pink,
        AppColors.gold,
        AppColors.green,
        AppColors.palePink,
      ][random.nextInt(4)];

  final double x;
  final double y;
  final double speed;
  final double size;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter(this.pieces, this.progress);

  final List<_ConfettiPiece> pieces;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final dy =
          ((piece.y + progress * piece.speed) % 1.15) * size.height -
          size.height * 0.1;
      final dx = piece.x * size.width + sin((progress + piece.x) * pi * 4) * 18;
      final paint = Paint()..color = piece.color.withValues(alpha: 0.85);
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate((progress + piece.x) * pi * 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: piece.size * 0.75,
            height: piece.size * 1.6,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
