import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../models/pet_model.dart';
import '../chat/chat_list_screen.dart';

class MatchScreen extends StatefulWidget {
  final PetModel pet;

  const MatchScreen({super.key, required this.pet});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _floatController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnim;
  late Animation<double> _floatAnim;

  final List<_ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnim = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Generate confetti particles
    for (int i = 0; i < 30; i++) {
      _particles.add(_ConfettiParticle());
    }

    _scaleController.forward();
    _confettiController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _floatController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myPet = PetSampleData.samples.first;
    final matchedPet = widget.pet;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE4EC), Color(0xFFFFF0F5), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Confetti
              AnimatedBuilder(
                animation: _confettiController,
                builder: (_, __) => CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _ConfettiPainter(
                    _particles,
                    _confettiController.value,
                  ),
                ),
              ),
              // Main content
              Column(
                children: [
                  const SizedBox(height: 48),
                  // Match header
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: AppShadows.button,
                          ),
                          child: const Center(
                            child: Text('🎉', style: TextStyle(fontSize: 32)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFFEC7A92), Color(0xFFD4607A)],
                          ).createShader(bounds),
                          child: const Text(
                            "It's a Match!",
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${myPet.name} and ${matchedPet.name} are a perfect match 🐾',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Pet avatars with hearts
                  AnimatedBuilder(
                    animation: _floatAnim,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(0, _floatAnim.value),
                      child: child,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPetAvatar(myPet, isMyPet: true),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('💕', style: TextStyle(fontSize: 36)),
                              SizedBox(height: 8),
                              Text('❤️', style: TextStyle(fontSize: 24)),
                            ],
                          ),
                        ),
                        _buildPetAvatar(matchedPet, isMyPet: false),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => ChatListScreen()),
                            );
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: AppShadows.button,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_rounded,
                                    color: Colors.white, size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'Start Chatting!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Keep Swiping',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetAvatar(PetModel pet, {required bool isMyPet}) {
    return Column(
      children: [
        Container(
          width: 115,
          height: 115,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 3.5,
            ),
            boxShadow: AppShadows.card,
          ),
          child: ClipOval(
            child: pet.photoUrls.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: pet.photoUrls.first,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.primaryLighter,
                      child: const Center(
                          child:
                              Icon(Icons.pets, size: 40, color: AppColors.primary)),
                    ),
                  )
                : Container(
                    color: AppColors.primaryLighter,
                    child: const Center(
                        child:
                            Icon(Icons.pets, size: 40, color: AppColors.primary)),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          pet.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          pet.breed,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        if (isMyPet)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLighter,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'You',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _ConfettiParticle {
  late double x;
  late double y;
  late Color color;
  late double size;
  late double speed;
  late double angle;

  _ConfettiParticle() {
    _reset();
  }

  void _reset() {
    x = (0.1 + 0.8 * DateTime.now().microsecond / 1000000);
    y = -0.05;
    final colors = [
      AppColors.primary,
      const Color(0xFF60A5FA),
      const Color(0xFF34D399),
      const Color(0xFFFBBF24),
      const Color(0xFFFF9DAD),
    ];
    color = colors[DateTime.now().microsecond % colors.length];
    size = 6 + (DateTime.now().millisecond % 8);
    speed = 0.003 + (DateTime.now().microsecond % 5) * 0.001;
    angle = -0.5 + (DateTime.now().microsecond % 100) / 100;
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()..color = p.color.withOpacity(1 - progress * 0.5);
      final x = (p.x + p.angle * progress) * size.width;
      final y = (p.y + progress * p.speed * 500) * size.height;
      canvas.drawCircle(Offset(x, y), p.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
