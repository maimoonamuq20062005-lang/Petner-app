import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/pet_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PetModel? _selectedPet;
  final pets = PetSampleData.samples;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nearby Pets'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.primaryLighter,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list_rounded,
                        color: AppColors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map placeholder (would use google_maps_flutter)
          _buildMapPlaceholder(),
          // Bottom pet list
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selected pet card
                if (_selectedPet != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: _buildSelectedPetCard(_selectedPet!),
                  ),
                // Nearby pets strip
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: AppShadows.nav,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: AppColors.primary, size: 18),
                            const SizedBox(width: 6),
                            const Text(
                              'Nearby Pets',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${pets.length} found',
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pets.length,
                          itemBuilder: (_, i) => _buildPetItem(pets[i]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Map markers overlay
          Positioned.fill(
            child: Stack(
              children: pets.map((pet) => _buildMapMarker(pet)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      color: const Color(0xFFE8F4F8),
      child: CustomPaint(
        size: Size.infinite,
        painter: _MapGridPainter(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLighter,
                ),
                child: const Icon(Icons.map_outlined,
                    size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              Text(
                'Map View',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Integrate Google Maps API key to enable',
                style: TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapMarker(PetModel pet) {
    final size = MediaQuery.of(context).size;
    // Fake positions scattered on the map
    final positions = [
      Offset(size.width * 0.3, size.height * 0.2),
      Offset(size.width * 0.6, size.height * 0.15),
      Offset(size.width * 0.15, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.45, size.height * 0.25),
    ];
    final idx = pets.indexOf(pet);
    final pos = positions[idx % positions.length];
    return Positioned(
      left: pos.dx - 22,
      top: pos.dy - 48,
      child: GestureDetector(
        onTap: () => setState(
            () => _selectedPet = _selectedPet == pet ? null : pet),
        child: Column(
          children: [
            // Marker
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: AppShadows.card,
              ),
              child: const Center(
                child: Text('🐾', style: TextStyle(fontSize: 20)),
              ),
            ),
            // Pin tail
            Container(
              width: 3,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPetCard(PetModel pet) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 70,
              height: 70,
              color: AppColors.primaryLighter,
              child: const Center(
                  child: Text('🐾', style: TextStyle(fontSize: 32))),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pet.name}, ${pet.ageDisplay}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  pet.breed,
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 12, color: AppColors.primary),
                    const SizedBox(width: 3),
                    Text(
                      pet.locationName ?? '2.4 km away',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: AppShadows.button,
            ),
            child: const Icon(Icons.favorite_rounded,
                color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildPetItem(PetModel pet) {
    final isSelected = _selectedPet == pet;
    return GestureDetector(
      onTap: () =>
          setState(() => _selectedPet = isSelected ? null : pet),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? AppColors.primaryLighter : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLighter,
              ),
              child: const Center(
                child: Text('🐾', style: TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  pet.breed,
                  style: TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
                Text(
                  '${(pet.id.hashCode % 30).abs() + 1} km',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey.withOpacity(0.08)
      ..strokeWidth = 1;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10;
    canvas.drawLine(Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.4), roadPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0),
        Offset(size.width * 0.5, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.25, 0),
        Offset(size.width * 0.4, size.height * 0.4), roadPaint);
  }

  @override
  bool shouldRepaint(_MapGridPainter oldDelegate) => false;
}
