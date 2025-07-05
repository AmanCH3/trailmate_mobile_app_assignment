import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/core/common/my_snackbar.dart';
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';// import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view/create_group_page.dart';
// import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_view_model.dart';
import 'package:trailmate_mobile_app_assignment/state/bottom_navigation_state.dart';

class DashboardView extends StatelessWidget {
  final bool showSnackbar;

  const DashboardView({Key? key, this.showSnackbar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showMySnackBar(context: context, message: "Login Successful !");
      });
    }

    // BlocBuilder will rebuild the Scaffold whenever the BottomNavigationState changes
    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          // Only show AppBar when not on Profile tab (index 4)
          appBar:
              state.currentIndex != 4
                  ? AppBar(
                    title: Text(state.appBarTitle),
                    actions: [
                      if (state.currentIndex == 3)
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          tooltip: 'Create Group',
                          onPressed: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder:
                            //         (_) => BlocProvider.value(
                            //           value: BlocProvider.of<GroupViewModel>(context),
                            //           child: const CreateGroupPage(),
                            //         ),
                            //   ),
                            // );
                          },
                        ),

                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          showMySnackBar(
                            context: context,
                            message: 'Logging out...',
                            color: Colors.red,
                          );
                          context.read<HomeViewModel>().logout(context);
                        },
                      ),
                    ],
                  )
                  : null, // No AppBar for Profile tab
          body: state.currentScreen,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              context.read<BottomNavigationCubit>().updateIndex(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Trails'),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist),
                label: 'Checklist',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
