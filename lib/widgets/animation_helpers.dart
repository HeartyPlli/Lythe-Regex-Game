part of '../main.dart';

class PopupScrim extends StatelessWidget {
  const PopupScrim({required this.child, this.transparent = false, super.key});

  final Widget child;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: transparent
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.black.withValues(alpha: 0.52),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: child,
        ),
      ),
    );
  }
}

class AnimatedAppear extends StatefulWidget {
  const AnimatedAppear({required this.child, super.key});

  final Widget child;

  @override
  State<AnimatedAppear> createState() => _AnimatedAppearState();
}

class _AnimatedAppearState extends State<AnimatedAppear>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  )..forward();
  late final Animation<double> _scale = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutBack,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.86, end: 1).animate(_scale),
        child: widget.child,
      ),
    );
  }
}

class FloatingSprite extends StatefulWidget {
  const FloatingSprite({required this.child, super.key});

  final Widget child;

  @override
  State<FloatingSprite> createState() => _FloatingSpriteState();
}

class _FloatingSpriteState extends State<FloatingSprite>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
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
        return Transform.translate(
          offset: Offset(0, sin(_controller.value * pi) * -10),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class SwayingSprite extends StatefulWidget {
  const SwayingSprite({required this.child, required this.delay, super.key});

  final Widget child;
  final double delay;

  @override
  State<SwayingSprite> createState() => _SwayingSpriteState();
}

class _SwayingSpriteState extends State<SwayingSprite>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

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
        final t = (_controller.value + widget.delay) * pi * 2;
        return Transform.translate(
          offset: Offset(0, sin(t) * 5),
          child: Transform.rotate(angle: sin(t) * 0.035, child: child),
        );
      },
      child: widget.child,
    );
  }
}

class BreathingSprite extends StatefulWidget {
  const BreathingSprite({required this.child, super.key});

  final Widget child;

  @override
  State<BreathingSprite> createState() => _BreathingSpriteState();
}

class _BreathingSpriteState extends State<BreathingSprite>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
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
      builder: (context, child) =>
          Transform.scale(scale: 1 + _controller.value * 0.025, child: child),
      child: widget.child,
    );
  }
}

class Shake extends StatefulWidget {
  const Shake({required this.child, super.key});

  final Widget child;

  @override
  State<Shake> createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(sin(_controller.value * pi * 8) * 10, 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}
