import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// These must point correctly to your core files
import '../../core/routes.dart';
import '../../core/theme.dart';
// This is the one causing the "Target of URI doesn't exist"
import '../home/home_screen.dart';

// Brand Colors - Deep Cloak Palette
const Color lightBlueAccent = Color(0xFF00E5FF);
const Color secondaryBlue = Color(0xFF007BFF); // Sharper blue for better contrast

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  // Inside _SplashScreenState
  void _navigateToNext() async {
    // Ensure background initialization (like Hive) has a moment to settle
    await Future.delayed(const Duration(seconds: 5)); // Increased from 4 to 5 for safety

    if (mounted) {
      // Use a custom PageRouteBuilder for a "Fade" transition instead of a slide
      // This prevents the "flash" of a loading circle between screens
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using a Container with a Radial Gradient to give the screen depth
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF0A0D3A), // Midnight center
              Color(0xFF000115), // Near-black edges
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Icon with Gradient Mask and Outer Glow
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: lightBlueAccent.withValues(alpha: 0.15),
                      blurRadius: 50,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [lightBlueAccent, secondaryBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.fingerprint,
                    size: 90,
                    color: Colors.white, // Base color for mask
                  ),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scaleXY(end: 1.1, duration: 1000.ms, curve: Curves.easeInOut)
                  .shimmer(
                color: Colors.white.withValues(alpha: 0.3),
                duration: 1500.ms,
              ),

              const SizedBox(height: 40),

              // 2. Main Title in Pure White with High Spacing
              Text(
                "DEEP CLOAK",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  letterSpacing: 10, // Increased for a premium look
                  fontWeight: FontWeight.w900,
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

              const SizedBox(height: 12),

              // 3. Modern, thin Loading bar instead of just text
              SizedBox(
                width: 150,
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  valueColor: const AlwaysStoppedAnimation<Color>(lightBlueAccent),
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 20),

              // 4. Secondary Status Text
              Text(
                "ENCRYPTING TERMINAL...",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w400,
                ),
              )
                  .animate()
                  .fadeIn(delay: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }
}