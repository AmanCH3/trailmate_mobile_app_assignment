// lib/feature/user/presentation/view/profile_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_enum.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view/hiking_stats_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<_ProfileTabState> _profileTabKey =
      GlobalKey<_ProfileTabState>();

  void _saveProfile() {
    _profileTabKey.currentState?.saveProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: MultiBlocListener(
          listeners: [
            BlocListener<ProfileViewModel, ProfileState>(
              listener: (context, state) {
                if (state.onError != null && state.onError!.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.onError!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            BlocListener<StatsViewModel, StatsState>(
              listener: (context, state) {
                if (state.status == StatsStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'An error occurred'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state.status == StatsStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hike saved successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.read<ProfileViewModel>().add(LoadProfileEvent());
                }
              },
            ),
          ],
          child: BlocBuilder<ProfileViewModel, ProfileState>(
            builder: (context, state) {
              if (state.isLoading && state.userEntity == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state?.userEntity == null) {
                return const Center(child: Text('No user data available'));
              }

              return Column(
                children: [
                  _buildCustomHeader(context, state),
                  _buildTabBar(context),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _ProfileTab(
                          key: _profileTabKey,
                          user: state.userEntity!,
                        ),
                        _AchievementsTab(user: state.userEntity!),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, ProfileState state) {
    final isEditing = state.isEditing ?? false;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: BoxDecoration(color: Colors.green[700]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (!isEditing)
                IconButton(
                  onPressed:
                      () => context.read<ProfileViewModel>().add(
                        ToggleEditModeEvent(),
                      ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
              if (isEditing) ...[
                TextButton(
                  onPressed:
                      () => context.read<ProfileViewModel>().add(
                        ToggleEditModeEvent(),
                      ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: Colors.green[700],
      child: const TabBar(
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorWeight: 3,
        tabs: [
          Tab(text: 'Profile', icon: Icon(Icons.person)),
          Tab(text: 'Achievements', icon: Icon(Icons.emoji_events)),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatefulWidget {
  final UserEntity user;

  const _ProfileTab({Key? key, required this.user}) : super(key: key);

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  HikerType? _selectedHikerType;
  AgeGroup? _selectedAgeGroup;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant _ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _bioController = TextEditingController(text: widget.user.bio ?? '');
    _selectedHikerType = widget.user.hikerType;
    _selectedAgeGroup = widget.user.ageGroup;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileViewModel, ProfileState>(
      builder: (context, state) {
        final isEditing = state.isEditing ?? false;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildProfileImageSection(context, widget.user, isEditing),
              const SizedBox(height: 24),
              _buildPersonalInfoCard(context, widget.user, isEditing),
              const SizedBox(height: 16),
              _buildHikingInfoCard(context, widget.user, isEditing),
              const SizedBox(height: 16),
              // This now works because the import was added
              HikingStatsCard(user: widget.user, isEditing: isEditing),
              if (isEditing) ...[
                const SizedBox(height: 24),
                _buildActionButtons(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImageSection(
    BuildContext context,
    UserEntity user,
    bool isEditing,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green[100],
              backgroundImage:
                  user.profileImage != null && user.profileImage!.isNotEmpty
                      ? NetworkImage(user.profileImage!)
                      : null,
              child:
                  (user.profileImage == null || user.profileImage!.isEmpty)
                      ? Icon(Icons.person, size: 60, color: Colors.green[700])
                      : null,
            ),
            if (isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name ?? 'No Name',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        if (user.hikerType != null)
          Chip(
            label: Text(_getHikerTypeText(user.hikerType!)),
            backgroundColor: Colors.green[100],
          ),
      ],
    );
  }

  Widget _buildPersonalInfoCard(
    BuildContext context,
    UserEntity user,
    bool isEditing,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Name',
                controller: _nameController,
                icon: Icons.person,
                isEditing: isEditing,
                validator:
                    (value) =>
                        value?.isEmpty == true ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              _buildFormField(
                label: 'Email',
                controller: _emailController,
                icon: Icons.email,
                isEditing: isEditing,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Email is required';
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value!))
                    return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildFormField(
                label: 'Phone',
                controller: _phoneController,
                icon: Icons.phone,
                isEditing: isEditing,
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value?.isEmpty == true ? 'Phone is required' : null,
              ),
              const SizedBox(height: 12),
              _buildFormField(
                label: 'Bio',
                controller: _bioController,
                icon: Icons.info,
                isEditing: isEditing,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHikingInfoCard(
    BuildContext context,
    UserEntity user,
    bool isEditing,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hiking Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDropdownField<HikerType>(
              label: 'Hiker Type',
              value: _selectedHikerType,
              items: HikerType.values,
              isEditing: isEditing,
              onChanged: (value) => setState(() => _selectedHikerType = value),
              displayText: (type) => _getHikerTypeText(type),
            ),
            const SizedBox(height: 12),
            _buildDropdownField<AgeGroup>(
              label: 'Age Group',
              value: _selectedAgeGroup,
              items: AgeGroup.values,
              isEditing: isEditing,
              onChanged: (value) => setState(() => _selectedAgeGroup = value),
              displayText: (age) => _getAgeGroupText(age),
            ),
          ],
        ),
      ),
    );
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
          items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(displayText(item)),
                ),
              )
              .toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showDeleteDialog(context),
            icon: const Icon(Icons.delete),
            label: const Text('Delete Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Profile'),
            content: const Text(
              'Are you sure you want to delete your profile? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<ProfileViewModel>().add(DeleteProfileEvent());
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void saveProfile(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      final updatedUser = UserEntity(
        // ✨ FIX 2: Changed `userId` to `id` to match UserEntity definition
        userId: widget.user.userId,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: widget.user.password,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
        hikerType: _selectedHikerType,
        ageGroup: _selectedAgeGroup,
        emergencyContact: widget.user.emergencyContact,
        profileImage: widget.user.profileImage,
        role: widget.user.role,
        subscription: widget.user.subscription,
        active: widget.user.active,
        stats: widget.user.stats,
        achievements: widget.user.achievements,
        completedTrails: widget.user.completedTrails,
        isInAGroup: widget.user.isInAGroup,
      );

      context.read<ProfileViewModel>().add(
        UpdateProfileEvent(userEntity: updatedUser),
      );
    }
  }

  String _getHikerTypeText(HikerType type) {
    switch (type) {
      case HikerType.newbie:
        return 'Newbie';
      case HikerType.experienced:
        return 'Experienced';
    }
  }

  String _getAgeGroupText(AgeGroup age) {
    switch (age) {
      case AgeGroup.age18to24:
        return '18-24';
      case AgeGroup.age24to35:
        return '24-35';
      case AgeGroup.age35to44:
        return '35-44';
      case AgeGroup.age45to54:
        return '45-54';
      case AgeGroup.age55to64:
        return '55-64';
      case AgeGroup.age65plus:
        return '65+';
    }
  }
}

class _AchievementsTab extends StatelessWidget {
  final UserEntity user;

  const _AchievementsTab({required this.user});

  @override
  Widget build(BuildContext context) {
    final achievements = user.achievements ?? [];

    return achievements.isEmpty
        ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No achievements yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Complete trails to earn achievements!',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            return _buildAchievementCard(achievements[index]);
          },
        );
  }

  Widget _buildAchievementCard(String achievementId) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber[100],
          child: Icon(Icons.emoji_events, color: Colors.amber[700]),
        ),
        title: Text('Achievement #${achievementId.substring(0, 6)}...'),
        subtitle: const Text('Earned for completing a challenging trail'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
