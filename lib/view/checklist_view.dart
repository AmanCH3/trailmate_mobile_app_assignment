// lib/features/checklist/presentation/view/checklist_page.dart

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../feature/checklist/domain/entity/checklist_item_entity.dart';
import '../feature/checklist/presentation/view_model/checklist_event.dart';
import '../feature/checklist/presentation/view_model/checklist_state.dart';
import '../feature/checklist/presentation/view_model/checklist_view_model.dart';

class ChecklistBody extends StatefulWidget {
  const ChecklistBody();

  @override
  State<ChecklistBody> createState() => _ChecklistBodyState();
}

class _ChecklistBodyState extends State<ChecklistBody> {
  // Local state for the form inputs
  String _selectedExperience = 'new';
  String _selectedDuration = 'full-day';
  String _selectedWeather = 'mild';

  // Map for dropdown display values vs API values
  final Map<String, String> _durationOptions = {
    'half-day': 'Half Day (2-4 hours)',
    'full-day': 'Full Day (4-8 hours)',
    'multi-day': 'Multi-Day (Overnight)',
  };

  void _resetForm() {
    setState(() {
      _selectedExperience = 'new';
      _selectedDuration = 'full-day';
      _selectedWeather = 'mild';
    });
    // Add the Reset event to the BLoC to clear the checklist result
    context.read<ChecklistBloc>().add(ResetChecklist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generate Your Checklist',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Customize your packing list based on your experience and trip details.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              // Use LayoutBuilder for a responsive UI
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
    );
  }

  Widget _buildControlsCard() {
    // ... (This method is correct, no changes needed)
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hiker Experience',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('New Hiker'),
                  selected: _selectedExperience == 'new',
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedExperience = 'new');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Text('Experienced'),
                  selected: _selectedExperience == 'experienced',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedExperience = 'experienced');
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Hike Duration', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedDuration,
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
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Expected Weather',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ChoiceChip(
                avatar: const Icon(Icons.wb_sunny_outlined),
                label: const Text('Mild'),
                selected: _selectedWeather == 'mild',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedWeather = 'mild');
                },
              ),
              ChoiceChip(
                avatar: const Icon(Icons.local_fire_department_outlined),
                label: const Text('Hot'),
                selected: _selectedWeather == 'hot',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedWeather = 'hot');
                },
              ),
              ChoiceChip(
                avatar: const Icon(Icons.ac_unit_outlined),
                label: const Text('Cold'),
                selected: _selectedWeather == 'cold',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedWeather = 'cold');
                },
              ),
              ChoiceChip(
                avatar: const Icon(Icons.water_drop_outlined),
                label: const Text('Rainy'),
                selected: _selectedWeather == 'rainy',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedWeather = 'rainy');
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              TextButton(onPressed: _resetForm, child: const Text('Reset')),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.read<ChecklistBloc>().add(
                    GenerateChecklistRequested(
                      experience: _selectedExperience,
                      duration: _selectedDuration,
                      weather: _selectedWeather,
                    ),
                  );
                },
                child: const Text('Generate Checklist'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayPanel() {
    // ... (This method is correct, no changes needed)
    return BlocBuilder<ChecklistBloc, ChecklistState>(
      builder: (context, state) {
        switch (state) {
          case ChecklistLoading():
            return const Center(child: CircularProgressIndicator());
          case ChecklistLoadFailure():
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            );
          case ChecklistLoadSuccess():
            return _buildChecklistSuccess(state.checklist);
          case ChecklistInitial():
          default:
            return _buildInitialStatePrompt();
        }
      },
    );
  }

  // THIS METHOD IS NOW CORRECT
  Widget _buildInitialStatePrompt() {
    return DottedBorder(
      child: Container(
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Select your hike details and click "Generate Checklist" to see your personalized packing list.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistSuccess(Map<String, List<CheckListEntity>> checklist) {
    // ... (This method is correct, no changes needed)
    if (checklist.isEmpty) {
      return const Center(
        child: Text('No items were generated for these conditions.'),
      );
    }
    final categories = checklist.keys.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final items = checklist[category]!;

        return Card(
          child: ExpansionTile(
            title: Text(
              category.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            initiallyExpanded: true,
            children:
                items.map((item) {
                  return CheckboxListTile(
                    title: Text(item.name),
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
                    activeColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
