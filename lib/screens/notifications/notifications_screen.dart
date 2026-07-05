import 'package:flutter/material.dart';
import '../../core/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all read',
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildSectionHeader('Today'),
          _buildNotifTile(
            icon: Icons.favorite_rounded,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLighter,
            title: 'New Match! 🎉',
            subtitle: 'Your pet Bella matched with Max the Husky',
            time: '2h ago',
            isUnread: true,
          ),
          _buildNotifTile(
            icon: Icons.chat_bubble_rounded,
            iconColor: const Color(0xFF60A5FA),
            iconBg: const Color(0xFFEFF6FF),
            title: 'New Message',
            subtitle: 'Max\'s owner: "Hey! Our dogs would love to meet 🐾"',
            time: '3h ago',
            isUnread: true,
          ),
          _buildNotifTile(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFBBF24),
            iconBg: const Color(0xFFFFFBEB),
            title: 'Super Like!',
            subtitle: 'Someone super liked your pet Luna',
            time: '5h ago',
            isUnread: true,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Yesterday'),
          _buildNotifTile(
            icon: Icons.pets,
            iconColor: const Color(0xFF34D399),
            iconBg: const Color(0xFFECFDF5),
            title: 'Profile Visitor',
            subtitle: 'Charlie\'s owner viewed Bella\'s profile',
            time: 'Yesterday',
            isUnread: false,
          ),
          _buildNotifTile(
            icon: Icons.verified_rounded,
            iconColor: const Color(0xFF34D399),
            iconBg: const Color(0xFFECFDF5),
            title: 'Profile Verified ✅',
            subtitle: 'Your pet profile has been verified',
            time: 'Yesterday',
            isUnread: false,
          ),
          _buildNotifTile(
            icon: Icons.location_on_rounded,
            iconColor: const Color(0xFFEC7A92),
            iconBg: AppColors.primaryLighter,
            title: '3 Pets Nearby',
            subtitle: 'New pets discovered within 5km of your location',
            time: '2 days ago',
            isUnread: false,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('This Week'),
          _buildNotifTile(
            icon: Icons.security_rounded,
            iconColor: const Color(0xFF6366F1),
            iconBg: const Color(0xFFEEF2FF),
            title: 'Safety Reminder',
            subtitle: 'Always meet in public places for the first pet playdate',
            time: '3 days ago',
            isUnread: false,
          ),
          _buildNotifTile(
            icon: Icons.celebration_rounded,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLighter,
            title: 'Welcome to PETNER! 🐾',
            subtitle: 'Start discovering amazing pets near you',
            time: '5 days ago',
            isUnread: false,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textHint,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNotifTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.primaryLighter.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.divider,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(shape: BoxShape.circle, color: iconBg),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isUnread ? FontWeight.w700 : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
