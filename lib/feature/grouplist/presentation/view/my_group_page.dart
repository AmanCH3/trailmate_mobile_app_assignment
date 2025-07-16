import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view/chat_screen.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';

import '../view_model/group_state.dart';

class MyGroupsPage extends StatelessWidget {
  const MyGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupViewModel, GroupState>(
        builder: (context, state) {
          if (state is GroupLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroupsLoaded) {
            // FILTER groups the user has joined
            final joinedGroups =
                state.groups
                    .where(
                      (group) => group.participants.any(
                        (p) =>
                            p.user?.userId ==
                            context.read<GroupViewModel>().currentUserId,
                      ),
                    )
                    .toList();

            if (joinedGroups.isEmpty) {
              return const Center(
                child: Text(
                  "You haven't joined any groups yet.",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: joinedGroups.length,
              itemBuilder: (context, index) {
                final group = joinedGroups[index];
                return ListTile(
                  title: Text(group.title),
                  subtitle: Text(group.description),
                  trailing: const Icon(Icons.chat),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => ChatScreen(
                              groupId: group.id,
                              currentUserId:
                                  context
                                      .read<GroupViewModel>()
                                      .currentUserId
                                      .toString(),
                            ),
                      ),
                    );
                  },
                );
              },
            );
          }

          if (state is GroupFailure) {
            return Center(child: Text(state.message));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
