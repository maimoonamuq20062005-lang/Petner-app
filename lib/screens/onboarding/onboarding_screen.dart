import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  final List<OnboardingData> _pages = [
    OnboardingData(
      emoji: '🐾',
      title: 'Discover Nearby Pets',
      subtitle:
          'Explore adorable pets in your neighborhood looking for the perfect companion match.',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF0F3), Color(0xFFFFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      accentColor: AppColors.primary,
      illustrationIcon: Icons.location_on_rounded,
    ),
    OnboardingData(
      emoji: '💕',
      title: 'Match & Connect',
      subtitle:
          'Swipe, like, and find the ideal companion for your furry friend with smart matching.',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF5F7), Color(0xFFFFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      accentColor: Color(0xFFFF6B8A),
      illustrationIcon: Icons.favorite_rounded,
    ),
    OnboardingData(
      emoji: '💬',
      title: 'Chat Safely',
      subtitle:
          'Connect with pet owners through our secure, friendly messaging platform.',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF8F9), Color(0xFFFFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      accentColor: Color(0xFFEC7A92),
      illustrationIcon: Icons.chat_bubble_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            onPageChanged: (val) => setState(() => _currentPage = val),
            itemCount: _pages.length,
            itemBuilder: (_, index) => _buildPage(_pages[index], size),
          ),
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: TextButton(
              onPressed: _navigateToLogin,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  32, 24, 32, MediaQuery.of(context).padding.bottom + 32),
              child: Column(
                children: [
                  // Dots indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.primaryLighter,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Next / Get Started button
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9DAD), Color(0xFFEC7A92)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppShadows.button,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? "Let's Get Started"
                                : 'Continue',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data, Size size) {
    return Container(
      decoration: BoxDecoration(gradient: data.gradient),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 60),
          // Illustration
          Expanded(
            flex: 3,
            child: AnimatedBuilder(
              animation: _floatAnim,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: child,
              ),
              child: _buildIllustration(data),
            ),
          ),
          // Text content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data.subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 160),
        ],
      ),
    );
  }

  Widget _buildIllustration(OnboardingData data) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  data.accentColor.withOpacity(0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Main illustration card
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: AppShadows.card,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.emoji, style: const TextStyle(fontSize: 72)),
                const SizedBox(height: 8),
                Icon(data.illustrationIcon,
                    color: data.accentColor.withOpacity(0.5), size: 28),
              ],
            ),
          ),
          // Floating paw accents
          ..._buildPawAccents(data.accentColor),
        ],
      ),
    );
  }

  List<Widget> _buildPawAccents(Color color) {
    return [
      Positioned(
        top: 30,
        right: 60,
        child: _miniPaw(color, 0.7),
      ),
      Positioned(
        bottom: 40,
        left: 50,
        child: _miniPaw(color, 0.5),
      ),
      Positioned(
        top: 70,
        left: 40,
        child: _miniPaw(color, 0.4),
      ),
    ];
  }

  Widget _miniPaw(Color color, double opacity) {
    return Icon(Icons.pets, color: color.withOpacity(opacity), size: 22);
  }
}

class OnboardingData {
  final String emoji;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final Color accentColor;
  final IconData illustrationIcon;

  const OnboardingData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.accentColor,
    required this.illustrationIcon,
  });
}
