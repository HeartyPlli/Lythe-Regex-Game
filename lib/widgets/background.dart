part of '../main.dart';

class AnimatedGameBackground extends StatefulWidget {
  const AnimatedGameBackground({super.key});

  @override
  State<AnimatedGameBackground> createState() => _AnimatedGameBackgroundState();
}

class _AnimatedGameBackgroundState extends State<AnimatedGameBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = (_controller.value - 0.5) * 10;
        return Positioned.fill(
          child: Transform.translate(
            offset: Offset(offset, -offset * 0.35),
            child: Transform.scale(
              scale: 1.035,
              child: Image.asset(
                'assets/image/Background.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
