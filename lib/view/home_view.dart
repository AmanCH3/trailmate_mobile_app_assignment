import 'package:flutter/material.dart';
import 'package:trailmate_mobile_app_assignment/core/common/tab_button.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedTab = 0;

  final List<Map<String, dynamic>> featuredTrails = [
    {
      'title': 'Mountain Vista Trail',
      'difficulty': 'Moderate',
      'distance': 8.5,
      'imageUrl': 'https://picsum.photos/id/1011/200/150',
    },
    {
      'title': 'Coastal Cliffs Path',
      'difficulty': 'Easy',
      'distance': 5.2,
      'imageUrl': 'https://picsum.photos/id/1015/200/150',
    },
    {
      'title': 'Champadevi Hills Trails',
      'difficulty': 'Moderate',
      'distance': 8.2,
      'imageUrl':
          'https://www.lifedreamadventure.com/public/uploads/champadevi-hiking.jpg',
    },
    {
      'title': 'Shivapuri Hills Trails',
      'difficulty': 'Easy',
      'distance': 4.5,
      'imageUrl': 'https://picsum.photos/id/1025/200/150',
    },
  ];

  final List<Map<String, dynamic>> upcomingHikes = [
    {
      'title': 'Coastal Cliffs Path',
      'date': 'Sat, May 11',
      'distance': 5.2,
      'duration': '2 hrs',
      'status': 'Planned',
    },
  ];

  Widget getBottomContent() {
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${hike['date']} • ${hike['distance']} km • ${hike['duration']}',
                    ),
                    leading: Icon(Icons.route),
                    trailing: Icon(Icons.error, color: Colors.red),
                  ),
                );
              }).toList(),
        );
      case 1:
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hiking Tips",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "• Stay hydrated\n• Pack light but essential gear\n• Wear proper hiking boots",
              ),
            ],
          ),
        );
      case 2:
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Challenges",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "• Complete 3 hikes in a month\n• Hike 20km in a week\n• Join a community hike",
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Good Morning", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 4),
                    Text(
                      "Aman",
                      style: TextStyle(fontSize: 23, fontFamily: 'Lato black'),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Icon(Icons.wb_sunny, color: Colors.orange),
                    SizedBox(width: 4),
                    Text("24°C, Sunny", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),
            const Text(
              "Featured Trails",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featuredTrails.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final trail = featuredTrails[index];
                  return SizedBox(
                    width: 160,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            child: Image.network(
                              trail['imageUrl'],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trail['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            trail['difficulty'] == 'Easy'
                                                ? Colors.green[100]
                                                : Colors.orange[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        trail['difficulty'],
                                        style: TextStyle(
                                          color:
                                              trail['difficulty'] == 'Easy'
                                                  ? Colors.green
                                                  : Colors.orange,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${trail['distance']} km",
                                      style: TextStyle(fontSize: 12),
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
                },
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Explore More",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Toggle Buttons
            Container(
              color: Colors.white70,
              height: 60,
              alignment: Alignment.center,

              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //
              //   children: [
              //     ButtonTabButton(
              //       title: "Upcoming",
              //       index: 0,
              //       selectedTab: selectedTab,
              //       onTabSelected: (i) {
              //         setState(() {
              //           selectedTab = i;
              //         });
              //       },
              //     ),
              //     ButtonTabButton(
              //       title: "Tips",
              //       index: 1,
              //       selectedTab: selectedTab,
              //       onTabSelected: (i) {
              //         setState(() {
              //           selectedTab = i;
              //         });
              //       },
              //     ),
              //     ButtonTabButton(
              //       title: "Challenges",
              //       index: 2,
              //       selectedTab: selectedTab,
              //       onTabSelected: (i) {
              //         setState(() {
              //           selectedTab = i;
              //         });
              //       },
              //     ),
              //   ],
              // ),
              child: TabButton(
                // selectedTab: selectedTab,
                // onTabSelected: (index) {
                //   setState(() {
                //     selectedTab = index;
                //   });
                // },
              ),
            ),

            const SizedBox(height: 20),

            // Dynamic Bottom Section
            getBottomContent(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.add_location_alt_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  "Plan a New Hike",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
