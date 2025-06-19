import 'package:flutter/material.dart';

class BottomContent extends StatelessWidget {
  final int selectedTab;
  final List<Map<String, dynamic>> upcomingHikes;

  const BottomContent({
    Key? key,
    required this.selectedTab,
    required this.upcomingHikes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              upcomingHikes.map((hike) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      hike['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${hike['date']} • ${hike['distance']} km • ${hike['duration']}',
                    ),
                    leading: const Icon(Icons.route),
                    trailing: const Icon(Icons.event, color: Colors.blue),
                  ),
                );
              }).toList(),
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Hiking Tips",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "• Stay hydrated\n• Pack light but essential gear\n• Wear proper hiking boots",
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Challenges",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "• Complete 3 hikes in a month\n• Hike 20km in a week\n• Join a community hike",
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }
}
