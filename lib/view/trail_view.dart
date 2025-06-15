import 'package:flutter/material.dart';

class TrailView extends StatefulWidget {
  const TrailView({super.key});

  @override
  State<TrailView> createState() => _TrailViewState();
}

class _TrailViewState extends State<TrailView> {
  int _selectedIndex = 1; // Trails tab is selected

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final SearchController _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search trails...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none, // No border
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      // Light grey background
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF66BB6A),
                    // Green background for filter button
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: () {
                      // Handle filter button action
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class TrailCard extends StatelessWidget {
//   final String imagePath;
//   final String trailName;
//   final String location;
//   final int durationHrs;
//   final int elevationM;
//   final String difficulty;
//   final double rating;
//
//   const TrailCard({
//     super.key,
//     required this.imagePath,
//     required this.trailName,
//     required this.location,
//     required this.durationHrs,
//     required this.elevationM,
//     required this.difficulty,
//     required this.rating,
//   });
