import 'package:flutter/material.dart';

import '../../../feature/user/domain/entity/user_enum.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

Widget _buildFormField({
  required String label,
  required TextEditingController controller,
  required IconData icon,
  required bool isEditing,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  int maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    enabled: isEditing,
    keyboardType: keyboardType,
    maxLines: maxLines,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
      filled: !isEditing,
      fillColor: Colors.grey[100],
    ),
  );
}

Widget _buildDropdownField<T>({
  required String label,
  required T? value,
  required List<T> items,
  required bool isEditing,
  required void Function(T?) onChanged,
  required String Function(T) displayText,
}) {
  return DropdownButtonFormField<T>(
    value: value,
    onChanged: isEditing ? onChanged : null,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      filled: !isEditing,
      fillColor: Colors.grey[100],
    ),
    items:
        items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(displayText(item)),
          );
        }).toList(),
  );
}

// --- Helper Functions ---

String _getHikerTypeText(HikerType type) {
  switch (type) {
    case HikerType.newbie:
      return 'Beginner';
    case HikerType.experienced:
      return 'Intermediate';
  }
}

String _getAgeGroupText(AgeGroup age) {
  switch (age) {
    case AgeGroup.age18to24:
      return 'Youth (18-25)';
    case AgeGroup.age24to35:
      return 'Young Adult (24-35)';
    case AgeGroup.age35to44:
      return 'Adult (35-44)';
    case AgeGroup.age55to64:
      return 'Middle Aged (55-64)';
    case AgeGroup.age65plus:
      return 'Senior (60+)';
    default:
      return age.toString().split('.').last;
  }
}
