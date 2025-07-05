// import 'package:flutter/material.dart';
//
// import '../../../feature/user/domain/entity/user_entity.dart';
//
// class ProfileHeader extends StatelessWidget {
//   final UserEntity user;
//   final bool isEditing;
//
//   const ProfileHeader({required this.user, required this.isEditing});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             CircleAvatar(
//               radius: 60,
//               backgroundColor: Colors.green[100],
//               backgroundImage:
//                   user.profileImage != null
//                       ? NetworkImage(user.profileImage!)
//                       : null,
//               child:
//                   user.profileImage == null
//                       ? Icon(Icons.person, size: 60, color: Colors.green[700])
//                       : null,
//             ),
//             if (isEditing)
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: CircleAvatar(
//                   radius: 22,
//                   backgroundColor: Colors.white,
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundColor: Colors.green[700],
//                     child: IconButton(
//                       icon: const Icon(
//                         Icons.camera_alt,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                       onPressed: () {
//                         /* Handle image picker */
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Text(
//           user.name,
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         if (user.hikerType != null)
//           Chip(
//             label: Text(getHikerTypeText(user.hikerType!)),
//             backgroundColor: Colors.green[100],
//           ),
//       ],
//     );
//   }
// }
