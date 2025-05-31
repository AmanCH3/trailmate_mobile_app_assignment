import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  const TabButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 6),
                    Text("Upcoming"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tips_and_updates_outlined),
                    SizedBox(width: 6),
                    Text("Tips"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.difference_outlined),
                    SizedBox(width: 6),
                    Text("Challenges"),
                  ],
                ),
              ),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            Center(child: Text('Upcoming')),
            Center(child: Text("Tips")),
            Center(child: Text("Challenges")),
          ],
        ),
      ),
    );
  }
}
