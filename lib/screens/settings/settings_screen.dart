import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../splash/splash_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotif = true;
  bool _matchNotif = true;
  bool _messageNotif = true;
  bool _locationEnabled = true;
  bool _showOnMap = true;
  double _searchRadius = 25;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          _buildProfileCard(user?.name, user?.email, user?.photoUrl),
          const SizedBox(height: 20),

          // Account section
          _buildSectionLabel('Account'),
          _buildCard(children: [
            _buildNavTile(Icons.person_outline_rounded, 'Edit Profile',
                () {}),
            _divider(),
            _buildNavTile(Icons.pets, 'My Pets', () {}),
            _divider(),
            _buildNavTile(Icons.lock_outline_rounded, 'Change Password', () {}),
            _divider(),
            _buildNavTile(Icons.phone_outlined, 'Change Phone', () {}),
          ]),
          const SizedBox(height: 16),

          // Discovery section
          _buildSectionLabel('Discovery'),
          _buildCard(children: [
            _buildSliderTile(
              icon: Icons.radar_rounded,
              title: 'Search Radius',
              value: '${_searchRadius.toInt()} km',
              slider: Slider(
                value: _searchRadius,
                min: 5,
                max: 100,
                divisions: 19,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primaryLighter,
                onChanged: (v) => setState(() => _searchRadius = v),
              ),
            ),
            _divider(),
            _buildSwitchTile(
              icon: Icons.location_on_outlined,
              title: 'Enable Location',
              subtitle: 'Show pets near you',
              value: _locationEnabled,
              onChanged: (v) => setState(() => _locationEnabled = v),
            ),
            _divider(),
            _buildSwitchTile(
              icon: Icons.map_outlined,
              title: 'Show Me on Map',
              subtitle: 'Let others find you nearby',
              value: _showOnMap,
              onChanged: (v) => setState(() => _showOnMap = v),
            ),
          ]),
          const SizedBox(height: 16),

          // Notifications section
          _buildSectionLabel('Notifications'),
          _buildCard(children: [
            _buildSwitchTile(
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              subtitle: 'Receive all app notifications',
              value: _pushNotif,
              onChanged: (v) => setState(() => _pushNotif = v),
            ),
            _divider(),
            _buildSwitchTile(
              icon: Icons.favorite_border_rounded,
              title: 'Match Alerts',
              subtitle: 'Get notified when you match',
              value: _matchNotif,
              onChanged: (v) => setState(() => _matchNotif = v),
            ),
            _divider(),
            _buildSwitchTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Message Alerts',
              subtitle: 'Be notified of new messages',
              value: _messageNotif,
              onChanged: (v) => setState(() => _messageNotif = v),
            ),
          ]),
          const SizedBox(height: 16),

          // Privacy & Safety section
          _buildSectionLabel('Privacy & Safety'),
          _buildCard(children: [
            _buildNavTile(Icons.shield_outlined, 'Privacy Policy', () {}),
            _divider(),
            _buildNavTile(Icons.description_outlined, 'Terms of Service', () {}),
            _divider(),
            _buildNavTile(Icons.block_rounded, 'Blocked Users', () {}),
            _divider(),
            _buildNavTile(
                Icons.report_outlined, 'Report a Problem', () {}),
          ]),
          const SizedBox(height: 16),

          // Support
          _buildSectionLabel('Support'),
          _buildCard(children: [
            _buildNavTile(
                Icons.help_outline_rounded, 'Help Center', () {}),
            _divider(),
            _buildNavTile(
                Icons.star_outline_rounded, 'Rate PETNER', () {}),
            _divider(),
            _buildNavTile(Icons.info_outline_rounded, 'About', () {}),
          ]),
          const SizedBox(height: 16),

          // Delete & Logout
          _buildCard(children: [
            _buildNavTile(
              Icons.logout_rounded,
              'Log Out',
              () => _showLogoutDialog(context),
              color: AppColors.error,
            ),
            _divider(),
            _buildNavTile(
              Icons.delete_outline_rounded,
              'Delete Account',
              () {},
              color: AppColors.error,
            ),
          ]),
          const SizedBox(height: 32),

          // Version
          Center(
            child: Text(
              'PETNER v1.0.0\nMade with ❤️ for pets',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 12, color: AppColors.textHint, height: 1.6),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String? name, String? email, String? photoUrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9DAD), Color(0xFFEC7A92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.button,
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
              border: Border.all(color: Colors.white, width: 2.5),
            ),
            child: ClipOval(
              child: photoUrl != null
                  ? Image.network(photoUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 32,
                          ))
                  : const Icon(Icons.person_rounded,
                      color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'Pet Owner',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email ?? '',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85), fontSize: 13),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded,
                          color: Colors.white, size: 13),
                      const SizedBox(width: 4),
                      const Text(
                        'Verified Pet Owner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textHint,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.soft,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildNavTile(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color != null
              ? color.withOpacity(0.1)
              : AppColors.primaryLighter,
        ),
        child: Icon(icon,
            color: color ?? AppColors.primary, size: 18),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.textPrimary,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: AppColors.textHint, size: 20),
      onTap: onTap,
      dense: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      dense: true,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryLighter,
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
      title: Text(title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: Switch(
          value: value, activeColor: AppColors.primary, onChanged: onChanged),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required String value,
    required Widget slider,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLighter,
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLighter,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(value,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          slider,
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 68);

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('👋', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Log Out'),
          ],
        ),
        content: const Text(
            'Are you sure you want to log out of PETNER?',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
