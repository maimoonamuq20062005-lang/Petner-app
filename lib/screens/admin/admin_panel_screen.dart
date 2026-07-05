import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/pet_model.dart';
import '../../models/match_model.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Admin Panel'),
            Text(
              'PETNER Management',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Users'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildUsersTab(),
          _buildReportsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _statCard('Total Users', '12,483', '+8%', Icons.people_rounded,
                  const Color(0xFF6366F1)),
              _statCard('Active Pets', '18,921', '+12%', Icons.pets,
                  AppColors.primary),
              _statCard('Matches Today', '342', '+23%',
                  Icons.favorite_rounded, const Color(0xFF34D399)),
              _statCard('Messages Sent', '5.2K', '+5%',
                  Icons.chat_bubble_rounded, const Color(0xFF60A5FA)),
            ],
          ),
          const SizedBox(height: 24),
          // Recent activity
          _sectionHeader('Recent Activity'),
          const SizedBox(height: 12),
          ..._buildActivityList(),
          const SizedBox(height: 24),
          // Quick actions
          _sectionHeader('Quick Actions'),
          const SizedBox(height: 12),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    final pets = PetSampleData.samples;
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppShadows.soft,
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users or pets...',
                      hintStyle:
                          TextStyle(color: AppColors.textHint, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                Icon(Icons.filter_list_rounded,
                    color: AppColors.primary, size: 20),
              ],
            ),
          ),
        ),
        // Users list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: pets.length,
            itemBuilder: (_, i) {
              final pet = pets[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppShadows.soft,
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
                          child: Text('🐾', style: TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pet.name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                          Text('${pet.breed} · Owner ID: ${pet.ownerId}',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _statusBadge(
                            pet.isVaccinated ? 'Verified' : 'Pending',
                            pet.isVaccinated
                                ? AppColors.success
                                : const Color(0xFFF59E0B)),
                        const SizedBox(width: 8),
                        Icon(Icons.more_vert_rounded,
                            color: AppColors.textHint, size: 20),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReportsTab() {
    final reports = [
      {
        'type': 'Inappropriate Content',
        'reporter': 'User #1284',
        'subject': 'Pet Profile #482',
        'time': '2h ago',
        'status': 'Pending'
      },
      {
        'type': 'Fake Profile',
        'reporter': 'User #893',
        'subject': 'User #1021',
        'time': '5h ago',
        'status': 'Under Review'
      },
      {
        'type': 'Spam',
        'reporter': 'User #442',
        'subject': 'Chat #887',
        'time': 'Yesterday',
        'status': 'Resolved'
      },
      {
        'type': 'Harassment',
        'reporter': 'User #2011',
        'subject': 'User #633',
        'time': '2 days ago',
        'status': 'Resolved'
      },
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      itemBuilder: (_, i) {
        final r = reports[i];
        final isResolved = r['status'] == 'Resolved';
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppShadows.soft,
            border: Border.all(
              color: isResolved
                  ? Colors.transparent
                  : AppColors.error.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isResolved
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      r['type']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            isResolved ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(r['time']!,
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textHint)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _infoTag('Reporter', r['reporter']!),
                  const SizedBox(width: 12),
                  _infoTag('Subject', r['subject']!),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _statusBadge(
                    r['status']!,
                    isResolved
                        ? AppColors.success
                        : r['status'] == 'Pending'
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF60A5FA),
                  ),
                  const Spacer(),
                  if (!isResolved)
                    Row(
                      children: [
                        _actionBtn('Review', AppColors.primary),
                        const SizedBox(width: 8),
                        _actionBtn('Dismiss', AppColors.textSecondary),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(
      String label, String value, String change, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(change,
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          Text(label,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  List<Widget> _buildActivityList() {
    final activities = [
      {'icon': '🎉', 'text': 'New match: Bella & Max', 'time': '2m ago'},
      {'icon': '📝', 'text': 'New pet profile: Charlie (Cat)', 'time': '15m ago'},
      {'icon': '⚠️', 'text': 'Report received: Fake Profile', 'time': '1h ago'},
      {'icon': '✅', 'text': 'User verified: ID #8821', 'time': '2h ago'},
    ];
    return activities.map((a) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            Text(a['icon']!, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(a['text']!,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500)),
            ),
            Text(a['time']!,
                style: TextStyle(fontSize: 11, color: AppColors.textHint)),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.send_rounded, 'label': 'Broadcast', 'color': AppColors.primary},
      {'icon': Icons.block_rounded, 'label': 'Ban User', 'color': AppColors.error},
      {'icon': Icons.download_rounded, 'label': 'Export Data', 'color': const Color(0xFF6366F1)},
      {'icon': Icons.bar_chart_rounded, 'label': 'Analytics', 'color': const Color(0xFF34D399)},
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.85,
      children: actions.map((a) {
        final color = a['color'] as Color;
        return GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                  border: Border.all(color: color.withOpacity(0.2), width: 1.5),
                ),
                child: Icon(a['icon'] as IconData, color: color, size: 22),
              ),
              const SizedBox(height: 6),
              Text(a['label'] as String,
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary));
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _infoTag(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 10, color: AppColors.textHint)),
        Text(value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _actionBtn(String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
