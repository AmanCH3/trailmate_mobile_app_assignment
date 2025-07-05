import 'package:flutter/material.dart';

import '../../../feature/user/domain/entity/user_entity.dart';
import 'achievement_card.dart';

class _AchievementsTab extends StatelessWidget {
  final UserEntity user;

  const _AchievementsTab({required this.user});

  @override
  Widget build(BuildContext context) {
    final achievements = user.achievements ?? [];

    if (achievements.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No achievements yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Complete trails to earn achievements!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return AchievementCard(achievementId: achievements[index]);
      },
    );
  }
}
