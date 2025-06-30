import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';

import '../../domain/entity/group_entity.dart';
import '../view_model/group_event.dart';
import '../view_model/group_state.dart';
import 'create_group_page.dart';
import 'group_list_item.dart';

class GroupListPage extends StatelessWidget {
  const GroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hike Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Create Group',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: BlocProvider.of<GroupViewModel>(context),
                        child: const CreateGroupPage(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<GroupViewModel, GroupState>(
        // The listener handles one-time actions like showing SnackBars or dialogs.
        // It's perfect for responding to success or failure actions.
        listener: (context, state) {
          if (state is GroupActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green.shade700,
              ),
            );
            // After a successful action, we want to refresh the list.
            context.read<GroupViewModel>().add(FetchAllGroupsEvent());
          } else if (state is GroupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        // The builder is responsible for building the UI that reflects the current state.
        builder: (context, state) {
          if (state is GroupLoading && state is! GroupsLoaded) {
            // Show a full-screen loader only on the initial load.
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroupsLoaded) {
            if (state.groups.isEmpty) {
              return const Center(
                child: Text(
                  'No groups found.\nWhy not create one?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            // If we have groups, display them in a list.
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GroupViewModel>().add(FetchAllGroupsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  final GroupEntity group = state.groups[index];
                  return GroupListItem(group: group);
                },
              ),
            );
          }

          if (state is GroupFailure) {
            // Show an error view with a retry button.
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GroupViewModel>().add(FetchAllGroupsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          // Default/Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
