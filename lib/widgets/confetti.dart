part of '../main.dart';

//=========================================================================
// Ui confetti is here for correct answer pop and finish celebration.
//=========================================================================
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({this.huge = false, super.key});

  final bool huge;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

//=========================================================================
// This class is about _ConfettiOverlayState thing.
//=========================================================================
class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.huge
        ? const Duration(milliseconds: 5200)
        : const Duration(milliseconds: 2200),
  )..forward();
  late final List<_ConfettiPiece> _pieces = List.generate(
    widget.huge ? 640 : 130,
    (index) => _ConfettiPiece(Random(index + 7), huge: widget.huge),
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
            painter: _ConfettiPainter(
              _pieces,
              Curves.easeOut.transform(_controller.value),
              widget.huge,
            ),
          ),
        ),
      ),
    );
  }
}

//=========================================================================
// This class is about _ConfettiPiece thing.
//=========================================================================
class _ConfettiPiece {
  _ConfettiPiece(Random random, {required bool huge})
    : angle = -pi + random.nextDouble() * pi,
      distance = (huge ? 470 : 210) + random.nextDouble() * (huge ? 620 : 190),
      drift = (random.nextDouble() - 0.5) * (huge ? 180 : 78),
      speed = (huge ? 0.72 : 0.42) + random.nextDouble() * (huge ? 1.2 : 0.72),
      size = (huge ? 12 : 6) + random.nextDouble() * (huge ? 22 : 9),
      spin = (random.nextBool() ? 1 : -1) * (2 + random.nextDouble() * 4),
      shape = random.nextInt(4),
      color = [
        AppColors.pink,
        AppColors.gold,
        AppColors.green,
        AppColors.palePink,
        AppColors.cream,
        Colors.white,
      ][random.nextInt(6)];

  final double angle;
  final double distance;
  final double drift;
  final double speed;
  final double size;
  final double spin;
  final int shape;
  final Color color;
}

//=========================================================================
// This class is about _ConfettiPainter thing.
//=========================================================================
class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter(this.pieces, this.progress, this.huge);

  final List<_ConfettiPiece> pieces;
  final double progress;
  final bool huge;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width * 0.5, size.height * (huge ? 0.42 : 0.35));
    final fade = (1 - progress).clamp(0.0, 1.0);
    final popScale = huge
        ? 0.7 + sin(progress * pi).clamp(0.0, 1.0) * 0.75
        : 0.75 + sin(progress * pi).clamp(0.0, 1.0) * 0.4;
    for (final piece in pieces) {
      final travel = piece.distance * progress * piece.speed;
      final dx =
          cos(piece.angle) * travel +
          sin((progress + piece.angle) * pi * (huge ? 5 : 3)) * piece.drift;
      final dy =
          sin(piece.angle) * travel + (huge ? 560 : 210) * progress * progress;
      final paint = Paint()
        ..color = piece.color.withValues(alpha: (0.25 + fade * 0.75) * 0.95);
      canvas.save();
      canvas.translate(origin.dx + dx, origin.dy + dy);
      canvas.rotate(progress * pi * piece.spin + piece.angle);
      canvas.scale(popScale);
      switch (piece.shape) {
        case 0:
          canvas.drawCircle(Offset.zero, piece.size * 0.42, paint);
        case 1:
          canvas.drawPath(
            Path()
              ..moveTo(0, -piece.size * 0.85)
              ..lineTo(piece.size * 0.75, piece.size * 0.6)
              ..lineTo(-piece.size * 0.75, piece.size * 0.6)
              ..close(),
            paint,
          );
        default:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: piece.size * 0.78,
                height: piece.size * 1.7,
              ),
              const Radius.circular(2),
            ),
            paint,
          );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
