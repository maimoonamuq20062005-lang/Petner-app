import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../home/main_nav_screen.dart';

class PetProfileCreationScreen extends StatefulWidget {
  const PetProfileCreationScreen({super.key});

  @override
  State<PetProfileCreationScreen> createState() =>
      _PetProfileCreationScreenState();
}

class _PetProfileCreationScreenState extends State<PetProfileCreationScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _breedController = TextEditingController();
  int _currentSection = 0;
  String _selectedType = 'Dog';
  String _selectedGender = 'Female';
  String _selectedSize = 'Medium';
  String _selectedEnergy = 'Moderate';
  String _selectedDietType = 'Omnivore';
  String _selectedDietPref = 'Mixed';
  String _selectedSocial = 'Friendly';
  String _selectedLiving = 'House';
  String _selectedHealth = 'Good';
  bool _isVaccinated = false;
  bool _hasPreviousBreeding = false;
  double _ageYears = 1;
  final List<String> _photos = [];
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  final List<String> _sectionTitles = [
    'Basic Info',
    'Photos',
    'Characteristics',
    'Health & Lifestyle',
    'Description',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Pet Profile'),
        leading: _currentSection > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => setState(() => _currentSection--),
              )
            : null,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveAndContinue,
            child: Text(
              _currentSection == 4 ? 'Done' : 'Next',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Section progress
          _buildSectionProgress(),
          // Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: KeyedSubtree(
                key: ValueKey(_currentSection),
                child: _buildSection(_currentSection),
              ),
            ),
          ),
          // Save button
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildSectionProgress() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(_sectionTitles.length, (i) {
          final isActive = i == _currentSection;
          final isCompleted = i < _currentSection;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentSection = i),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: isCompleted || isActive
                          ? AppColors.primary
                          : AppColors.primaryLighter,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _sectionTitles[i],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textHint,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSection(int section) {
    switch (section) {
      case 0:
        return _buildBasicInfoSection();
      case 1:
        return _buildPhotosSection();
      case 2:
        return _buildCharacteristicsSection();
      case 3:
        return _buildHealthSection();
      case 4:
        return _buildDescriptionSection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicInfoSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('🐾', 'Tell us about your pet'),
          const SizedBox(height: 24),
          // Pet type selector
          _buildLabel('Pet Type'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: AppConstants.petTypes.map((t) => _buildChip(
              label: t,
              isSelected: _selectedType == t,
              onTap: () => setState(() => _selectedType = t),
              icon: _petTypeEmoji(t),
            )).toList(),
          ),
          const SizedBox(height: 20),
          _buildLabel('Pet Name'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'e.g., Bella, Max, Luna',
              prefixIcon: Icon(Icons.pets, color: AppColors.primary, size: 20),
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel('Breed'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _breedController,
            decoration: const InputDecoration(
              hintText: 'e.g., Golden Retriever',
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
            ),
          ),
          const SizedBox(height: 20),
          // Gender
          _buildLabel('Gender'),
          const SizedBox(height: 10),
          Row(
            children: AppConstants.petGenders.map((g) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: g == 'Male' ? 8 : 0),
                child: _buildChip(
                  label: g,
                  isSelected: _selectedGender == g,
                  onTap: () => setState(() => _selectedGender = g),
                  icon: g == 'Male' ? '♂️' : '♀️',
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 20),
          // Age slider
          _buildLabel('Age: ${_ageYears.toInt()} ${_ageYears.toInt() == 1 ? "year" : "years"}'),
          Slider(
            value: _ageYears,
            min: 0,
            max: 20,
            divisions: 40,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.primaryLighter,
            onChanged: (v) => setState(() => _ageYears = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('📸', 'Add pet photos'),
          const SizedBox(height: 8),
          Text(
            'Add up to 6 photos of your pet. First photo will be the main profile photo.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          // Photo grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 6,
              itemBuilder: (_, i) {
                final hasPhoto = i < _photos.length;
                return GestureDetector(
                  onTap: () {
                    // Pick image
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.surfaceVariant,
                      border: Border.all(
                        color: i == 0
                            ? AppColors.primary.withOpacity(0.4)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: hasPhoto
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _photos[i],
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                i == 0
                                    ? Icons.add_photo_alternate_rounded
                                    : Icons.add_rounded,
                                color: i == 0
                                    ? AppColors.primary
                                    : AppColors.textHint,
                                size: i == 0 ? 32 : 24,
                              ),
                              if (i == 0) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Main Photo',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacteristicsSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('✨', 'Pet characteristics'),
          const SizedBox(height: 24),
          _buildChipGroup('Size', AppConstants.petSizes, _selectedSize,
              (v) => setState(() => _selectedSize = v)),
          const SizedBox(height: 20),
          _buildChipGroup('Energy Level', AppConstants.energyLevels, _selectedEnergy,
              (v) => setState(() => _selectedEnergy = v)),
          const SizedBox(height: 20),
          _buildChipGroup('Social Behaviour', AppConstants.socialBehaviours, _selectedSocial,
              (v) => setState(() => _selectedSocial = v)),
          const SizedBox(height: 20),
          _buildChipGroup('Living Environment', AppConstants.livingEnvironments, _selectedLiving,
              (v) => setState(() => _selectedLiving = v)),
          const SizedBox(height: 20),
          _buildChipGroup('Diet Type', AppConstants.dietTypes, _selectedDietType,
              (v) => setState(() => _selectedDietType = v)),
          const SizedBox(height: 20),
          _buildChipGroup('Diet Preference', AppConstants.dietPreferences, _selectedDietPref,
              (v) => setState(() => _selectedDietPref = v)),
        ],
      ),
    );
  }

  Widget _buildHealthSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('💊', 'Health & breeding history'),
          const SizedBox(height: 24),
          _buildChipGroup('Health Status', AppConstants.healthStatuses, _selectedHealth,
              (v) => setState(() => _selectedHealth = v)),
          const SizedBox(height: 24),
          // Vaccinated toggle
          _buildToggleTile(
            icon: Icons.vaccines_outlined,
            title: 'Vaccinated',
            subtitle: 'Pet is fully up to date on vaccinations',
            value: _isVaccinated,
            onChanged: (v) => setState(() => _isVaccinated = v),
          ),
          const SizedBox(height: 16),
          _buildToggleTile(
            icon: Icons.history_rounded,
            title: 'Previous Breeding History',
            subtitle: 'Pet has been bred before',
            value: _hasPreviousBreeding,
            onChanged: (v) => setState(() => _hasPreviousBreeding = v),
          ),
          const SizedBox(height: 24),
          // Vaccination record upload
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    style: BorderStyle.solid),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLighter,
                    ),
                    child: const Icon(Icons.upload_file_rounded,
                        color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload Vaccination Records',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'PDF, JPG or PNG (max 5MB)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('📝', 'Tell us more about your pet'),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextFormField(
              controller: _descController,
              maxLines: 6,
              maxLength: 500,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                hintText:
                    'Describe your pet\'s personality, favorite activities, special needs, and what you\'re looking for in a companion... 🐾',
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Preview card
          Text(
            'Profile Preview',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
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
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLighter,
                  ),
                  child: Center(
                    child: Text(_petTypeEmoji(_selectedType),
                        style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nameController.text.isEmpty
                            ? 'Your Pet'
                            : _nameController.text,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_selectedType} · ${_selectedGender} · ${_ageYears.toInt()}y',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _miniTag(_selectedEnergy),
                          const SizedBox(width: 6),
                          _miniTag(_selectedSize),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppShadows.nav,
      ),
      child: GestureDetector(
        onTap: _isSaving ? null : _saveAndContinue,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9DAD), Color(0xFFEC7A92)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(27),
            boxShadow: AppShadows.button,
          ),
          child: Center(
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentSection < 4 ? 'Continue' : 'Create Profile 🐾',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_currentSection < 4) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 18),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _saveAndContinue() {
    if (_currentSection < 4) {
      setState(() => _currentSection++);
    } else {
      _createProfile();
    }
  }

  Future<void> _createProfile() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavScreen()),
      );
    }
  }

  Widget _sectionHeader(String emoji, String title) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryLighter,
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    String? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Text(icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipGroup(
    String label,
    List<String> options,
    String selected,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map((o) => _buildChip(
                    label: o,
                    isSelected: selected == o,
                    onTap: () => onChanged(o),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLighter,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _miniTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryLighter,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _petTypeEmoji(String type) {
    switch (type) {
      case 'Dog': return '🐕';
      case 'Cat': return '🐈';
      case 'Rabbit': return '🐇';
      case 'Bird': return '🦜';
      default: return '🐾';
    }
  }
}
