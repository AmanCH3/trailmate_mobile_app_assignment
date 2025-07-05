import 'package:flutter/material.dart';

class AchievementCard extends StatelessWidget {
  final String achievementId;

  const AchievementCard({required this.achievementId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber[100],
          child: Icon(Icons.emoji_events, color: Colors.amber[700]),
        ),
        title: Text('Achievement ${achievementId.substring(0, 8)}'),
        subtitle: const Text('Earned for completing a challenging trail'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          /* Navigate to achievement details */
        },
      ),
    );
  }
}
