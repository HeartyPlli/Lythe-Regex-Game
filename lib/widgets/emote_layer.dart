part of '../main.dart';

//=========================================================================
// Ui emote layer is here for showing character feedback.
//=========================================================================
class EmoteLayer extends StatelessWidget {
  const EmoteLayer({required this.state, super.key});

  final EmoteState state;

  String get _asset {
    return switch (state) {
      EmoteState.loading => 'assets/image/Loading.png',
      EmoteState.incorrect => 'assets/image/Mad.png',
      EmoteState.timeOut => 'assets/image/Sad.png',
      EmoteState.failed => 'assets/image/Sad.png',
      EmoteState.extremeHard => 'assets/image/Shock.png',
      EmoteState.success => 'assets/image/Yay.png',
      EmoteState.logout => 'assets/image/Oh.png',
      EmoteState.none => 'assets/image/Yay.png',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (state == EmoteState.logout) {
      return const SizedBox.shrink();
    }
    final shake =
        state == EmoteState.incorrect || state == EmoteState.extremeHard;
    final child = Image.asset(
      _asset,
      height: state == EmoteState.extremeHard ? 210 : 180,
      fit: BoxFit.contain,
    );
    return IgnorePointer(
      child: Align(
        alignment:
            state == EmoteState.incorrect ||
                state == EmoteState.timeOut ||
                state == EmoteState.failed
            ? Alignment.topCenter
            : Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 68),
          child: AnimatedAppear(child: shake ? Shake(child: child) : child),
        ),
      ),
    );
  }
}
