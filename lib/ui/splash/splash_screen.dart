import 'package:flutter/material.dart';
import '../wrapper/main_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.hexagon_outlined, size: 120, color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)),
                Icon(Icons.currency_exchange, size: 70, color: Theme.of(context).colorScheme.secondary),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Icon(Icons.trending_up, size: 40, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'RATESHIFT',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}