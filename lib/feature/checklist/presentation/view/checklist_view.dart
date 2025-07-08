// lib/features/checklist/presentation/view/checklist_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/checklist_item_entity.dart';
import '../view_model/checklist_event.dart';
import '../view_model/checklist_state.dart';
import '../view_model/checklist_view_model.dart';

class ChecklistBody extends StatefulWidget {
  const ChecklistBody({super.key});

  @override
  State<ChecklistBody> createState() => _ChecklistBodyState();
}

class _ChecklistBodyState extends State<ChecklistBody>
    with TickerProviderStateMixin {
  // Local state for the form inputs
  String _selectedExperience = 'new';
  String _selectedDuration = 'full-day';
  String _selectedWeather = 'mild';

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Map for dropdown display values vs API values
  final Map<String, String> _durationOptions = {
    'half-day': 'Half Day (2-4 hours)',
    'full-day': 'Full Day (4-8 hours)',
    'multi-day': 'Multi-Day (Overnight)',
  };

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _selectedExperience = 'new';
      _selectedDuration = 'full-day';
      _selectedWeather = 'mild';
    });
    context.read<ChecklistBloc>().add(ResetChecklist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 800;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildControlsCard()),
                          const SizedBox(width: 24),
                          Expanded(flex: 3, child: _buildDisplayPanel()),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildControlsCard(),
                          const SizedBox(height: 24),
                          _buildDisplayPanel(),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.8),
            Theme.of(context).primaryColor.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hiking, size: 24, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                'Hiking Checklist',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Get a personalized packing list tailored to your hiking experience and trip conditions.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Hiker Experience', Icons.person),
          const SizedBox(height: 16),
          _buildExperienceSelector(),
          const SizedBox(height: 32),
          _buildSectionTitle('Hike Duration', Icons.access_time),
          const SizedBox(height: 16),
          _buildDurationDropdown(),
          const SizedBox(height: 32),
          _buildSectionTitle('Expected Weather', Icons.wb_sunny),
          const SizedBox(height: 16),
          _buildWeatherSelector(),
          const SizedBox(height: 32),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildExperienceSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildAnimatedChoiceChip(
            label: 'New Hiker',
            icon: Icons.hiking,
            isSelected: _selectedExperience == 'new',
            onSelected: () => setState(() => _selectedExperience = 'new'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAnimatedChoiceChip(
            label: 'Experienced',
            icon: Icons.terrain,
            isSelected: _selectedExperience == 'experienced',
            onSelected:
                () => setState(() => _selectedExperience = 'experienced'),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedChoiceChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onSelected,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[800],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedDuration,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items:
            _durationOptions.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
        onChanged: (value) {
          if (value != null) setState(() => _selectedDuration = value);
        },
      ),
    );
  }

  Widget _buildWeatherSelector() {
    const weatherOptions = [
      {
        'key': 'mild',
        'label': 'Mild',
        'icon': Icons.wb_sunny_outlined,
        'color': Colors.orange,
      },
      {
        'key': 'hot',
        'label': 'Hot',
        'icon': Icons.local_fire_department_outlined,
        'color': Colors.red,
      },
      {
        'key': 'cold',
        'label': 'Cold',
        'icon': Icons.ac_unit_outlined,
        'color': Colors.blue,
      },
      {
        'key': 'rainy',
        'label': 'Rainy',
        'icon': Icons.water_drop_outlined,
        'color': Colors.indigo,
      },
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          weatherOptions.map((option) {
            final isSelected = _selectedWeather == option['key'];
            return _buildWeatherChip(
              label: option['label'] as String,
              icon: option['icon'] as IconData,
              color: option['color'] as Color,
              isSelected: isSelected,
              onSelected:
                  () => setState(
                    () => _selectedWeather = option['key'] as String,
                  ),
            );
          }).toList(),
    );
  }

  Widget _buildWeatherChip({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isSelected ? color : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onSelected,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: isSelected ? Colors.white : color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[800],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _resetForm,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<ChecklistBloc>().add(
                GenerateChecklistRequested(
                  experience: _selectedExperience,
                  duration: _selectedDuration,
                  weather: _selectedWeather,
                ),
              );
            },
            icon: const Icon(Icons.list_alt),
            label: const Text('Generate Checklist'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BlocBuilder<ChecklistBloc, ChecklistState>(
        builder: (context, state) {
          switch (state) {
            case ChecklistLoading():
              return _buildLoadingState();
            case ChecklistLoadFailure():
              return _buildErrorState(state.message);
            case ChecklistLoadSuccess():
              return _buildChecklistSuccess(state.checklist);
            case ChecklistInitial():
            default:
              return _buildInitialStatePrompt();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Generating your personalized checklist...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.red[600]),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialStatePrompt() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.checklist,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ready to Pack?',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'Select your hiking preferences and click "Generate Checklist" to get your personalized packing list.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistSuccess(Map<String, List<CheckListEntity>> checklist) {
    if (checklist.isEmpty) {
      return Container(
        height: 300,
        child: Center(
          child: Text(
            'No items were generated for these conditions.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
        ),
      );
    }

    final categories = checklist.keys.toList();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Your Hiking Checklist',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final items = checklist[category]!;
              final completedItems = items.where((item) => item.checked).length;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.toUpperCase(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                completedItems == items.length
                                    ? Colors.green.withOpacity(0.1)
                                    : Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$completedItems/${items.length}',
                            style: TextStyle(
                              color:
                                  completedItems == items.length
                                      ? Colors.green[700]
                                      : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    initiallyExpanded: true,
                    children:
                        items.map((item) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  item.checked
                                      ? Colors.green.withOpacity(0.05)
                                      : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CheckboxListTile(
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  decoration:
                                      item.checked
                                          ? TextDecoration.lineThrough
                                          : null,
                                  color: item.checked ? Colors.grey[600] : null,
                                ),
                              ),
                              value: item.checked,
                              onChanged: (bool? value) {
                                context.read<ChecklistBloc>().add(
                                  ToggleChecklistItem(
                                    category: category,
                                    itemId: item.id as int,
                                  ),
                                );
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.green,
                            ),
                          );
                        }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
