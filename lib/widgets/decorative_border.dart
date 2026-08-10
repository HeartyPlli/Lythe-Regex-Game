part of '../main.dart';

//=========================================================================
// Ui decorative border is here for flower leaf mushroom frame.
//=========================================================================
class DecorativeBorder extends StatelessWidget {
  const DecorativeBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final small = constraints.maxWidth < 560;
          final flowerSize = small ? 58.0 : 84.0;
          final mushroomSize = small ? 56.0 : 86.0;
          return Stack(
            children: [
              Positioned(
                left: 8,
                top: 92,
                child: SwayingSprite(
                  delay: 0,
                  child: Image.asset(
                    'assets/decorations/flower_34.png',
                    width: flowerSize,
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 118,
                child: SwayingSprite(
                  delay: .6,
                  child: Image.asset(
                    'assets/decorations/leaf_02.png',
                    width: flowerSize,
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 96,
                child: SwayingSprite(
                  delay: 1.2,
                  child: Image.asset(
                    'assets/decorations/flower_35.png',
                    width: flowerSize,
                  ),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 92,
                child: SwayingSprite(
                  delay: .2,
                  child: Image.asset(
                    'assets/decorations/flower_16.png',
                    width: flowerSize,
                  ),
                ),
              ),
              Positioned(
                left: 18,
                bottom: 12,
                child: BreathingSprite(
                  child: Image.asset(
                    'assets/decorations/mushroom_06.png',
                    width: mushroomSize,
                  ),
                ),
              ),
              Positioned(
                right: 18,
                bottom: 10,
                child: BreathingSprite(
                  child: Image.asset(
                    'assets/decorations/mushroom_15.png',
                    width: mushroomSize,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
