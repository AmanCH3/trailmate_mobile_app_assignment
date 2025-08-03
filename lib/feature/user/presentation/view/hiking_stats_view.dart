// lib/feature/user/presentation/widget/hiking_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Note: We need to import our mock data file to get the class definitions
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_view_model.dart';

import '../../domain/entity/user_entity.dart';
import '../view_model/profile_view_model/stats_event.dart';
import '../view_model/profile_view_model/stats_state.dart';

class HikingStatsCard extends StatelessWidget {
  final UserEntity user;
  final bool isEditing;

  const HikingStatsCard({Key? key, required this.user, required this.isEditing})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = user.stats;
    if (stats == null) return const SizedBox.shrink();

    // This is the critical variable. It will be true only if user.isInAGroup is true.
    final canTrack = user.isInAGroup ?? false;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hiking Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              children: [
                _buildStatItem(
                  'Total Steps',
                  '${stats.totalSteps ?? 0}',
                  Icons.directions_walk,
                ),
                _buildStatItem(
                  'Total Distance',
                  '${stats.totalDistance ?? 0} km',
                  Icons.straighten,
                ),
                _buildStatItem(
                  'Total Time',
                  '${stats.totalHours ?? 0} hrs',
                  Icons.timer,
                ),
                _buildStatItem(
                  'Hikes Joined',
                  '${stats.hikesJoined ?? 0}',
                  Icons.group,
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Live Hike Tracker',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<StatsViewModel, StatsState>(
              builder: (context, statsState) {
                // Initialize pedometer on first build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!statsState.isPedometerAvailable &&
                      statsState.errorMessage == null) {
                    context.read<StatsViewModel>().add(InitializePedometer());
                  }
                });

                // Show loading while initializing
                if (statsState.status == StatsStatus.initializing) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Initializing pedometer...'),
                      ],
                    ),
                  );
                }

                if (!statsState.isPedometerAvailable) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[400],
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          statsState.errorMessage ?? 'Pedometer not available.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<StatsViewModel>().add(
                              InitializePedometer(),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final bool isTracking =
                    statsState.status == StatsStatus.tracking;
                final bool isSaving = statsState.status == StatsStatus.saving;

                return Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.travel_explore,
                        color: Colors.green[700],
                      ),
                      title: const Text("Steps This Hike"),
                      trailing: Text(
                        '${statsState.sessionSteps}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isSaving)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        child: Tooltip(
                          message:
                              canTrack
                                  ? ''
                                  : 'Join a group to enable hike tracking!',
                          child: ElevatedButton.icon(
                            icon: Icon(
                              isTracking ? Icons.stop : Icons.play_arrow,
                            ),
                            label: Text(
                              isTracking ? 'End Hike & Save' : 'Start Hike',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isTracking ? Colors.red : Colors.green[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed:
                                !canTrack || isEditing
                                    ? null
                                    : () {
                                      if (isTracking) {
                                        context.read<StatsViewModel>().add(
                                          StopHikeTracking(),
                                        );
                                      } else {
                                        context.read<StatsViewModel>().add(
                                          StartHikeTracking(),
                                        );
                                      }
                                    },
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: FittedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green[700], size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 8, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
