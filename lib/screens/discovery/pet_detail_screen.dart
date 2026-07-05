import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../models/pet_model.dart';
import '../chat/chat_screen.dart';

class PetDetailScreen extends StatefulWidget {
  final PetModel pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  int _currentImageIndex = 0;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Image gallery sliver
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.35),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.35),
                  ),
                  child: const Icon(Icons.share_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image view
                  if (pet.photoUrls.isNotEmpty)
                    PageView.builder(
                      itemCount: pet.photoUrls.length,
                      onPageChanged: (i) =>
                          setState(() => _currentImageIndex = i),
                      itemBuilder: (_, i) => CachedNetworkImage(
                        imageUrl: pet.photoUrls[i],
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                            color: AppColors.primaryLighter,
                            child: const Center(
                                child: Icon(Icons.pets,
                                    size: 60, color: AppColors.primary))),
                        errorWidget: (_, __, ___) => Container(
                            color: AppColors.primaryLighter,
                            child: const Center(
                                child: Icon(Icons.pets,
                                    size: 60, color: AppColors.primary))),
                      ),
                    )
                  else
                    Container(
                      color: AppColors.primaryLighter,
                      child: const Center(
                          child: Icon(Icons.pets,
                              size: 80, color: AppColors.primary)),
                    ),
                  // Gradient at bottom
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Color(0x99000000)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Image dots
                  if (pet.photoUrls.length > 1)
                    Positioned(
                      bottom: 80,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pet.photoUrls.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: i == _currentImageIndex ? 18 : 7,
                            height: 7,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: i == _currentImageIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Pet name and basic info at bottom
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${pet.name}, ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    pet.ageDisplay,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (pet.isVaccinated)
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.success,
                                      ),
                                      child: const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 14),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      color: Colors.white70, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    pet.locationName ?? 'Nearby',
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Gender badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.4)),
                          ),
                          child: Text(
                            '${pet.gender} ${pet.gender == "Male" ? "♂️" : "♀️"}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick stats row
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF5F7), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppShadows.card,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem('🐾', 'Breed', pet.breed),
                        _divider(),
                        _statItem('⚡', 'Energy', pet.energyLevel),
                        _divider(),
                        _statItem('📏', 'Size', pet.size),
                        _divider(),
                        _statItem('🏡', 'Home', pet.livingEnvironment.split(' ').first),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // About section
                  _sectionTitle('About ${pet.name}'),
                  const SizedBox(height: 12),
                  Text(
                    pet.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Characteristics
                  _sectionTitle('Characteristics'),
                  const SizedBox(height: 12),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 3.2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _charTile(Icons.restaurant_outlined, 'Diet', pet.dietType),
                      _charTile(Icons.emoji_food_beverage_outlined, 'Food Pref', pet.dietPreference),
                      _charTile(Icons.people_outline_rounded, 'Social', pet.socialBehaviour),
                      _charTile(Icons.favorite_border_rounded, 'Health', pet.healthStatus),
                      _charTile(Icons.vaccines_outlined, 'Vaccinated', pet.isVaccinated ? 'Yes' : 'No'),
                      _charTile(Icons.history_rounded, 'Bred Before', pet.hasPreviousBreeding ? 'Yes' : 'No'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Owner section
                  _sectionTitle('Owner'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryLighter,
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 2),
                          ),
                          child: const Center(
                              child: Icon(Icons.person_rounded,
                                  color: AppColors.primary, size: 28)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pet Owner',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 13, color: AppColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    pet.locationName ?? 'Nearby',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLighter,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'View Profile',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppShadows.nav,
        ),
        child: Row(
          children: [
            // Like button
            GestureDetector(
              onTap: () => setState(() => _isLiked = !_isLiked),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isLiked ? AppColors.primary : AppColors.surface,
                  boxShadow: _isLiked ? AppShadows.button : AppShadows.soft,
                ),
                child: Icon(
                  _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: _isLiked ? Colors.white : AppColors.primary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Message button
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(
                            matchId: 'm1',
                            petName: pet.name,
                            petImageUrl: pet.primaryPhoto,
                          )),
                ),
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
                          color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Send Message',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.textHint),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.divider,
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _charTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10, color: AppColors.textSecondary)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
