import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_enum.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditing = false;

  // Form controllers
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
    _tabController = TabController(length: 2, vsync: this);
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
  }

  void _populateControllers(UserEntity user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.phone;
    _bioController.text = user.bio ?? '';
    _selectedHikerType = user.hikerType;
    _selectedAgeGroup = user.ageGroup;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state.onError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.onError!),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state.userEntity != null && !_isEditing) {
            _populateControllers(state.userEntity!);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.userEntity == null) {
            return const Center(child: Text('No user data available'));
          }

          return Column(
            children: [
              _buildCustomHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProfileTab(state.userEntity!),
                    _buildAchievementsTab(state.userEntity!),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
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
              if (!_isEditing)
                IconButton(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
              if (_isEditing) ...[
                TextButton(
                  onPressed: () {
                    setState(() => _isEditing = false);
                    final state = context.read<ProfileViewModel>().state;
                    if (state.userEntity != null) {
                      _populateControllers(state.userEntity!);
                    }
                  },
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

  Widget _buildTabBar() {
    return Container(
      color: Colors.green[700],
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Profile', icon: Icon(Icons.person)),
          Tab(text: 'Achievements', icon: Icon(Icons.emoji_events)),
        ],
      ),
    );
  }

  Widget _buildProfileTab(UserEntity user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProfileImageSection(user),
            const SizedBox(height: 24),
            _buildPersonalInfoCard(user),
            const SizedBox(height: 16),
            _buildHikingInfoCard(user),
            const SizedBox(height: 16),
            _buildStatsCard(user),
            if (_isEditing) ...[
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageSection(UserEntity user) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green[100],
              backgroundImage:
                  user.profileImage != null
                      ? NetworkImage(user.profileImage!)
                      : null,
              child:
                  user.profileImage == null
                      ? Icon(Icons.person, size: 60, color: Colors.green[700])
                      : null,
            ),
            if (_isEditing)
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
                    onPressed: () {
                      // Handle image picker
                    },
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
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

  Widget _buildPersonalInfoCard(UserEntity user) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              validator:
                  (value) => value?.isEmpty == true ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),
            _buildFormField(
              label: 'Email',
              controller: _emailController,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty == true) return 'Email is required';
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value!)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildFormField(
              label: 'Phone',
              controller: _phoneController,
              icon: Icons.phone,
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
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHikingInfoCard(UserEntity user) {
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
            _buildDropdownField(
              label: 'Hiker Type',
              value: _selectedHikerType,
              items: HikerType.values,
              onChanged:
                  _isEditing
                      ? (value) => setState(
                        () => _selectedHikerType = value as HikerType?,
                      )
                      : null,
              displayText: (type) => _getHikerTypeText(type),
            ),
            const SizedBox(height: 12),
            _buildDropdownField(
              label: 'Age Group',
              value: _selectedAgeGroup,
              items: AgeGroup.values,
              onChanged:
                  _isEditing
                      ? (value) =>
                          setState(() => _selectedAgeGroup = value as AgeGroup?)
                      : null,
              displayText: (age) => _getAgeGroupText(age),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(UserEntity user) {
    final stats = user.stats;
    if (stats == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hiking Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Trails Completed',
                    '${user.completedTrails?.length ?? 0}',
                    Icons.landscape,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Total Distance',
                    '${stats.totalDistance ?? 0} km',
                    Icons.straighten,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Time',
                    '${stats.totalHikes ?? 0} hrs',
                    Icons.timer,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Achievements',
                    '${user.achievements?.length ?? 0}',
                    Icons.emoji_events,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green[700], size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab(UserEntity user) {
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
    // This would typically fetch achievement details by ID
    // For now, showing placeholder data
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber[100],
          child: Icon(Icons.emoji_events, color: Colors.amber[700]),
        ),
        title: Text('Achievement ${achievementId.substring(0, 8)}'),
        subtitle: const Text('Earned for completing a challenging trail'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to achievement details
        },
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: !_isEditing,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<T> items,
    required void Function(T?)? onChanged,
    required String Function(T) displayText,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: !_isEditing,
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _deleteProfile,
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

  void _saveProfile() {
    if (_formKey.currentState?.validate() == true) {
      final currentUser = context.read<ProfileViewModel>().state.userEntity!;

      final updatedUser = UserEntity(
        userId: currentUser.userId,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: currentUser.password,
        // Keep existing password
        bio: _bioController.text.isEmpty ? null : _bioController.text,
        hikerType: _selectedHikerType,
        ageGroup: _selectedAgeGroup,
        emergencyContact: currentUser.emergencyContact,
        profileImage: currentUser.profileImage,
        role: currentUser.role,
        subscription: currentUser.subscription,
        active: currentUser.active,
        stats: currentUser.stats,
        achievements: currentUser.achievements,
        completedTrails: currentUser.completedTrails,
      );

      context.read<ProfileViewModel>().add(
        UpdateProfileEvent(userEntity: updatedUser),
      );
      setState(() => _isEditing = false);
    }
  }

  void _deleteProfile() {
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
}
