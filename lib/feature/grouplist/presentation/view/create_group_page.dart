import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';

import '../../domain/usecase/create_group_usecase.dart';
import '../view_model/group_event.dart';
import '../view_model/group_state.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxSizeController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedTrailId;
  final List<String> _imagePaths = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxSizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _imagePaths.addAll(pickedFiles.map((xfile) => xfile.path));
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a date.')));
        return;
      }
      if (_selectedTrailId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a trail.')));
        return;
      }

      final params = CreateGroupParams(
        title: _titleController.text,
        description: _descriptionController.text,
        maxSize: int.parse(_maxSizeController.text),
        date: _selectedDate!,
        trailId: _selectedTrailId!,
        photoPaths: _imagePaths,
      );

      context.read<GroupViewModel>().add(CreateGroupEvent(params: params));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Group')),
      body: BlocListener<GroupViewModel, GroupState>(
        // Listen for the result of the create action
        listener: (context, state) {
          if (state is GroupActionSuccess) {
            // If creation is successful, pop back to the list page
            Navigator.of(context).pop();
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Group Title'),
                  validator:
                      (value) => value!.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 16),
                // In a real app, this would fetch trails from another BLoC/API
                DropdownButtonFormField<String>(
                  value: _selectedTrailId,
                  hint: const Text('Select a Trail'),
                  items: const [
                    // Replace with actual Trail data
                    DropdownMenuItem(
                      value: 'trail_id_1',
                      child: Text('Everest Base Camp'),
                    ),
                    DropdownMenuItem(
                      value: 'trail_id_2',
                      child: Text('Annapurna Circuit'),
                    ),
                  ],
                  onChanged:
                      (value) => setState(() => _selectedTrailId = value),
                  validator:
                      (value) => value == null ? 'Please select a trail' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _maxSizeController,
                  decoration: const InputDecoration(
                    labelText: 'Max Group Size',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Please enter a group size' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No date chosen'
                            : 'Date: ${DateFormat.yMd().format(_selectedDate!)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Choose Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Photos:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._imagePaths.map(
                      (path) => SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.file(File(path), fit: BoxFit.cover),
                      ),
                    ),
                    InkWell(
                      onTap: _pickImages,
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Create Group'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
