// import 'package:flutter/cupertino.dart';
//
// import '../../../feature/user/domain/entity/user_enum.dart';
// import 'info_card.dart';
//
// class HikingInfoCard extends StatelessWidget {
//   final bool isEditing;
//   final HikerType? selectedHikerType;
//   final AgeGroup? selectedAgeGroup;
//   final ValueChanged<HikerType?> onHikerTypeChanged;
//   final ValueChanged<AgeGroup?> onAgeGroupChanged;
//
//   const HikingInfoCard({
//     required this.isEditing,
//     required this.selectedHikerType,
//     required this.selectedAgeGroup,
//     required this.onHikerTypeChanged,
//     required this.onAgeGroupChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InfoCard(
//       title: 'Hiking Information',
//       children: [
//         DropdownField<HikerType>(
//           label: 'Hiker Type',
//           value: selectedHikerType,
//           items: HikerType.values,
//           isEditing: isEditing,
//           onChanged: onHikerTypeChanged,
//           displayText: (type) => getHikerTypeText(type),
//         ),
//         const SizedBox(height: 12),
//         _buildDropdownField<AgeGroup>(
//           label: 'Age Group',
//           value: selectedAgeGroup,
//           items: AgeGroup.values,
//           isEditing: isEditing,
//           onChanged: onAgeGroupChanged,
//           displayText: (age) => _getAgeGroupText(age),
//         ),
//       ],
//     );
//   }
// }
