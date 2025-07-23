import 'package:flutter/material.dart' hide StepState;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../steps_sensor/presentation/enum_step_status.dart';
import '../../../steps_sensor/presentation/view_model/step_event.dart';
import '../../../steps_sensor/presentation/view_model/step_state.dart';
import '../../../steps_sensor/presentation/view_model/step_view_model.dart';
import '../../domain/entity/trail_entity.dart';

class TrailDetailsView extends StatelessWidget {
  final TrailEnitiy trail;
  final String userId; // You'll need to pass the current user ID

  const TrailDetailsView({Key? key, required this.trail, required this.userId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<StepBloc, StepState>(
        listener: (context, state) {
          if (state.status == StepStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.status == StepStatus.tracking) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Step tracking started!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  trail.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                background:
                    trail.images.isNotEmpty
                        ? Image.network(
                          trail.images,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.hiking,
                                size: 80,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                        : Container(
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.hiking,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
              ),
            ),
            // Trail Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            trail.location,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Step Counter Display
                    BlocBuilder<StepBloc, StepState>(
                      builder: (context, state) {
                        if (state.status == StepStatus.tracking) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.directions_walk,
                                  color: Colors.blue,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Steps This Session',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${state.sessionSteps}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),

                    // Stats Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.access_time,
                            label: 'Duration',
                            value: '${trail.duration.toStringAsFixed(1)} hours',
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.terrain,
                            label: 'Elevation',
                            value: '${trail.elevation.toStringAsFixed(0)} m',
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Difficulty
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(
                          trail.difficulty,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getDifficultyColor(trail.difficulty),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getDifficultyIcon(trail.difficulty),
                            color: _getDifficultyColor(trail.difficulty),
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Difficulty: ${trail.difficulty}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _getDifficultyColor(trail.difficulty),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add to favorites logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to favorites!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: const Icon(Icons.favorite_border),
                            label: const Text('Add to Favorites'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: BlocBuilder<StepBloc, StepState>(
                            builder: (context, state) {
                              final isTracking =
                                  state.status == StepStatus.tracking;

                              return ElevatedButton.icon(
                                onPressed: () {
                                  if (isTracking) {
                                    // Stop tracking
                                    context.read<StepBloc>().add(
                                      StopStepTracking(),
                                    );
                                  } else {
                                    // Start tracking
                                    context.read<StepBloc>().add(
                                      StartStepTracking(
                                        trailId: trail.trailId.toString(),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  isTracking ? Icons.stop : Icons.navigation,
                                ),
                                label: Text(
                                  isTracking
                                      ? 'Stop Navigation'
                                      : 'Start Navigation',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isTracking ? Colors.red : Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              );
                            },
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
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Icons.sentiment_satisfied;
      case 'moderate':
        return Icons.sentiment_neutral;
      case 'hard':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.help_outline;
    }
  }
}
