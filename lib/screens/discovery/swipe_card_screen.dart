import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../models/pet_model.dart';
import '../../providers/pet_provider.dart';
import '../discovery/pet_detail_screen.dart';
import '../match/match_screen.dart';

class SwipeCardScreen extends StatefulWidget {
  const SwipeCardScreen({super.key});

  @override
  State<SwipeCardScreen> createState() => _SwipeCardScreenState();
}

class _SwipeCardScreenState extends State<SwipeCardScreen>
    with SingleTickerProviderStateMixin {
  final CardSwiperController _swiperController = CardSwiperController();
  late AnimationController _feedbackController;
  String? _feedbackLabel;
  Color? _feedbackColor;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().loadSampleData();
    });
  }

  @override
  void dispose() {
    _swiperController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _showFeedback(String label, Color color) {
    setState(() {
      _feedbackLabel = label;
      _feedbackColor = color;
    });
    _feedbackController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          _feedbackController.reverse().then((_) {
            setState(() => _feedbackLabel = null);
          });
        }
      });
    });
  }

  void _onLike(PetModel pet) {
    _showFeedback('❤️ Like!', AppColors.primary);
    context.read<PetProvider>().swipeRight(pet);
    // Simulate match
    if (pet.id == '1') {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => MatchScreen(pet: pet),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder: (_, anim, __, child) =>
                  FadeTransition(opacity: anim, child: child),
            ),
          );
        }
      });
    }
  }

  void _onPass(PetModel pet) {
    _showFeedback('👋 Pass', AppColors.textSecondary);
    context.read<PetProvider>().swipeLeft(pet);
  }

  @override
  Widget build(BuildContext context) {
    final pets = context.watch<PetProvider>().discoverPets;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFEC7A92), Color(0xFFD4607A)],
                    ).createShader(bounds),
                    child: const Text(
                      'PETNER',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildIconButton(Icons.tune_rounded, () {}),
                  const SizedBox(width: 8),
                  _buildIconButton(Icons.notifications_outlined, () {}),
                ],
              ),
            ),
            // Cards
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (pets.isEmpty)
                    _buildEmptyState()
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CardSwiper(
                        controller: _swiperController,
                        cardsCount: pets.length,
                        numberOfCardsDisplayed: pets.length >= 3 ? 3 : pets.length,
                        backCardOffset: const Offset(0, 24),
                        scale: 0.93,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        onSwipe: (prev, curr, direction) {
                          if (direction == CardSwiperDirection.right) {
                            _onLike(pets[prev]);
                          } else if (direction == CardSwiperDirection.left) {
                            _onPass(pets[prev]);
                          }
                          return true;
                        },
                        cardBuilder: (ctx, index, h, v) =>
                            _buildCard(pets[index]),
                      ),
                    ),
                  // Feedback overlay
                  if (_feedbackLabel != null)
                    AnimatedBuilder(
                      animation: _feedbackController,
                      builder: (_, __) => Opacity(
                        opacity: _feedbackController.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 14),
                          decoration: BoxDecoration(
                            color: _feedbackColor!.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            _feedbackLabel!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Action buttons
            _buildActionButtons(pets),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(PetModel pet) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PetDetailScreen(pet: pet)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppShadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Pet image
              pet.photoUrls.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: pet.photoUrls.first,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.primaryLighter,
                        child: const Center(
                            child: Icon(Icons.pets,
                                size: 60, color: AppColors.primary)),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.primaryLighter,
                        child: const Center(
                            child: Icon(Icons.pets,
                                size: 60, color: AppColors.primary)),
                      ),
                    )
                  : Container(
                      color: AppColors.primaryLighter,
                      child: const Center(
                          child: Icon(Icons.pets,
                              size: 80, color: AppColors.primary)),
                    ),
              // Gradient overlay
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.cardOverlayGradient,
                  ),
                ),
              ),
              // Quick badges top
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    _buildBadge(pet.energyLevel, Icons.flash_on_rounded),
                    const SizedBox(height: 8),
                    _buildBadge(pet.size, Icons.straighten_rounded),
                  ],
                ),
              ),
              // Vaccinated badge
              if (pet.isVaccinated)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded,
                            color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text('Vaccinated',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
              // Pet info at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${pet.name}, ${pet.ageDisplay}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.25),
                            ),
                            child: const Icon(Icons.info_outline_rounded,
                                color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.pets,
                              color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            pet.breed,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.location_on_outlined,
                              color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              pet.locationName ?? 'Nearby',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        children: [
                          _infoChip(pet.gender),
                          _infoChip(pet.socialBehaviour),
                          _infoChip(pet.livingEnvironment),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(List<PetModel> pets) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pass button
          _actionButton(
            icon: Icons.close_rounded,
            color: Colors.white,
            iconColor: AppColors.textSecondary,
            size: 60,
            shadow: AppShadows.soft,
            onTap: () => _swiperController.swipe(CardSwiperDirection.left),
          ),
          // Super Like button
          _actionButton(
            icon: Icons.star_rounded,
            color: const Color(0xFF60A5FA),
            iconColor: Colors.white,
            size: 50,
            shadow: [
              BoxShadow(
                  color: const Color(0xFF60A5FA).withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6))
            ],
            onTap: () {},
          ),
          // Like button
          _actionButton(
            icon: Icons.favorite_rounded,
            color: AppColors.primary,
            iconColor: Colors.white,
            size: 60,
            shadow: AppShadows.button,
            onTap: () => _swiperController.swipe(CardSwiperDirection.right),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required double size,
    required List<BoxShadow> shadow,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: shadow,
        ),
        child: Icon(icon, color: iconColor, size: size * 0.45),
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _infoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          boxShadow: AppShadows.soft,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 22),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🐾', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 20),
        const Text(
          'No more pets nearby!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Check back later or expand your search area',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => context.read<PetProvider>().resetSwipes(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: AppShadows.button,
            ),
            child: const Text(
              'Refresh 🔄',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
