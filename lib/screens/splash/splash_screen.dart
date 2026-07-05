import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _logoScale;
  late Animation<double> _pulse;
  late Animation<double> _fadeIn;
  late Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF5F7), Colors.white, Color(0xFFFFFAFB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo area
              Center(
                child: ScaleTransition(
                  scale: _logoScale,
                  child: AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, child) => Transform.scale(
                      scale: _pulse.value,
                      child: child,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow circle
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.15),
                                AppColors.primary.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                        // Logo container
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF9DAD), Color(0xFFEC7A92)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: _buildLogo(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // App name
              ScaleTransition(
                scale: _logoScale,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFEC7A92), Color(0xFFD4607A)],
                  ).createShader(bounds),
                  child: const Text(
                    'PETNER',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Tagline
              FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _taglineSlide,
                  child: Text(
                    AppConstants.appTagline,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // Paw prints decoration
              FadeTransition(
                opacity: _fadeIn,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPawDot(large: false),
                    const SizedBox(width: 8),
                    _buildPawDot(large: true),
                    const SizedBox(width: 8),
                    _buildPawDot(large: false),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      AppConstants.logoAsset,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.pets,
        color: Colors.white,
        size: 56,
      ),
    );
  }

  Widget _buildPawDot({required bool large}) {
    return Container(
      width: large ? 10 : 7,
      height: large ? 10 : 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(large ? 0.6 : 0.3),
      ),
    );
  }
}
