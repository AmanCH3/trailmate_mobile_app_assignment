import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// --- ADD THESE IMPORTS ---
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';

import '../feature/grouplist/domain/entity/group_entity.dart';
// The CreateGroupPage import is removed as it's no longer navigated to from this widget.
import '../feature/grouplist/presentation/view/group_list_item.dart';
import '../feature/grouplist/presentation/view_model/group_event.dart';
import '../feature/grouplist/presentation/view_model/group_state.dart';

class GroupView extends StatefulWidget {
  const GroupView({super.key});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  @override
  Widget build(BuildContext context) {
    // We use BlocConsumer directly as the root widget for this view.
    // It will listen for state changes to show SnackBars and
    // build the UI based on the current state (loading, loaded, error).
    return BlocConsumer<GroupViewModel, GroupState>(
      listener: (context, state) {
        if (state is GroupActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green.shade700,
            ),
          );
          // After a successful action (like creating or deleting a group),
          // refetch the list to show the latest data.
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
      builder: (context, state) {
        // This state represents the initial loading screen before any data is available.
        if (state is GroupLoading && state is! GroupsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        // This state is active when the groups have been successfully loaded.
        if (state is GroupsLoaded) {
          if (state.groups.isEmpty) {
            // Display a message if there are no groups.
            return const Center(
              child: Text(
                'No groups found.\nWhy not create one?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          // Display the list of groups with pull-to-refresh functionality.
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

        // This state is active when an error occurs during data fetching.
        if (state is GroupFailure) {
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
        // Fallback to a loading indicator for any other unhandled states.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
