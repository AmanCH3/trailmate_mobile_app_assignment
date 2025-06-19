import 'package:flutter/material.dart';

class ButtonTabButton extends StatelessWidget {
  final String title;
  final int index;
  final int selectedTab;
  final Function(int) onTabSelected;

  const ButtonTabButton({
    super.key,
    required this.title,
    required this.index,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedTab == index;

    return ElevatedButton(
      onPressed: () => onTabSelected(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(title),
    );
  }
}
