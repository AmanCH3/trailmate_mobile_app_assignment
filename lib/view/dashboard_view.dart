import 'package:flutter/material.dart';
import 'package:trailmate_mobile_app_assignment/common/my_snackbar.dart';
import 'package:trailmate_mobile_app_assignment/view/checklist_view.dart';
import 'package:trailmate_mobile_app_assignment/view/group_view.dart';
import 'package:trailmate_mobile_app_assignment/view/home_view.dart';
import 'package:trailmate_mobile_app_assignment/view/profile_view.dart';
import 'package:trailmate_mobile_app_assignment/view/trail_view.dart';

class DashboardView extends StatefulWidget {
  final bool showSnackbar;

  const DashboardView({Key? key, this.showSnackbar = false}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    if (widget.showSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showMySnackbar(context: context, content: "Login Successful !");
      });
    }
  }

  int _currentIndex = 0;

  final List<Widget> screens = [
    HomeView(),
    const TrailView(),
    const GroupView(),
    const ChecklistView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Trails'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Checklist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
