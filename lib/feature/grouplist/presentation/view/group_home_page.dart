import 'package:flutter/material.dart';

import 'group_list_page.dart';
import 'my_group_page.dart';

class GroupHomePage extends StatelessWidget {
  const GroupHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.group), text: "All Groups"),
              Tab(icon: Icon(Icons.chat), text: "My Groups"),
            ],
          ),
        ),
        body: const TabBarView(children: [GroupListPage(), MyGroupsPage()]),
      ),
    );
  }
}
