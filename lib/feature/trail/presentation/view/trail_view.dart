// import 'package:flutter/material.dart';
//
// class TrailView extends StatefulWidget {
//
//   const TrailView({super.key});
//
//   @override
//   State<TrailView> createState() => _TrailViewState();
// }
//
// class _TrailViewState extends State<TrailView> {
//   int _selectedIndex = 1; // Trails tab is selected
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   final SearchController _searchController = SearchController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Search trails...',
//                       prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: BorderSide.none, // No border
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       // Light grey background
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 0,
//                         horizontal: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF66BB6A),
//                     // Green background for filter button
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.tune, color: Colors.white),
//                     onPressed: () {
//                       // Handle filter button action
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Trail Name
//                       Text(
//
//                         style: const TextStyle(
//                           fontSize: 22.0,
//                           fontWeight: FontWeight.bold,
//                           color:
//                               Colors
//                                   .black87, // Adjusted color for better contrast
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       // Trail Details (Location, Duration, Elevation)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         // Distribute space
//                         children: [
//                           _buildDetailItem(Icons.map, trail.location),
//                           _buildDetailItem(
//                             Icons.access_time,
//                             '${trail.durationHours.toInt()} hrs',
//                           ),
//                           _buildDetailItem(
//                             Icons.landscape,
//                             '${trail.elevationMeters} m',
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12.0),
//                       // Difficulty and Rating
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 5,
//                             ),
//                             decoration: BoxDecoration(
//                               color:
//                                   trail.difficulty == 'Moderate'
//                                       ? Colors.orange.shade100
//                                       : Colors.green.shade100,
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: Text(
//                               trail.difficulty,
//                               style: TextStyle(
//                                 color:
//                                     trail.difficulty == 'Moderate'
//                                         ? Colors.orange.shade800
//                                         : Colors.green.shade800,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13.0,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.star,
//                                 color: Colors.yellow.shade700,
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 '${trail.rating}',
//                                 style: const TextStyle(
//                                   fontSize: 16.0,
//                                   fontWeight: FontWeight.bold,
//                                   color:
//                                       Colors
//                                           .black87, // Adjusted color for better contrast
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // class TrailCard extends StatelessWidget {
// //   final String imagePath;
// //   final String trailName;
// //   final String location;
// //   final int durationHrs;
// //   final int elevationM;
// //   final String difficulty;
// //   final double rating;
// //
// //   const TrailCard({
// //     super.key,
// //     required this.imagePath,
// //     required this.trailName,
// //     required this.location,
// //     required this.durationHrs,
// //     required this.elevationM,
// //     required this.difficulty,
// //     required this.rating,
// //   });
//
// Widget _buildDetailItem(IconData icon, String text) {
//   return Row(
//     children: [
//       Icon(icon, size: 18, color: Colors.green.shade700),
//       const SizedBox(width: 4),
//       Text(
//         text,
//         style: const TextStyle(fontSize: 14.0, color: Colors.black54), // Adjusted color for better contrast
//       ),
//     ],
//   );
// }
// }
