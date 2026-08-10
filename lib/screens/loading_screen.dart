part of '../main.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/image/Loading.png',
            width: 280,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          Text(
            'Loading...',
            style: TextStyle(
              color: AppColors.brown,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
