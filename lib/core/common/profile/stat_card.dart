import 'package:flutter/material.dart';
import 'package:trailmate_mobile_app_assignment/core/common/profile/stat_item.dart';

import '../../../feature/user/domain/entity/user_entity.dart';
import 'info_card.dart';

class StatsCard extends StatelessWidget {
  final UserEntity user;

  const StatsCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final stats = user.stats!;
    return InfoCard(
      title: 'Hiking Stats',
      children: [
        Row(
          children: [
            Expanded(
              child: StatItem(
                label: 'Trails Completed',
                value: '${user.completedTrails?.length ?? 0}',
                icon: Icons.landscape,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatItem(
                label: 'Total Distance',
                value: '${stats.totalDistance ?? 0} km',
                icon: Icons.straighten,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatItem(
                label: 'Total Time',
                value: '${stats.totalHikes ?? 0} hrs',
                icon: Icons.timer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatItem(
                label: 'Achievements',
                value: '${user.achievements?.length ?? 0}',
                icon: Icons.emoji_events,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
