import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/core/common/tab_button.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_view_model.dart';

class HomeView extends StatelessWidget {
  final List<Map<String, dynamic>> upcomingHikes = [
    {
      'title': 'Coastal Cliffs Path',
      'date': 'Sat, May 11',
      'distance': 5.2,
      'duration': '2 hrs',
      'status': 'Planned',
    },
  ];

  // Nature-inspired color palette
  static const Color _forestGreen = Color(0xFF2D5016);
  static const Color _leafGreen = Color(0xFF7CB342);
  static const Color _earthBrown = Color(0xFF8D6E63);
  static const Color _skyBlue = Color(0xFF81C784);
  static const Color _mist = Color(0xFFF1F8E9);
  static const Color _stone = Color(0xFF757575);

  Widget _buildNatureIcon(IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _mist,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color ?? _forestGreen, size: 20),
    );
  }

  Widget buildBottomContent(int selectedTab) {
    switch (selectedTab) {
      case 0:
        return Container(
          margin: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                upcomingHikes.map((hike) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _mist, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildNatureIcon(Icons.terrain, color: _leafGreen),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hike['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: _forestGreen,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${hike['date']} • ${hike['distance']} km • ${hike['duration']}',
                                style: TextStyle(
                                  color: _stone.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.schedule,
                            color: Colors.orange,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        );
      case 1:
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _mist, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildNatureIcon(
                    Icons.lightbulb_outline,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Nature Wisdom",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: _forestGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTip(
                "Stay hydrated with natural spring water",
                Icons.water_drop,
              ),
              _buildTip("Travel light, leave no trace", Icons.backpack),
              _buildTip("Choose sustainable hiking gear", Icons.eco),
            ],
          ),
        );
      case 2:
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _mist, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildNatureIcon(
                    Icons.emoji_events_outlined,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Nature Challenges",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: _forestGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildChallenge(
                "Complete 3 forest trails this month",
                Icons.forest,
              ),
              _buildChallenge(
                "Hike 20km through nature reserves",
                Icons.landscape,
              ),
              _buildChallenge(
                "Join a wildlife observation hike",
                Icons.visibility,
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTip(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: _leafGreen, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: _stone.withOpacity(0.9),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallenge(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: _earthBrown, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: _stone.withOpacity(0.9),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, homeState) {
        final selectedTab = homeState.selectedIndex;

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Clean greeting section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Morning",
                          style: TextStyle(
                            fontSize: 16,
                            color: _stone.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Aman",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: _forestGreen,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wb_sunny,
                            color: Colors.orange,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "24°C",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Featured Trails Header
                const Text(
                  "Discover Nature",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _forestGreen,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Handpicked trails for your next adventure",
                  style: TextStyle(
                    fontSize: 15,
                    color: _stone.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 24),

                // Featured Trails
                SizedBox(
                  height: 220,
                  child: BlocBuilder<TrailViewModel, TrailState>(
                    builder: (context, trailState) {
                      if (trailState is TrailLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: _leafGreen,
                            strokeWidth: 2,
                          ),
                        );
                      }

                      if (trailState is TrailErrorState) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: _stone,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                trailState.message,
                                style: TextStyle(color: _stone),
                              ),
                            ],
                          ),
                        );
                      }

                      if (trailState is TrailLoadedState) {
                        final featuredTrails =
                            trailState.trails.take(4).toList();

                        if (featuredTrails.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.nature_outlined,
                                  color: _stone,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "No trails to explore yet",
                                  style: TextStyle(color: _stone),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemCount: featuredTrails.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final trail = featuredTrails[index];
                            final isEasy =
                                trail.difficult.toLowerCase() == 'easy';

                            return Container(
                              width: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: _mist, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      trail.image,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                height: 120,
                                                color: _mist,
                                                child: Icon(
                                                  Icons.landscape,
                                                  color: _leafGreen,
                                                  size: 32,
                                                ),
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trail.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: _forestGreen,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    isEasy
                                                        ? _leafGreen
                                                            .withOpacity(0.15)
                                                        : Colors.orange
                                                            .withOpacity(0.15),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                trail.difficult,
                                                style: TextStyle(
                                                  color:
                                                      isEasy
                                                          ? _leafGreen
                                                          : Colors
                                                              .orange
                                                              .shade700,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.straighten,
                                                  size: 14,
                                                  color: _stone.withOpacity(
                                                    0.6,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "${trail.duration} min",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: _stone.withOpacity(
                                                      0.8,
                                                    ),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Explore More Section
                const Text(
                  "Explore More",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _forestGreen,
                  ),
                ),

                const SizedBox(height: 16),

                // Clean Tab Buttons
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _mist,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabButton(
                    selectedTab: selectedTab,
                    onTabSelected: (index) {
                      context.read<HomeViewModel>().onTabTapped(index);
                    },
                  ),
                ),

                const SizedBox(height: 20),
                buildBottomContent(selectedTab),

                const SizedBox(height: 32),

                // Clean CTA Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_leafGreen, _forestGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _leafGreen.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to trail planning
                    },
                    icon: const Icon(
                      Icons.add_location_alt_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    label: const Text(
                      "Plan Your Next Adventure",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
