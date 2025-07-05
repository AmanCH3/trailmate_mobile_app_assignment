// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // You are likely missing an import for HikingInfoCard here
// import 'package:trailmate_mobile_app_assignment/core/common/profile/hiking_info_card.dart';
// import 'package:trailmate_mobile_app_assignment/core/common/profile/personal_info_card.dart';
// import 'package:trailmate_mobile_app_assignment/core/common/profile/profile_header.dart';
// import 'package:trailmate_mobile_app_assignment/core/common/profile/stat_card.dart';
//
// import '../../../feature/user/domain/entity/user_entity.dart';
// import '../../../feature/user/domain/entity/user_enum.dart';
// import '../../../feature/user/presentation/view_model/profile_view_model/profile_event.dart';
// import '../../../feature/user/presentation/view_model/profile_view_model/profile_state.dart';
// import '../../../feature/user/presentation/view_model/profile_view_model/profile_view_model.dart';
// import 'action_button.dart';
// import 'hiking_info.dart';
//
// class ProfileTab extends StatefulWidget {
//   final UserEntity user;
//
//   const ProfileTab({Key? key, required this.user}) : super(key: key);
//
//   @override
//   State<ProfileTab> createState() => _ProfileTabState();
// }
//
// class _ProfileTabState extends State<ProfileTab> {
//   // Fields
//   final _formKey = GlobalKey<FormState>();
//   late final TextEditingController _nameController;
//   late final TextEditingController _emailController;
//   late final TextEditingController _phoneController;
//   late final TextEditingController _bioController;
//   HikerType? _selectedHikerType;
//   AgeGroup? _selectedAgeGroup;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//   }
//
//   void _initializeControllers() {
//     final user = widget.user;
//     _nameController = TextEditingController(text: user.name);
//     _emailController = TextEditingController(text: user.email);
//     _phoneController = TextEditingController(text: user.phone);
//     _bioController = TextEditingController(text: user.bio ?? '');
//     _selectedHikerType = user.hikerType;
//     _selectedAgeGroup = user.ageGroup;
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _bioController.dispose();
//     super.dispose();
//   }
//
//   /// Public method exposed via GlobalKey to be called from the parent widget.
//   void saveProfile(BuildContext context) {
//     if (_formKey.currentState?.validate() == true) {
//       // This call will now work correctly
//       final updatedUser = widget.user.copyWith(
//         name: _nameController.text,
//         email: _emailController.text,
//         phone: _phoneController.text,
//         bio: _bioController.text.isEmpty ? null : _bioController.text,
//         hikerType: _selectedHikerType,
//         ageGroup: _selectedAgeGroup,
//       );
//       context.read<ProfileViewModel>().add(
//         UpdateProfileEvent(userEntity: updatedUser),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileViewModel, ProfileState>(
//       builder: (context, state) {
//         final isEditing = state.isEditing ?? false;
//
//         return Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ProfileHeader(user: widget.user, isEditing: isEditing),
//                 const SizedBox(height: 24),
//                 PersonalInfoCard(
//                   isEditing: isEditing,
//                   nameController: _nameController,
//                   emailController: _emailController,
//                   phoneController: _phoneController,
//                   bioController: _bioController,
//                 ),
//                 const SizedBox(height: 16),
//                 HikingInfoCard(
//                   isEditing: isEditing,
//                   selectedHikerType: _selectedHikerType,
//                   selectedAgeGroup: _selectedAgeGroup,
//                   onHikerTypeChanged:
//                       (value) => setState(() => _selectedHikerType = value),
//                   onAgeGroupChanged:
//                       (value) => setState(() => _selectedAgeGroup = value),
//                 ),
//                 const SizedBox(height: 16),
//                 if (widget.user.stats != null) StatsCard(user: widget.user),
//                 if (isEditing) ...[const SizedBox(height: 24), ActionButtons()],
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
