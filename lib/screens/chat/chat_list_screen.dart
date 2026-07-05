import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../models/match_model.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matches = MatchSampleData.samples;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active matches strip
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Recent Matches',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: matches.length,
              itemBuilder: (_, i) {
                final m = matches[i];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      matchId: m.match.id,
                      petName: m.otherPet.name,
                      petImageUrl: m.otherPet.primaryPhoto,
                    ),
                  )),
                  child: Container(
                    margin: const EdgeInsets.only(right: 14),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.primary, width: 2.5),
                              ),
                              child: ClipOval(
                                child: m.otherPet.photoUrls.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: m.otherPet.photoUrls.first,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => Container(
                                          color: AppColors.primaryLighter,
                                          child: const Icon(Icons.pets,
                                              color: AppColors.primary, size: 24),
                                        ),
                                      )
                                    : Container(
                                        color: AppColors.primaryLighter,
                                        child: const Icon(Icons.pets,
                                            color: AppColors.primary, size: 24),
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.online,
                                  border: Border.all(
                                      color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          m.otherPet.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 20),
          // Messages list
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              'Conversations',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: matches.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 80),
              itemBuilder: (_, i) => _buildConversationTile(context, matches[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, MatchWithPets m) {
    final hasUnread = m.match.lastMessageAt != null &&
        DateTime.now().difference(m.match.lastMessageAt!).inHours < 1;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ChatScreen(
          matchId: m.match.id,
          petName: m.otherPet.name,
          petImageUrl: m.otherPet.primaryPhoto,
        ),
      )),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: hasUnread ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: m.otherPet.photoUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: m.otherPet.photoUrls.first,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: AppColors.primaryLighter,
                              child: const Icon(Icons.pets,
                                  color: AppColors.primary, size: 28),
                            ),
                          )
                        : Container(
                            color: AppColors.primaryLighter,
                            child: const Icon(Icons.pets,
                                color: AppColors.primary, size: 28),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.online,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          m.otherPet.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: hasUnread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        _timeAgo(m.match.lastMessageAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: hasUnread
                              ? AppColors.primary
                              : AppColors.textHint,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          m.match.lastMessage ?? 'Say hello! 🐾',
                          style: TextStyle(
                            fontSize: 13,
                            color: hasUnread
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: const Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
