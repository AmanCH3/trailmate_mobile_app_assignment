import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabSelected;

  const TabButton({required this.selectedTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (int i = 0; i < 3; i++)
          GestureDetector(
            onTap: () => onTabSelected(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selectedTab == i ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ['Upcoming', 'Tips', 'Challenges'][i],
                style: TextStyle(
                  color: selectedTab == i ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
