// import 'package:flutter/material.dart';
//
// import 'info_card.dart';
//
// class PersonalInfoCard extends StatelessWidget {
//   final bool isEditing;
//   final TextEditingController nameController;
//   final TextEditingController emailController;
//   final TextEditingController phoneController;
//   final TextEditingController bioController;
//
//   const PersonalInfoCard({
//     required this.isEditing,
//     required this.nameController,
//     required this.emailController,
//     required this.phoneController,
//     required this.bioController,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InfoCard(
//       title: 'Personal Information',
//       children: [
//         _buildFormField(
//           label: 'Name',
//           controller: nameController,
//           icon: Icons.person,
//           isEditing: isEditing,
//           validator:
//               (value) => value?.isEmpty == true ? 'Name is required' : null,
//         ),
//         const SizedBox(height: 12),
//         _buildFormField(
//           label: 'Email',
//           controller: emailController,
//           icon: Icons.email,
//           isEditing: isEditing,
//           keyboardType: TextInputType.emailAddress,
//           validator: (value) {
//             if (value?.isEmpty == true) return 'Email is required';
//             if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
//               return 'Enter a valid email';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 12),
//         _buildFormField(
//           label: 'Phone',
//           controller: phoneController,
//           icon: Icons.phone,
//           isEditing: isEditing,
//           keyboardType: TextInputType.phone,
//           validator:
//               (value) => value?.isEmpty == true ? 'Phone is required' : null,
//         ),
//         const SizedBox(height: 12),
//         _buildFormField(
//           label: 'Bio',
//           controller: bioController,
//           icon: Icons.info,
//           isEditing: isEditing,
//           maxLines: 3,
//         ),
//       ],
//     );
//   }
// }
