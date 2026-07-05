import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../pet/pet_profile_creation_screen.dart';

class UserProfileSetupScreen extends StatefulWidget {
  const UserProfileSetupScreen({super.key});

  @override
  State<UserProfileSetupScreen> createState() => _UserProfileSetupScreenState();
}

class _UserProfileSetupScreenState extends State<UserProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  int _currentStep = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _bioController.text = user.bio ?? '';
      _locationController.text = user.location ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _saveProfile();
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    context.read<AuthProvider>().updateProfile(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      location: _locationController.text.trim(),
    );
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PetProfileCreationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar
                  Row(
                    children: List.generate(3, (i) => Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: i <= _currentStep
                              ? AppColors.primary
                              : AppColors.primaryLighter,
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Step ${_currentStep + 1} of 3',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _stepTitle(_currentStep),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _stepSubtitle(_currentStep),
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Step content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: KeyedSubtree(
                  key: ValueKey(_currentStep),
                  child: _buildStepContent(),
                ),
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(24),
              child: GestureDetector(
                onTap: _isLoading ? null : _nextStep,
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
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            _currentStep < 2 ? 'Continue' : 'Save Profile',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPhotoStep();
      case 1:
        return _buildInfoStep();
      case 2:
        return _buildBioStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPhotoStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Avatar picker
          Center(
            child: Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF0F3), Color(0xFFFFE0E8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: AppShadows.card,
                  ),
                  child: const Center(
                    child: Icon(Icons.pets, size: 50, color: AppColors.primary),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: AppShadows.soft,
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.photo_library_outlined, size: 18),
            label: const Text('Choose from Gallery'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined, size: 18),
            label: const Text('Take a Photo'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildFormField(
            controller: _nameController,
            label: 'Display Name',
            hint: 'How should we call you?',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 16),
          _buildFormField(
            controller: _locationController,
            label: 'Location',
            hint: 'City, Country',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          _buildDropdown('I am a', ['Pet Owner', 'Breeder', 'Rescue'], 'Pet Owner'),
        ],
      ),
    );
  }

  Widget _buildBioStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.transparent),
            ),
            child: TextFormField(
              controller: _bioController,
              maxLines: 5,
              maxLength: 200,
              decoration: const InputDecoration(
                hintText:
                    'Tell us a bit about yourself and your pet(s)... 🐾',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Suggestion chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Dog lover 🐕',
              'Cat parent 🐈',
              'Outdoor adventures 🌿',
              'Pet photographer 📸',
              'Animal rescue 🐾',
            ].map((tag) => GestureDetector(
              onTap: () {
                _bioController.text = '${_bioController.text} $tag';
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLighter,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> options, String initial) {
    String? selected = initial;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonFormField<String>(
            value: selected,
            decoration: const InputDecoration(border: InputBorder.none),
            items: options
                .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                .toList(),
            onChanged: (v) => selected = v,
          ),
        ),
      ],
    );
  }

  String _stepTitle(int step) {
    const titles = ['Your Photo', 'Basic Info', 'About You'];
    return titles[step];
  }

  String _stepSubtitle(int step) {
    const subtitles = [
      'Add a profile photo so others can recognize you',
      'Help us personalize your experience',
      'Share a little about yourself and your pets',
    ];
    return subtitles[step];
  }
}
